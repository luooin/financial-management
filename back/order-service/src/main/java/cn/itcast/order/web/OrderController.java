package cn.itcast.order.web;
import cn.itcast.feign.dto.OrderDto;
import cn.itcast.feign.pojo.*;
import cn.itcast.order.service.OrderService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.api.R;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("order")
public class OrderController {

   @Autowired
   private OrderService orderService;

    @PostMapping("/list")
    public Result<Page> getList(@RequestBody mPage page){
        Page<FinancialTransaction> repage = new Page<>(page.getPage(),page.getSize());
        LambdaQueryWrapper<FinancialTransaction> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(FinancialTransaction::getDate);
        orderService.page(repage,wrapper);
        return Result.success(repage);
    }

    @Cacheable(value = "orderList")
    @PostMapping("/listwith")
    public Result<Page<FinancialTransaction>> getListWithP(@RequestBody OrderDto orderDto){
        Page<FinancialTransaction> repage = new Page<>(orderDto.getPage(),orderDto.getSize());
        LambdaQueryWrapper<FinancialTransaction> wrapper = new LambdaQueryWrapper<>();
        if(!StringUtils.isBlank(String.valueOf(orderDto.getCategory())))
            if(!"null".equals(String.valueOf(orderDto.getCategory())))
                wrapper.eq(FinancialTransaction::getCategory,orderDto.getCategory());
        if(!StringUtils.isBlank(String.valueOf(orderDto.getTransactionType())))
            if(!"null".equals(String.valueOf(orderDto.getTransactionType())))
                wrapper.eq(FinancialTransaction::getTransactionType,orderDto.getTransactionType());
        if(!StringUtils.isBlank(String.valueOf(orderDto.getDate())))
            if(!"null".equals(String.valueOf(orderDto.getDate())))
                wrapper.eq(FinancialTransaction::getDate,orderDto.getDate());
        wrapper.orderByDesc(FinancialTransaction::getDate);
        orderService.page(repage,wrapper);
        return Result.success(repage);
    }

    @Cacheable(value = "category")
    @GetMapping("/getCategory")
    public Result<List> getCategory(){
        List<String> list = orderService.getCategory();
        return Result.success(list);
    }

    @Cacheable(value = "payment")
    @GetMapping("/getPayment")
    public Result<List> getPayment(){
        List<String> list = orderService.getPayment();
        return Result.success(list);
    }

    @CacheEvict(value = "orderList",allEntries = true)
    @PostMapping("/add")
    public Result addOrder(@RequestBody FinancialTransaction order){
        return Result.success(orderService.save(order));
    }

    @Cacheable(value = "departmnent")
    @GetMapping("/getDepartment")
    public List<Department> getDepartment(){
        return orderService.getDepartment();
    }

    @GetMapping("/getDepartmentName/{id}")
    public String getDepartmentName(@PathVariable Long id) {
        return orderService.getDepartmentName(id);
    }

    @CacheEvict(value = "orderList",allEntries = true)
    @PutMapping("/update")
    public Result updateSalary(@RequestBody FinancialTransaction transaction){
        LambdaQueryWrapper<FinancialTransaction> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(FinancialTransaction::getId,transaction.getId());
        boolean update = orderService.update(transaction, wrapper);
        if(update)
            return Result.success("修改成功");
        return Result.error("修改失败");
    }

    @CacheEvict(value = "orderList",allEntries = true)
    @DeleteMapping("/delete/{id}")
    public Result deleteOrder(@PathVariable Long id){
        boolean b = orderService.removeById(id);
        if(b)
            return Result.success("删除成功");
        return Result.error("删除失败");
    }

    @PostMapping("/category")
    public Result category(){
        return Result.success(orderService.getCategoryData());
    }

    @PostMapping("/categorysr")
    public Result categorysr(){
        return Result.success(orderService.getCategoryDatasr());
    }

    @PostMapping("/getZc")
    public Result getZc(@RequestBody mPage page){
        return Result.success(orderService.getZc(page));
    }
    @PostMapping("/getSr")
    public Result getSr(@RequestBody mPage page){
        return Result.success(orderService.getSr(page));
    }
    @GetMapping("/getData")
    public Result getData(){
        return Result.success(orderService.getData());
    }

    @GetMapping("/getDepartmentData")
    public Result getDepartmentData(){
        return Result.success(orderService.getDepartmentData());
    }

    @GetMapping("/getDepartmentDatasr")
    public Result getDepartmentDatasr(){
        return Result.success(orderService.getDepartmentDatasr());
    }

    @PostMapping("/menu1")
    public Result menu1(){
        return Result.success(orderService.menu1());
    }

    @PostMapping("/menu2")
    public Result menu2(){
        return Result.success(orderService.menu2());
    }

    @PostMapping("/menu3")
    public Result menu3(){
        return Result.success(orderService.menu3());
    }
}

