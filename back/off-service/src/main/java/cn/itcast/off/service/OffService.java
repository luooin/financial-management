package cn.itcast.off.service;

import cn.itcast.feign.pojo.Off;
import com.baomidou.mybatisplus.extension.service.IService;

public interface OffService extends IService<Off> {
    int updateStatusByid(Integer flag, Long id);
}
