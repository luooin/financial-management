package cn.itcast.invoice.service.impl;

import cn.itcast.feign.pojo.Invoice;
import cn.itcast.invoice.mapper.InvoiceMapper;
import cn.itcast.invoice.service.InvoiceService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InvoiceServiceImpl extends ServiceImpl<InvoiceMapper, Invoice> implements InvoiceService {

    @Autowired
    private InvoiceMapper mapper;
    @Override
    public int insert(Invoice invoice) {
        return mapper.insert(invoice);
    }

    @Override
    public int updateStatusByid(Integer flag, String id) {
        int i=0;
        if(flag == 1)
            i= mapper.updateStatus(1,id);
        else if(flag == 2)
            i= mapper.updateSt(2,id);
        return i;
    }

    @Override
    public List<String> getNumbers() {
        return mapper.getNumbers();
    }

}
