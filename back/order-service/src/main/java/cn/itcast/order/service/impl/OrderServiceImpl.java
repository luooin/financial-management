package cn.itcast.order.service.impl;


import cn.itcast.feign.clients.UserClient;
import cn.itcast.feign.pojo.Department;
import cn.itcast.feign.pojo.FinancialTransaction;
import cn.itcast.feign.pojo.mPage;
import cn.itcast.order.mapper.OrderMapper;
import cn.itcast.order.service.OrderService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, FinancialTransaction> implements OrderService {

    @Autowired
    private OrderMapper orderMapper;


    @Autowired
    private UserClient userClient;

    @Override
    public List<String> getCategory() {
        return orderMapper.getCategory();
    }

    @Override
    public List<String> getPayment() {
        return  orderMapper.getPayment();
    }

    @Override
    public List<Department> getDepartment() {
        return orderMapper.getDepartment();
    }

    @Override
    public String getDepartmentName(Long id) {
        return orderMapper.getDepartmentName(id);
    }

    @Override
    public List<Map<String, String>> getCategoryData() {
        return orderMapper.getCategoryData();
    }

    @Override
    public List<Map<String, String>> getCategoryDatasr() {
        return orderMapper.getCategoryDatasr();
    }

    @Override
    public List<Map<String, String>> getZc(mPage page) {
        int p = (page.getPage()-1)*page.getSize();
        return orderMapper.getZc(p,page.getSize());
    }

    @Override
    public List<Map<String, String>> getSr(mPage page) {
        int p = (page.getPage()-1)*page.getSize();
        return orderMapper.getSr(p,page.getSize());
    }

    @Override
    public Map<String, String> getData() {
        return orderMapper.getData();
    }

    @Override
    public List<Map<String, String>> getDepartmentData() {
        return orderMapper.getDepartmentData();
    }

    @Override
    public List<Map<String, String>> getDepartmentDatasr() {
        return  orderMapper.getDepartmentDatasr();
    }

    @Override
    public List<List> menu1() {
        List<List> result = new ArrayList<List>();
        List<Map<String, String>> maps = orderMapper.menu1();
        List<String> x =new ArrayList<>();
        List<String> y =new ArrayList<>();
        maps.forEach((Map<String, String> map) -> {
            x.add(map.get("x"));
            y.add(map.get("y"));
        });
        result.add(x);
        result.add(y);
        return result;
    }

    @Override
    public List<List> menu2() {
        List<List> result = new ArrayList<List>();
        List<Map<String, String>> maps = orderMapper.menu2();
        List<String> x =new ArrayList<>();
        List<String> y =new ArrayList<>();
        maps.forEach((Map<String, String> map) -> {
            x.add(map.get("x"));
            y.add(map.get("y"));
        });
        result.add(x);
        result.add(y);
        return result;
    }

    @Override
    public List<List> menu3() {
        List<List> result = new ArrayList<List>();
        List<Map<String, String>> maps = orderMapper.menu3();
        List<String> x =new ArrayList<>();
        List<String> y =new ArrayList<>();
        maps.forEach((Map<String, String> map) -> {
            x.add(map.get("x"));
            y.add(map.get("y"));
        });
        result.add(x);
        result.add(y);
        return result;
    }
}
