package cn.itcast.user.service;

import cn.itcast.feign.pojo.Employee;
import cn.itcast.feign.pojo.Result;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;


public interface UserService extends IService<Employee> {


    Employee queryById(Long id);

    String queryByI(Long id);

    Result checkLogin(Employee user);

    List<Employee> getAll();

    String getName(int id);

    List<String> getDepartments();

    List<String> position();

    void updateStatus(int id);
}