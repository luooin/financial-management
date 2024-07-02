package cn.itcast.salary.mapper;

import cn.itcast.feign.pojo.Salary;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface SalaryMapper extends BaseMapper<Salary> {

    @Select("select * from salary where employee_id = #{userId} order by salary_month")
    List<Salary> getByUserId(Long userId);

    @Update("update salary set status = #{i} where id = #{id}")
    int updateStatus(int i, int id);

    @Update("update off set status = #{i} where id =#{id}")
    int updateSt(int i, int id);
}
