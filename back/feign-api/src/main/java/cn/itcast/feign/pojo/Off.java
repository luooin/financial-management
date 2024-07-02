package cn.itcast.feign.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Off implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String employeeName;
    private Long employeeId;
    private Date startDate;
    private Date endDate;
    private Date approveDate;
    private String reason;
    private int status;
    private String leaveType;
    private LocalDateTime ts;
}
