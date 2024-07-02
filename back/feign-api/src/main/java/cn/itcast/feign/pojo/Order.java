package cn.itcast.feign.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long price;
    private String name;
    private Integer num;
    private Long userId;
    private Employee employee;
}