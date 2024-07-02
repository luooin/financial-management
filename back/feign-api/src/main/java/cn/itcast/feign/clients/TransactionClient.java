package cn.itcast.feign.clients;

import cn.itcast.feign.pojo.FinancialTransaction;
import cn.itcast.feign.pojo.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient("orderservice")
public interface TransactionClient {

    @PostMapping("/order/add")
    Result addOrder(@RequestBody FinancialTransaction order);
}
