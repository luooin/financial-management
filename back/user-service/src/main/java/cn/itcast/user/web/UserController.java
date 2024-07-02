package cn.itcast.user.web;

import cn.itcast.feign.dto.UserDto;
import cn.itcast.feign.pojo.Employee;
import cn.itcast.feign.pojo.Result;
import cn.itcast.feign.pojo.mPage;
import cn.itcast.user.service.UserService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@CrossOrigin(origins = {"http://localhost:9528","*"})
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 路径： /user/id
     *
     * @param id 用户id
     * @return 用户
     */
    @GetMapping("/{id}")
    public Employee queryById(@PathVariable("id") Long id) {
        return userService.queryById(id);
    }

    @PostMapping("/login")
    public Result login(@RequestBody Employee user){
        return userService.checkLogin(user);
    }

    @Cacheable(value = "employees")
    @GetMapping("/list")
    public List<Employee> getEmployees(){
        return userService.getAll();
    }

    @Cacheable(value = "userName",key = "#id")
    @GetMapping("/name/{id}")
    public String getName(@PathVariable int id){
        return userService.getName(id);
    }

    @PostMapping("/listcj")
    public Result<Page> getList(@RequestBody mPage page){
        Page<Employee> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<Employee> query = new LambdaQueryWrapper<>();
        query.eq(Employee::getRanking,"初级");
        query.orderBy(true,false,Employee::getIsActive);
        userService.page(repage,query);
        return Result.success(repage);
    }

    @PostMapping("/listzj")
    public Result<Page> getListZj(@RequestBody mPage page){
        Page<Employee> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<Employee> query = new LambdaQueryWrapper<>();
        query.eq(Employee::getRanking,"中级");
        query.orderBy(true,false,Employee::getIsActive);
        userService.page(repage,query);
        return Result.success(repage);
    }

    @PostMapping("/listgj")
    public Result<Page> getListGj(@RequestBody mPage page){
        Page<Employee> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<Employee> query = new LambdaQueryWrapper<>();
        query.eq(Employee::getRanking,"高级");
        query.orderBy(true,false,Employee::getIsActive);
        userService.page(repage,query);
        return Result.success(repage);
    }

    @Cacheable(value = "department")
    @GetMapping("/department")
    public List<String> getDepartments(){
        return userService.getDepartments();
    }

    @Cacheable(value = "position")
    @GetMapping("/position")
    public List<String> getPositions(){
        return userService.position();
    }

    @Cacheable(value = "userList")
    @PostMapping("/listwith")
    public Result<Page<Employee>> getListWith(@RequestBody UserDto userDto){
        Page<Employee> repage = new Page<>(userDto.getPage(),userDto.getSize());
        LambdaQueryWrapper<Employee> wrapper = new LambdaQueryWrapper<Employee>();
        if(StringUtils.isNotBlank(userDto.getRanking()))
            wrapper.eq(Employee::getRanking,userDto.getRanking());
        if(StringUtils.isNotBlank(userDto.getGender()))
            wrapper.eq(Employee::getGender,userDto.getGender());
        if(StringUtils.isNotBlank(userDto.getDepartment()))
            wrapper.eq(Employee::getDepartment,userDto.getDepartment());
        if(StringUtils.isNotBlank(userDto.getPosition()))
            wrapper.eq(Employee::getPosition,userDto.getPosition());
        if(StringUtils.isNotBlank(String.valueOf(userDto.getActive()))&&userDto.getActive()!=null)
            wrapper.eq(Employee::getIsActive,userDto.getActive());
        wrapper.orderBy(true,false,Employee::getIsActive);
        userService.page(repage,wrapper);
        return Result.success(repage);
    }

    @CacheEvict(value = {"employees","userList"},allEntries = true)
    @PutMapping("/update")
    public Result updateSalary(@RequestBody Employee employee){
        LambdaQueryWrapper<Employee> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Employee::getId,employee.getId());
        boolean update = userService.update(employee, wrapper);
        if(update)
            return Result.success("修改成功");
        return Result.error("修改失败");
    }

    @CacheEvict(value = {"employees","userList"},allEntries = true)
    @PutMapping("/updateStatus/{id}")
    public Result updateStatus(@PathVariable Integer id){
        userService.updateStatus(id);
        return Result.success("离职成功");
    }

}
