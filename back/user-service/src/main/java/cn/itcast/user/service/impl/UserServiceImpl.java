package cn.itcast.user.service.impl;

import cn.itcast.feign.clients.SalaryClient;
import cn.itcast.feign.pojo.Employee;
import cn.itcast.feign.pojo.Result;
import cn.itcast.feign.pojo.Salary;
import cn.itcast.user.mapper.UserMapper;
import cn.itcast.user.service.UserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper,Employee> implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SalaryClient salaryClient;
    public Employee queryById(Long id) {
        Employee empl = userMapper.findById(id);
        List<Salary> salary = salaryClient.getByUserId(id);
        empl.setSalary(salary);
        return empl;
    }

    @Override
    public String queryByI(Long id) {
        return userMapper.getName(Math.toIntExact(id));
    }

    @Override
    public Result checkLogin(Employee user) {
        Employee empl = userMapper.checkLogin(user);
        if(empl==null) {
            return Result.error("该用户不存在");
        }
        if(!empl.getPassword().equals(user.getPassword())){
           return Result.error("密码不正确");
        }
        return Result.success("登录成功");
    }
    @Override
    public List<Employee> getAll() {
       return userMapper.selectList(null);
    }

    @Override
    public String getName(int id) {
        return userMapper.getName(id);
    }

    @Override
    public List<String> getDepartments() {
        return userMapper.getDepartments();
    }

    @Override
    public List<String> position() {
        return userMapper.position();
    }

    @Override
    public void updateStatus(int id) {
        userMapper.updateStatus(id);
    }
}
