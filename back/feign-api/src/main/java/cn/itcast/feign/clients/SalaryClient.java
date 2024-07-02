package cn.itcast.feign.clients;

import cn.itcast.feign.pojo.Salary;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient("salaryservice")
public interface SalaryClient {

    @GetMapping("/salary/{userId}")
    List<Salary> getByUserId(@PathVariable("userId") Long userId);
}
