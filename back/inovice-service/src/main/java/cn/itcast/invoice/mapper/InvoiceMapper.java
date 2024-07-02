package cn.itcast.invoice.mapper;

import cn.itcast.feign.pojo.Invoice;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.mybatis.spring.annotation.MapperScan;

import java.util.List;

@Mapper
public interface InvoiceMapper extends BaseMapper<Invoice>{

    @Update("update invoice set approve_status = #{i},status = #{i} ,approve_date = curdate() where id = #{id}")
    int updateStatus(int i, String id);

    @Update("update invoice set approve_status = #{i},status = #{i} ,approve_date = null where id =#{id}")
    int updateSt(int i, String id);

    @Select("select distinct number from invoice ")
    List<String> getNumbers();
}
