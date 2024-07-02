package cn.itcast.feign.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class InvoicePage {
    int size;
    int page;
    private String number;//发票号码
    private Integer approveStatus;
    private String userId;
    private Date issueDate;//发票日期
}
