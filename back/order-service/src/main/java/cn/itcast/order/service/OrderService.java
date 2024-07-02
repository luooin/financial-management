package cn.itcast.order.service;

import cn.itcast.feign.pojo.*;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import java.util.Map;
public interface OrderService extends IService<FinancialTransaction> {

    List<String> getCategory();

    List<String> getPayment();

    List<Department> getDepartment();

    String getDepartmentName(Long id);

    List<Map<String,String>> getCategoryData();

    List<Map<String,String>> getCategoryDatasr();

    List<Map<String, String>> getZc(mPage page);

    List<Map<String, String>> getSr(mPage page);

    Map<String,String> getData();

    List<Map<String,String>>  getDepartmentData();

    List<Map<String,String>> getDepartmentDatasr();

    List<List> menu1();

    List<List> menu2();

    List<List> menu3();
}
