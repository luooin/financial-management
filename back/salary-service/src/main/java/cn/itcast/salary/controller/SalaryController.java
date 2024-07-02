package cn.itcast.salary.controller;

import cn.hutool.core.date.DateUtil;
import cn.itcast.feign.clients.TransactionClient;
import cn.itcast.feign.clients.UserClient;
import cn.itcast.feign.dto.CompareSalary;
import cn.itcast.feign.dto.SalaryDto;
import cn.itcast.feign.pojo.*;
import cn.itcast.salary.service.SalaryService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.google.common.collect.BiMap;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionalEventListener;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
@Slf4j
@RestController
@RequestMapping("/salary")
public class SalaryController {

    @Autowired
    private UserClient userClient;

    @Autowired
    private SalaryService salaryService;

    @GetMapping("/{userId}")
    public List<Salary> getSalaryByUserId(@PathVariable Long userId) {
        return salaryService.getSalaryByUserId(userId);
    }

    @PostMapping("/list")
    public Result<Page> getList(@RequestBody mPage page){
        Page<Salary> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<Salary> wrapper = new LambdaQueryWrapper<Salary>();
        wrapper.orderByAsc(Salary::getStatus);
        wrapper.orderByDesc(Salary::getSalaryMonth);
        salaryService.page(repage,wrapper);
        for (Salary s : repage.getRecords()) {
            double original =s.getGetSalary()-s.getBasicSalary()*s.getOffDays()/22;
            double cel = original %1;
            original= original-cel;
            s.setGetSalary(original);
//            s.setGetSalary(s.getGetSalary()-s.getBasicSalary()*s.getOffDays()/22);
            Employee user = userClient.getById(Long.parseLong(String.valueOf(s.getEmployeeId())));
            s.setEmployeeName(user.getName());
            s.setPosition(user.getPosition());
            s.setRanking(user.getRanking());
            s.setHireDate(user.getHireDate());
        }
        return Result.success(repage);
    }

    @Cacheable(value = "salaryList")
    @PostMapping("/listwith")
    public Result<Page<Salary>> getListWithP(@RequestBody SalaryDto salaryDto){
        Page<Salary> repage = new Page<>(salaryDto.getPage(),salaryDto.getSize());
        LambdaQueryWrapper<Salary> wrapper = new LambdaQueryWrapper<Salary>();
        if(!StringUtils.isBlank(String.valueOf(salaryDto.getRanking())))
            if(!"null".equals(String.valueOf(salaryDto.getRanking())))
                wrapper.eq(Salary::getRanking,salaryDto.getRanking());
        if(!StringUtils.isBlank(salaryDto.getEmployeeId()))
            if(!"null".equals(salaryDto.getEmployeeId()))
                wrapper.eq(Salary::getEmployeeId,salaryDto.getEmployeeId());
        if(!StringUtils.isBlank(salaryDto.getPercent()))
            if(!"null".equals(salaryDto.getPercent()))
                wrapper.eq(Salary::getPercent,salaryDto.getPercent());
        if(salaryDto.getSalaryMonth()!=null ){
            if(salaryDto.getSalaryMonth().size() > 0)
                wrapper.between(Salary::getSalaryMonth,salaryDto.getSalaryMonth().get(0),salaryDto.getSalaryMonth().get(1));
        }
        wrapper.orderByAsc(Salary::getStatus);
        wrapper.orderByDesc(Salary::getSalaryMonth);
        salaryService.page(repage,wrapper);
        for (Salary s : repage.getRecords()) {
            double original =s.getGetSalary()-s.getBasicSalary()*s.getOffDays()/22;
            double cel = original %1;
            original= original-cel;
            s.setGetSalary(original);
            Employee user = userClient.getById(Long.parseLong(String.valueOf(s.getEmployeeId())));
            s.setEmployeeName(user.getName());
            s.setPosition(user.getPosition());
            s.setRanking(user.getRanking());
            s.setHireDate(user.getHireDate());
        }
        return Result.success(repage);
    }

    @Autowired
    private TransactionClient transactionClient;

    @CacheEvict(value = "salaryList",allEntries = true)
    @PostMapping("/add")
    public Result addSalary(@RequestBody Salary salary){
        Employee id = userClient.getById((long) salary.getEmployeeId());
        List<Salary> sa = id.getSalary();
        //判断该月是否已生成工资
        LambdaQueryWrapper<Salary> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(Salary::getEmployeeId,salary.getEmployeeId());
        lambdaQueryWrapper.eq(Salary::getSalaryMonth,salary.getSalaryMonth());
        Salary one = salaryService.getOne(lambdaQueryWrapper);
        if(one != null)
            return Result.error("该员工该月已生成工资单");
        salary.setHireDate(id.getHireDate());
        salary.setBasicSalary(sa.get(0).getBasicSalary());
        salary.setPerformanceSalary(sa.get(0).getPerformanceSalary());
        salary.setHousingFundBase(sa.get(0).getHousingFundBase());
        salary.setHousingFundRate(sa.get(0).getHousingFundRate());
        salary.setSocialSecurityBase(sa.get(0).getSocialSecurityBase());
        salary.setSocialSecurityRate(sa.get(0).getSocialSecurityRate());
        salary.setPosition(id.getPosition());
        salary.setRanking(id.getRanking());
        boolean add = salaryService.save(salary);
        //添加记录到支出

        if(add)
            return Result.success("添加成功！");
        return Result.error("添加失败，请检查后再试");
    }

    @CacheEvict(value = "salaryList",allEntries = true)
    @PutMapping("/updateStatus/{flag}")
    @Transactional
    public Result updateStatus(@RequestBody Salary salary,@PathVariable int flag){
        int i=0;
        if(flag==1){
            i= salaryService.updateStatusByid(flag,salary.getId());
            FinancialTransaction transaction = new FinancialTransaction();
            transaction.setAmount(salary.getGetSalary().intValue());
            transaction.setCategory("工资");
            transaction.setDescription("支付工资");
            transaction.setPaymentMethod("银行转账");
            transaction.setEmployeeId(salary.getEmployeeId());
            Date date = DateUtil.date();
            transaction.setDate(date);
            transaction.setTransactionType("支出");
            transaction.setDepartmentId(4);
            transactionClient.addOrder(transaction);
        }
        else if (flag==2){
            i= salaryService.updateStatusByid(flag,salary.getId());}
        if(i>0)
            return Result.success("审批成功");
        return Result.error("审批失败，请重试");
    }

    @CacheEvict(value = "salaryList",allEntries = true)
    @DeleteMapping("/delete/{id}")
    public Result deleteOff(@PathVariable Long id){
        boolean b = salaryService.removeById(id);
        if(b)
            return Result.success("删除成功");
        return Result.error("删除失败");
    }

    @CacheEvict(value = "salaryList",allEntries = true)
    @PutMapping("/update")
    public Result updateSalary(@RequestBody Salary salary){
        LambdaQueryWrapper<Salary> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Salary::getId,salary.getId());
        boolean update = salaryService.update(salary, wrapper);
        if(update)
            return Result.success("修改成功");
        return Result.error("修改失败");
    }

    @PostMapping("/compare")
    public List compare(@RequestBody CompareSalary a){
        List<List> result = new ArrayList();
        List param = new ArrayList();
        param.add("product");
        param.add("社保");
        param.add("公积金");
        param.add("工资");
        result.add(param);
        int[] ids = a.getId();
        for (int i = 0; i < ids.length; i++) {
            LambdaQueryWrapper<Salary> wrapper = new LambdaQueryWrapper<Salary>();
            wrapper.eq(Salary::getSalaryMonth,a.getSalaryMonth());
            wrapper.eq(Salary::getEmployeeId,ids[i]);
            Salary one = salaryService.getOne(wrapper);
            List pa = new ArrayList();
            String name = userClient.getName(ids[i]);
            pa.add(name);
            pa.add(one.getSocialSecurityBase()*one.getSocialSecurityRate());
            pa.add(one.getHousingFundBase()*one.getHousingFundRate()*2);
            pa.add(one.getGetSalary());
            result.add(pa);
        }
        return result;
    }

}
