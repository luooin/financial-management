package cn.itcast.feign.clients;

import cn.itcast.feign.pojo.Employee;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient("userservice")
public interface UserClient {

    @GetMapping("/user/{id}")
    Employee getById(@PathVariable("id") Long id );

    @GetMapping("/user/list")
    List<Employee> getEmployees();

    @GetMapping("/user/name/{id}")
    String getName(@PathVariable("id") int id);

}
