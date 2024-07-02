package cn.itcast.order.mapper;


import cn.itcast.feign.pojo.Department;
import cn.itcast.feign.pojo.Order;
import cn.itcast.feign.pojo.FinancialTransaction;
import cn.itcast.feign.pojo.mPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrderMapper extends BaseMapper<FinancialTransaction> {

    @Select("select distinct category from financial_transaction")
    List<String> getCategory();

    @Select("select distinct payment_method from financial_transaction")
    List<String> getPayment();
    @Select("select * from department")
    List<Department> getDepartment();

    @Select("select name from department where id = #{id}")
    String getDepartmentName(Long id);

    @Select("select distinct category as name,sum(amount) as value from financial_transaction where transaction_type ='支出' group by category")
    List<Map<String, String>> getCategoryData();

    @Select("select distinct description as name,sum(amount) as value from financial_transaction where transaction_type ='收入' group by description")
    List<Map<String, String>> getCategoryDatasr();

    @Select("select category as description ,amount from financial_transaction where transaction_type ='支出' order by created_at desc limit #{page},#{size}")
    List<Map<String, String>> getZc(int page,int size);

    @Select("select description as  description ,amount from financial_transaction where transaction_type ='收入' order by created_at desc limit #{page},#{size}")
    List<Map<String, String>> getSr(int page,int size);

    @Select("SELECT\n" +
            "    SUM(CASE WHEN transaction_type = '支出' THEN amount ELSE 0 END) AS payout,\n" +
            "    SUM(CASE WHEN transaction_type = '收入' THEN amount ELSE 0 END) AS earn,\n" +
            "    SUM(CASE WHEN transaction_type = '收入' THEN amount WHEN transaction_type = '支出' THEN -amount ELSE 0 END) AS profit\n" +
            "FROM\n" +
            "    financial_transaction;")
    Map<String, String> getData();

    @Select("select sum(amount) as value ,name from financial_transaction a left join department b on a.department_id=b.id where transaction_type='支出' group by department_id,name")
    List<Map<String,String>> getDepartmentData();

    @Select("select sum(amount) as value ,name from financial_transaction a left join department b on a.department_id=b.id where transaction_type='收入' group by department_id,name")
    List<Map<String, String>> getDepartmentDatasr();

    @Select("SELECT substr(date,6) as x,SUM(CASE WHEN transaction_type = '支出' THEN -amount ELSE amount END) AS y FROM financial_transaction GROUP BY date order by date desc limit 0,7")
    List<Map<String, String>> menu1();

    @Select("select sum(amount) as y ,substr(date,6) as x from financial_transaction where transaction_type='支出' group by date  order by date desc limit 0,7")
    List<Map<String, String>> menu2();

    @Select("select sum(amount) as y ,substr(date,6) as x from financial_transaction where transaction_type='收入' group by date  order by date desc limit 0,7")
    List<Map<String, String>> menu3();

}
