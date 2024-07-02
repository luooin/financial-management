package cn.itcast.invoice.service;

import cn.itcast.feign.pojo.Employee;
import cn.itcast.feign.pojo.Invoice;
import cn.itcast.feign.pojo.Result;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

public interface InvoiceService extends IService<Invoice> {

    int insert(Invoice invoice);

    int updateStatusByid(Integer flag, String id);

    List<String> getNumbers();


}

