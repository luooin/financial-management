package cn.itcast.feign.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;

import java.sql.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SalaryDto {
    private int size;
    private int page;
    @DateTimeFormat(pattern = "yyyy-MM")
    private List<Date> SalaryMonth;
    private String ranking;
    private String employeeId;
    private String percent;
    private String department;
}
