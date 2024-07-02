package cn.itcast.salary.service;

import cn.itcast.feign.pojo.Salary;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

public interface SalaryService extends IService<Salary> {
    List<Salary> getSalaryByUserId(Long userId);

    int updateStatusByid(int flag, int id);
}

