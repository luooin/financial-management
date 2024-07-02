package cn.itcast.feign.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OffPage {
    private Long id;
    private String employeeName;
    private Long employeeId;
    private Date startDate;
    private Date endDate;
    private Date approveDate;
    private String reason;
    private Integer status;
    private String leaveType;
    private LocalDateTime ts;
    int size;
    int page;
}
