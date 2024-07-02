package cn.itcast.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.Environment;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebFilter(filterName = "CorsFilter ")
@Configuration
@Order(0)
public class CorsFilter implements Filter {

    @Autowired
    private Environment env; 

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        //允许跨域的域名列表，多个用逗号隔开
        String alloworigin = env.getProperty("alloworigin");
        //是否允许带cookie内容
        String allowCredentials = env.getProperty("allowCredentials");

        response.setHeader("Access-Control-Allow-Origin",alloworigin);
        //注意：要把 Access-Control-Allow-Credentials 设置为 False，否则本地开发调试会发生跨域
        response.setHeader("Access-Control-Allow-Credentials", allowCredentials);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, HEAD, OPTION");
        response.setHeader("Access-Control-Max-Age", "3600");
        //response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Connection, User-Agent, Cookie, username, usertoken, lan_ip, net_ip, wxapitoken");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with,Cache-Control,Pragma,Content-Type,Token, username, usertoken ");
        response.setHeader("Access-Control-Expose-Headers", "username, usertoken ");

        String method = request.getMethod();
        if (method.equalsIgnoreCase("OPTIONS")) {
            res.getOutputStream().write("Success".getBytes(StandardCharsets.UTF_8));
        } else {
            chain.doFilter(req, res);
        }
    }
}