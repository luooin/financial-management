package cn.itcast.feign.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.SelectKey;
import org.springframework.format.annotation.DateTimeFormat;

import javax.annotation.Generated;
import java.io.Serializable;
import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Salary implements Serializable {
    @TableId(type = IdType.AUTO)
    private int id; // 薪水ID
    private int employeeId; // 员工ID
    @TableField(exist = false)
    private String employeeName;
    private double basicSalary; // 基本工资
    private double performanceSalary; // 绩效工资
    private double socialSecurityBase; // 社保基数
    private double socialSecurityRate; // 社保费率
    private double housingFundBase; // 公积金基数
    private double housingFundRate; // 公积金费率
    private double annualBonus; // 年度奖金
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date hireDate; // 入职日期
    private String position; // 职位
    private String ranking; // 职级
    private Double getSalary; // 到手工资
    @DateTimeFormat(pattern = "yyyy-MM")
    private Date salaryMonth; // 工资月份
    private double percent;// 绩效完成比例
    private int offDays;// 请假天数
    private int status;
}