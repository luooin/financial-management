package cn.itcast.off.service.impl;

import cn.itcast.feign.pojo.Off;
import cn.itcast.off.mapper.OffMapper;
import cn.itcast.off.service.OffService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OffServiceImpl extends ServiceImpl<OffMapper, Off> implements OffService {
    @Autowired
    private OffMapper mapper;
    @Override
    public int updateStatusByid(Integer flag, Long id) {
        int i=0;
        if(flag == 1)
            i= mapper.updateStatus(1,id);
        else if(flag == 2)
            i= mapper.updateSt(2,id);
        return i;
    }

}
