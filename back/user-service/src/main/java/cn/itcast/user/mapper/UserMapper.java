package cn.itcast.user.mapper;

import cn.itcast.feign.pojo.Employee;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

public interface UserMapper extends BaseMapper<Employee> {
    
    @Select("select * from employee where id = #{id}")
    Employee findById(Long id);

    @Select("select name from employee where id = #{id}")
    String getName(int id);

    @Select("select * from employee where username = #{username}")
    Employee checkLogin(Employee user);

    @Select("select distinct department from employee")
    List<String> getDepartments();

    @Select("select distinct position from employee")
    List<String> position();

    @Update("update employee set is_active = 0 where id = #{id}")
    void updateStatus(int id);
}
