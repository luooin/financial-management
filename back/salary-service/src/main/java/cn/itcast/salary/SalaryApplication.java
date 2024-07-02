package cn.itcast.salary;

import cn.itcast.feign.clients.TransactionClient;
import cn.itcast.feign.clients.UserClient;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@EnableFeignClients(clients = {UserClient.class, TransactionClient.class})
@CrossOrigin
@EnableCaching
@MapperScan("cn.itcast.salary.mapper")
public class SalaryApplication {
    public static void main(String[] args) {
        SpringApplication.run(SalaryApplication.class, args);

    }
}
