package cn.itcast.feign.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDto {
    private Long id;
    private Date date;
    private String transactionType;
    private Integer amount;
    private String description;
    private String category;
    //enum('工资', '采购', '租金', '运输', '广告', '设备维护', '市场推广', '办公费用', '税费', '利息', '其他', '利润')
    private String paymentMethod;
    private Integer departmentId;
    private Integer employeeId;
    private LocalDateTime createdAt;
    private int size;
    private int page;
}
