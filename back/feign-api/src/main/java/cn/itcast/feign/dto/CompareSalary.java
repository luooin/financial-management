package cn.itcast.feign.dto;

import lombok.Data;

import java.sql.Date;
import java.util.List;

@Data
public class CompareSalary {
    private int[] id;
    private Date salaryMonth;
}
