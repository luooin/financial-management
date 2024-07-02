package cn.itcast.salary.service.impl;

import cn.itcast.feign.pojo.Salary;
import cn.itcast.salary.mapper.SalaryMapper;
import cn.itcast.salary.service.SalaryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SalaryServiceImpl extends ServiceImpl<SalaryMapper, Salary> implements SalaryService {
    @Autowired
    private SalaryMapper salaryMapper;
    @Override
    public int updateStatusByid(int flag, int id) {
        int i=0;
        if(flag == 1)
            i= salaryMapper.updateStatus(1,id);
        else if(flag == 2)
            i= salaryMapper.updateSt(2,id);
        return i;
    }

    @Override
    public List<Salary> getSalaryByUserId(Long userId) {
        return salaryMapper.getByUserId(userId);
    }

}
