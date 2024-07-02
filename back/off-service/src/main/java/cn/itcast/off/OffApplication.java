package cn.itcast.off;

import cn.itcast.feign.clients.UserClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@EnableFeignClients(clients = {UserClient.class})
@CrossOrigin
@EnableCaching
public class OffApplication {
    public static void main(String[] args){
        SpringApplication.run(OffApplication.class,args);
    }
}
