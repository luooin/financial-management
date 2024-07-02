package cn.itcast.invoice.controller;

import cn.hutool.core.date.DateUtil;
import cn.itcast.feign.clients.TransactionClient;
import cn.itcast.feign.clients.UserClient;
import cn.itcast.feign.dto.InvoicePage;
import cn.itcast.feign.pojo.*;
import cn.itcast.invoice.service.InvoiceService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;


@Slf4j
@RestController
@RequestMapping("/dev-api/invoice")
public class InvoiceController {

    @Resource
    private InvoiceService invoiceService;

    @Resource
    private UserClient userClient;

    @Cacheable(value = "InvoiceId",key = "#id")
    @GetMapping("/{id}")
    public Result<Invoice> getByid(@PathVariable Long id) {
        return Result.success(invoiceService.getById(id));
    }

    @PostMapping("/list")
    public Result<Page<Invoice>> getList(@RequestBody mPage page ) {
        LambdaQueryWrapper<Invoice> wrapper = new LambdaQueryWrapper<Invoice>();
        Page<Invoice> repage = new Page<>(page.getPage(),page.getSize());
        wrapper.orderBy(true,true,Invoice::getStatus,Invoice::getIssueDate);
        invoiceService.page(repage,wrapper);
        List<Invoice> records = repage.getRecords();
        for(Invoice inv : records){
            Long userId = inv.getUserId();
            Employee em = userClient.getById(userId);
            inv.setEmployee(em);
        }
        return Result.success(repage);
    }

    @Cacheable(value = "numbers")
    @GetMapping("/getNumber")
    public List<String> getNumbers(){
        return invoiceService.getNumbers();
    }

    @GetMapping("/getUser")
    public List<Employee> getUsers(){
        return userClient.getEmployees();
    }

    @Cacheable("invoiceList")
    @PostMapping("/listwith")
    public Result<Page<Invoice>> getListWithP(@RequestBody InvoicePage invoice){
        Page<Invoice> repage = new Page<>(invoice.getPage(),invoice.getSize());
        LambdaQueryWrapper<Invoice> wrapper = new LambdaQueryWrapper<Invoice>();
        if(!StringUtils.isBlank(invoice.getUserId()))
            wrapper.eq(Invoice::getUserId,invoice.getUserId());
        if(!StringUtils.isBlank(invoice.getNumber()))
            wrapper.eq(Invoice::getNumber,invoice.getNumber());
        if(!StringUtils.isBlank(String.valueOf(invoice.getApproveStatus())))
            if(!"null".equals(String.valueOf(invoice.getApproveStatus())))
                wrapper.eq(Invoice::getApproveStatus,invoice.getApproveStatus());
        if(!StringUtils.isBlank(String.valueOf(invoice.getIssueDate()))){
            if(!"null".equals(String.valueOf(invoice.getIssueDate())))
                wrapper.eq(Invoice::getIssueDate,invoice.getIssueDate());
        }
        wrapper.orderBy(true,true,Invoice::getStatus,Invoice::getIssueDate);
        invoiceService.page(repage,wrapper);
        List<Invoice> records = repage.getRecords();
        for(Invoice inv : records){
            Long userId = inv.getUserId();
            Employee em = userClient.getById(userId);
            inv.setEmployee(em);
        }
        return Result.success(repage);
    }


    @CacheEvict(value = {"InvoiceId","invoiceList","numbers"},allEntries = true)
    @PutMapping("/update")
    public Result updateInvoice(@RequestBody Invoice invoice){
        LambdaQueryWrapper<Invoice> wrapper = new LambdaQueryWrapper<Invoice>();
        wrapper.eq(Invoice::getId,invoice.getId());
        boolean update = invoiceService.update(invoice, wrapper);
        if(update)
            return Result.success("修改成功！");
        return Result.error("修改失败，请检查后再试");
    }

    @CacheEvict(value = {"InvoiceId","invoiceList","numbers"},allEntries = true)
    @DeleteMapping("/delete/{id}")
    public Result deleteInvoice(@PathVariable Long id){
        boolean delete = invoiceService.removeById(id);
        if(delete)
            return Result.success("删除成功！");
        return Result.error("删除失败，请检查后再试");
    }

    @CacheEvict(value = {"InvoiceId","invoiceList","numbers"},allEntries = true)
    @PostMapping("/add")
    public Result addInvoice(@RequestBody Invoice invoice){
        invoice.setStatus(0);
        invoice.setApproveStatus(0);
        int add = invoiceService.insert(invoice);
        if(add>0)
            return Result.success("添加成功！");
        return Result.error("添加失败，请检查后再试");
    }

    @Autowired
    private TransactionClient transactionClient;

    @CacheEvict(value = {"InvoiceId","invoiceList","numbers"},allEntries = true)
    @PutMapping("/updateStatus/{flag}")
    public Result updateStatus(@RequestBody Invoice invoice,@PathVariable int flag){
        int i=0;
        if(flag==1){
            i= invoiceService.updateStatusByid(flag, invoice.getId());
            FinancialTransaction transaction = new FinancialTransaction();
            transaction.setAmount(invoice.getTotalAmount().intValue());
            transaction.setCategory("发票报销");
            transaction.setDescription("发票报销");
            transaction.setPaymentMethod("银行转账");
            transaction.setEmployeeId(invoice.getEmployee().getId());
            Date date = DateUtil.date();
            transaction.setDate(date);
            transaction.setTransactionType("支出");
            transaction.setDepartmentId(4);
            transactionClient.addOrder(transaction);
        }
        else if (flag==2)
            i= invoiceService.updateStatusByid(flag, invoice.getId());
        if(i>0)
            return Result.success("审批成功");
        return Result.error("审批失败，请重试");
    }


}
