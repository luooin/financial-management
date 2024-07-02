package cn.itcast.feign.pojo;

import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import net.sf.jsqlparser.expression.DateTimeLiteralExpression;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;


@Data
@NoArgsConstructor
public class Invoice implements Serializable {
    @TableId(type = IdType.AUTO)
    private String id;//主键
    private String number;//发票号码
    private Long customerId;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date issueDate;//发票日期
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date dueDate;//发票到期时间
    private Double totalAmount;
    private int status;
    private int approveStatus;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date approveDate;
    private Employee employee;
    private Long userId;
    private LocalDateTime ts;
}