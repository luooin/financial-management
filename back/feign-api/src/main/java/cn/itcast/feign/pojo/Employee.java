package cn.itcast.feign.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Employee implements Serializable {
    @TableId(type = IdType.AUTO)
    private int id;
    private String name;
    private String email;
    private String phone;
    private String address;
    private Date dateOfBirth;
    private Date hireDate;
    private String position;
    private String ranking;
    private String department;
    private String gender;
    private int age;
    private boolean isActive;
    private String username;
    private String password;
    @TableField(exist = false)
    private List<Salary> salary;

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean active) {
        isActive = active;
    }
}