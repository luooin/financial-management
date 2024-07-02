package cn.itcast.off.controller;

import cn.itcast.feign.clients.UserClient;
import cn.itcast.feign.dto.OffPage;
import cn.itcast.feign.pojo.*;
import cn.itcast.off.service.OffService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/off")
public class OffController {

    @Autowired
    private OffService offService;

    @Autowired
    private UserClient userClient;

    @PostMapping("/all")
    public Result<Page<Off>> getAll(@RequestBody mPage page){
        Page<Off> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<Off> wrapper = new LambdaQueryWrapper<Off>();
        wrapper.orderBy(true,true,Off::getStatus,Off::getEndDate);
        offService.page(repage, wrapper);
        return Result.success(repage);
    }

    @Cacheable(value = "offList", key="#root.args[0]")
    @PostMapping("/listwith")
    public Result<Page<Off>> getListWithP(@RequestBody OffPage off){
        Page<Off> repage = new Page<>(off.getPage(),off.getSize());
        LambdaQueryWrapper<Off> wrapper = new LambdaQueryWrapper<Off>();
        if(!StringUtils.isBlank(String.valueOf(off.getStatus())))
            if(!"null".equals(String.valueOf(off.getStatus())))
                wrapper.eq(Off::getStatus,off.getStatus());
        if(!StringUtils.isBlank(String.valueOf(off.getEndDate()))){
            if(!"null".equals(String.valueOf(off.getEndDate())))
                wrapper.eq(Off::getEndDate,off.getEndDate());
        }
        if(!StringUtils.isBlank(String.valueOf(off.getStartDate()))){
            if(!"null".equals(String.valueOf(off.getStartDate())))
                wrapper.eq(Off::getStartDate,off.getStartDate());
        }
        if(!StringUtils.isBlank(off.getEmployeeName()))
            if(!"null".equals(String.valueOf(off.getEmployeeName())))
                wrapper.eq(Off::getEmployeeName,off.getEmployeeName());
        if(!StringUtils.isBlank(off.getLeaveType()))
            if(!"null".equals(String.valueOf(off.getLeaveType())))
                wrapper.eq(Off::getLeaveType,off.getLeaveType());
        wrapper.orderBy(true,true,Off::getStatus,Off::getEndDate);
        offService.page(repage,wrapper);
        return Result.success(repage);
    }

    @CacheEvict(value = "offList",allEntries=true)
    @PutMapping("/updateStatus/{flag}")
    public Result updateStatus(@RequestBody Off off,@PathVariable int flag){
        int i=0;
        if(flag==1){
            i= offService.updateStatusByid(flag,off.getId());}
        else if (flag==2)
            i= offService.updateStatusByid(flag,off.getId());
        if(i>0)
            return Result.success("审批成功");
        return Result.error("审批失败，请重试");
    }


    @PostMapping("/add")
    @CacheEvict(value = "offList",allEntries=true)
    public Result addOff(@RequestBody Off off){
        off.setStatus(0);
        Employee name = userClient.getById(off.getEmployeeId());
        off.setEmployeeName(name.getName());
        boolean add = offService.save(off);
        if(add)
            return Result.success("添加成功！");
        return Result.error("添加失败，请检查后再试");
    }

    @DeleteMapping("/delete/{id}")
    @CacheEvict(value = "offList",allEntries=true)
    public Result deleteOff(@PathVariable Long id){
        boolean b = offService.removeById(id);
        if(b)
            return Result.success("删除成功");
        return Result.error("删除失败");
    }

    @PutMapping("/update")
    @CacheEvict(value = "offList",allEntries=true)
    public Result updateOff(@RequestBody Off off){
        LambdaQueryWrapper<Off> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Off::getId,off.getId());
        boolean update = offService.update(off, wrapper);
        if(update)
            return Result.success("修改成功");
        return Result.error("修改失败");
    }

    @Cacheable(value = "userList", key = "'users'")
    @GetMapping("/getUser")
    public List<Employee> getUsers(){
        return userClient.getEmployees();
    }

}
