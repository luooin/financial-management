package cn.itcast.feign.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private int size;
    private int page;
    private String position;
    private String ranking;
    private String department;
    private String gender;
    private Integer active;
}
