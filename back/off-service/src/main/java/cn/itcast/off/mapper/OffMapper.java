package cn.itcast.off.mapper;

import cn.itcast.feign.pojo.Off;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;
import org.mybatis.spring.annotation.MapperScan;

@Mapper
public interface OffMapper extends BaseMapper<Off> {
    @Update("update off set status = #{i},approve_date = curdate() where id = #{id}")
    int updateStatus(int i, Long id);

    @Update("update off set status = #{i},status = #{i} ,approve_date = null where id =#{id}")
    int updateSt(int i, Long id);
}
