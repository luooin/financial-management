/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : financial

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 02/07/2024 23:23:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for approval
-- ----------------------------
DROP TABLE IF EXISTS `approval`;
CREATE TABLE `approval`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `approval_type` enum('发票','请假') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `creator_id` int(0) NOT NULL,
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `status` enum('待审批','已通过','已拒绝') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '待审批',
  `approver_id` int(0) NULL DEFAULT NULL,
  `approved_at` timestamp(0) NULL DEFAULT NULL,
  `rejected_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `approver_id`(`approver_id`) USING BTREE,
  INDEX `creator_id`(`creator_id`) USING BTREE,
  CONSTRAINT `approval_ibfk_1` FOREIGN KEY (`approver_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `approval_ibfk_2` FOREIGN KEY (`creator_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approval
-- ----------------------------
INSERT INTO `approval` VALUES (1, '发票', '申请报销办公用品费用', 1, '2023-11-27 16:57:40', '待审批', 2, NULL, NULL);
INSERT INTO `approval` VALUES (2, '请假', '申请年假5天', 3, '2023-11-27 16:57:40', '待审批', 4, NULL, NULL);
INSERT INTO `approval` VALUES (3, '发票', '申请报销差旅费用', 2, '2023-11-27 16:57:40', '待审批', 3, NULL, NULL);
INSERT INTO `approval` VALUES (4, '请假', '申请病假2天', 1, '2023-11-27 16:57:40', '已通过', 4, NULL, NULL);
INSERT INTO `approval` VALUES (5, '请假', '申请事假1天', 4, '2023-11-27 16:57:40', '已通过', 2, NULL, NULL);
INSERT INTO `approval` VALUES (6, '发票', '申请报销培训费用', 3, '2023-11-27 16:57:40', '已通过', 1, NULL, NULL);
INSERT INTO `approval` VALUES (7, '请假', '申请调休1天', 2, '2023-11-27 16:57:40', '已拒绝', 3, NULL, NULL);
INSERT INTO `approval` VALUES (8, '发票', '申请报销业务招待费用', 4, '2023-11-27 16:57:40', '已拒绝', 1, NULL, NULL);
INSERT INTO `approval` VALUES (9, '发票', '申请报销办公设备费用', 1, '2023-11-27 16:57:40', '已拒绝', 4, NULL, NULL);
INSERT INTO `approval` VALUES (10, '请假', '申请产假180天', 3, '2023-11-27 16:57:40', '待审批', 2, NULL, NULL);

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `id` int(0) NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, '销售部门');
INSERT INTO `department` VALUES (2, '技术部门');
INSERT INTO `department` VALUES (3, '人力资源部门');
INSERT INTO `department` VALUES (4, '财务部门');
INSERT INTO `department` VALUES (5, '市场部门');
INSERT INTO `department` VALUES (6, '行政部门');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `date_of_birth` date NULL DEFAULT NULL,
  `hire_date` date NULL DEFAULT NULL,
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ranking` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `age` int(0) NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `boss_id` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '张三', 'zhangsan@example.com', '1234567890', '北京市朝阳区', '1990-05-15', '2020-01-01', '经理', '高级', '销售部门', '男', 33, 1, 'zhangsan', '123456', NULL);
INSERT INTO `employee` VALUES (2, '李四', 'lisi@example.com', '0987654321', '上海市浦东新区', '1992-08-20', '2019-06-15', '工程师', '中级', '技术部门', '男', 31, 0, 'lisi', '123456', NULL);
INSERT INTO `employee` VALUES (3, '王五', 'wangwu@example.com', '9876543210', '广州市天河区', '1988-12-10', '2018-03-10', '助理', '初级', '人力资源部门', '女', 33, 0, 'wangwu', '123456', NULL);
INSERT INTO `employee` VALUES (4, '赵六', 'zhaoliu@example.com', '2345678901', '深圳市南山区', '1995-07-25', '2021-09-05', '销售代表', '初级', '销售部门', '男', 28, 1, 'zhaoliu', '123456', NULL);
INSERT INTO `employee` VALUES (5, '刘七', 'liuqi@example.com', '3456789012', '成都市高新区', '1991-03-18', '2017-11-20', '项目经理', '高级', '技术部门', '男', 30, 1, 'liuqi', '123456', NULL);
INSERT INTO `employee` VALUES (6, '陈八', 'chenba@example.com', '4567890123', '武汉市江汉区', '1993-06-05', '2019-02-25', '财务主管', '中级', '财务部门', '女', 28, 0, 'chenba', '123456', NULL);
INSERT INTO `employee` VALUES (7, '周九', 'zhoujiu@example.com', '5678901234', '重庆市渝北区', '1994-09-12', '2020-07-10', '市场专员', '初级', '市场部门', '女', 27, 0, 'zhoujiu', '123456', NULL);
INSERT INTO `employee` VALUES (8, '吴十', 'wushi@example.com', '6789012345', '西安市雁塔区', '1990-11-28', '2018-04-18', '人力资源经理', '高级', '人力资源部门', '女', 33, 1, 'wushi', '123456', NULL);
INSERT INTO `employee` VALUES (9, '郑十一', 'zhengshiyi@example.com', '7890123456', '南京市鼓楼区', '1993-04-22', '2022-02-05', '技术支持工程师', '初级', '技术部门', '男', 28, 1, 'zhengshiyi', '123456', NULL);
INSERT INTO `employee` VALUES (10, '孙十二', 'sunshier@example.com', '8901234567', '杭州市西湖区', '1992-01-08', '2019-09-20', '行政助理', '初级', '行政部门', '男', 31, 1, 'sunshier', '123456', NULL);
INSERT INTO `employee` VALUES (55, '王小红', 'wangxiaohong@example.com', '1234565789', '北京市', '1990-01-01', '2020-01-01', '人力资源助理', '初级', '人力资源部门', '女', 31, 1, 'wxh', '123456', NULL);
INSERT INTO `employee` VALUES (56, '张小明', 'zhangxiaoming@example.com', '9876654321', '上海市', '1988-05-10', '2018-02-15', '人力资源专员', '初级', '人力资源部门', '男', 33, 1, 'zxm', '123456', NULL);
INSERT INTO `employee` VALUES (57, '李芳', 'lifang@example.com', '6541321987', '广州市', '1992-09-20', '2021-07-03', '人力资源经理', '中级', '人力资源部门', '女', 29, 1, 'lf', '123456', NULL);
INSERT INTO `employee` VALUES (58, '王志强', 'wangzhiqiang@example.com', '78945566123', '深圳市', '1985-12-12', '2010-09-08', '高级人力资源经理', '高级', '人力资源部门', '男', 36, 1, 'wzq', '123456', NULL);
INSERT INTO `employee` VALUES (59, '刘丽', 'liuli@example.com', '3216544987', '成都市', '1994-06-25', '2019-03-21', '人力资源助理', '初级', '人力资源部门', '女', 27, 1, 'll', '123456', NULL);
INSERT INTO `employee` VALUES (60, '张伟', 'zhangwei@example.com', '12345236789', '北京市', '1987-04-15', '2015-08-10', '软件工程师', '初级', '技术部门', '男', 34, 1, 'zw', '123456', NULL);
INSERT INTO `employee` VALUES (61, '王静', 'wangjing@example.com', '987654321', '上海市', '1991-03-21', '2017-06-05', '软件工程师', '初级', '技术部门', '女', 30, 0, 'wj', '123456', NULL);
INSERT INTO `employee` VALUES (62, '李强', 'liqiang@example.com', '6543321987', '广州市', '1989-07-07', '2019-11-18', '软件工程师', '中级', '技术部门', '男', 32, 1, 'lq', '123456', NULL);
INSERT INTO `employee` VALUES (63, '王军', 'wangjun@example.com', '789456123', '深圳市', '1986-09-30', '2012-04-02', '高级软件工程师', '高级', '技术部门', '男', 35, 1, 'wjf', '123456', NULL);
INSERT INTO `employee` VALUES (64, '刘敏', 'liumin@example.com', '3216524987', '成都市', '1993-11-08', '2018-09-25', '软件工程师', '初级', '技术部门', '女', 28, 1, 'lm', '123456', NULL);
INSERT INTO `employee` VALUES (65, '张飞', 'zhangfei@example.com', '12345623789', '北京市', '1990-02-25', '2017-03-12', '销售代表', '初级', '销售部门', '男', 31, 1, 'zf', '123456', NULL);
INSERT INTO `employee` VALUES (123, '张珊', 'zhangshan@example.com', '1357922468', '北京市', '1990-01-01', '2020-01-01', '销售代表', '初级', '销售部门', '女', 31, 0, 'zhangshan', '123456', NULL);
INSERT INTO `employee` VALUES (124, '李思', 'lis@example.com', '2468153579', '上海市', '1988-05-10', '2018-02-15', '销售经理', '高级', '销售部门', '男', 33, 1, 'lisiw', '123456', NULL);
INSERT INTO `employee` VALUES (125, '王琪', 'wangqi@example.com', '3692586147', '广州市', '1992-09-20', '2021-07-03', '销售代表', '初级', '销售部门', '女', 29, 1, 'wangqi', '123456', NULL);
INSERT INTO `employee` VALUES (126, '赵兵', 'zhaobing@example.com', '9517534852', '深圳市', '1985-12-12', '2010-09-08', '销售经理', '高级', '销售部门', '男', 36, 1, 'zhaobing', '123456', NULL);
INSERT INTO `employee` VALUES (127, '刘婷', 'liuting@example.com', '753159852', '成都市', '1994-06-25', '2019-03-21', '销售代表', '中级', '销售部门', '女', 27, 0, 'liuting', '123456', NULL);
INSERT INTO `employee` VALUES (128, '陈华', 'chenhua@example.com', '2468133579', '北京市', '1987-04-15', '2015-08-10', '财务专员', '初级', '财务部门', '男', 34, 1, 'chenhua', '123456', NULL);
INSERT INTO `employee` VALUES (129, '李丽', 'lili@example.com', '36958147', '上海市', '1991-03-21', '2017-06-05', '财务经理', '高级', '财务部门', '女', 30, 1, 'lili', '123456', NULL);
INSERT INTO `employee` VALUES (130, '王杰', 'wangjie@example.com', '95175324852', '广州市', '1989-07-07', '2019-11-18', '财务专员', '中级', '财务部门', '男', 32, 1, 'wangjie', '123456', NULL);
INSERT INTO `employee` VALUES (131, '赵丹', 'zhaodan@example.com', '75315459852', '深圳市', '1986-09-30', '2012-04-02', '财务经理', '高级', '财务部门', '女', 35, 0, 'zhaodan', '123456', NULL);
INSERT INTO `employee` VALUES (132, '孙宇', 'sunyu@example.com', '3579518552', '成都市', '1993-11-08', '2018-09-25', '财务专员', '初级', '财务部门', '男', 28, 1, 'sunyu', '123456', NULL);
INSERT INTO `employee` VALUES (133, '林雪', 'linxue@example.com', '24684513579', '北京市', '1990-02-25', '2017-03-12', '行政助理', '初级', '行政部门', '女', 31, 1, 'linxue', '123456', NULL);
INSERT INTO `employee` VALUES (134, '刘洋', 'liuyang@example.com', '36925845147', '上海市', '1992-08-18', '2019-01-27', '行政经理', '高级', '行政部门', '男', 29, 1, 'liuyang', '123456', NULL);
INSERT INTO `employee` VALUES (135, '王磊', 'wanglei@example.com', '95134753852', '广州市', '1988-06-12', '2015-10-10', '行政助理', '初级', '行政部门', '男', 33, 1, 'wanglei', '123456', NULL);
INSERT INTO `employee` VALUES (136, '赵琳', 'zhaolin@example.com', '75315982352', '深圳市', '1995-03-03', '2020-05-15', '行政经理', '高级', '行政部门', '女', 26, 0, 'zhaolin', '123456', NULL);
INSERT INTO `employee` VALUES (137, '张杰', 'zhangjie@example.com', '2468135279', '北京市', '1986-08-07', '2014-07-20', '市场专员', '初级', '市场部门', '男', 35, 0, 'zhangjie', '123456', NULL);
INSERT INTO `employee` VALUES (138, '李娟', 'lijuan@example.com', '3692558147', '上海市', '1990-12-05', '2018-09-10', '市场经理', '高级', '市场部门', '女', 31, 0, 'lijuan', '123456', NULL);
INSERT INTO `employee` VALUES (139, '王鹏', 'wangpeng@example.com', '95175852', '广州市', '1987-11-17', '2016-03-05', '市场专员', '中级', '市场部门', '男', 34, 1, 'wangpeng', '123456', NULL);
INSERT INTO `employee` VALUES (140, '赵婷', 'zhaoting@example.com', '75315952', '深圳市', '1993-04-28', '2020-11-28', '市场经理', '高级', '市场部门', '女', 28, 1, 'zhaoting', '123456', NULL);
INSERT INTO `employee` VALUES (141, '孙鹏', 'sunpeng@example.com', '35795852', '成都市', '1991-09-14', '2019-02-03', '市场专员', '初级', '市场部门', '男', 30, 0, 'sunpeng', '123456', NULL);

-- ----------------------------
-- Table structure for financial_transaction
-- ----------------------------
DROP TABLE IF EXISTS `financial_transaction`;
CREATE TABLE `financial_transaction`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `transaction_type` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` double NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `category` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `payment_method` enum('现金','银行转账','信用卡','支付宝','微信支付','支票','电汇','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `department_id` int(0) NULL DEFAULT NULL,
  `employee_id` int(0) NULL DEFAULT NULL,
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `employee_id`(`employee_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 178 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of financial_transaction
-- ----------------------------
INSERT INTO `financial_transaction` VALUES (61, '2023-11-01', '支出', 5000, '支付工资', '工资', '银行转账', 1, 1, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (62, '2023-11-02', '支出', 1200, '采购原材料', '采购', '支付宝', 2, 2, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (63, '2023-11-03', '支出', 800, '办公室租金', '租金', '现金', 1, 3, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (64, '2023-11-04', '支出', 300, '运输费用', '运输', '微信支付', 3, 4, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (65, '2023-11-05', '支出', 500, '广告宣传费', '广告', '支付宝', 4, 5, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (66, '2023-11-06', '支出', 200, '设备维护', '设备维护', '银行转账', 2, 6, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (67, '2023-11-07', '支出', 1000, '市场推广费用', '市场推广', '信用卡', 3, 7, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (68, '2023-11-08', '支出', 500, '办公用品购买', '办公费用', '现金', 1, 8, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (69, '2023-11-09', '支出', 400, '税费', '税费', '支付宝', 4, 9, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (70, '2023-11-10', '支出', 100, '利息支出', '利息', '微信支付', 3, 10, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (71, '2023-11-11', '收入', 2000, '销售收入', '其他', '银行转账', 1, 1, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (72, '2023-11-12', '收入', 1500, '销售收入', '其他', '支付宝', 2, 2, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (73, '2023-11-13', '支出', 300, '设备维护', '设备维护', '银行转账', 3, 3, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (74, '2023-11-14', '支出', 500, '办公用品购买', '办公费用', '现金', 4, 4, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (75, '2023-11-15', '收入', 4000, '销售收入', '其他', '微信支付', 1, 5, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (76, '2023-11-16', '支出', 600, '税费', '税费', '支付宝', 2, 6, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (77, '2023-11-17', '支出', 200, '利息支出', '利息', '银行转账', 3, 7, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (78, '2023-11-18', '收入', 3000, '销售收入', '其他', '支付宝', 4, 8, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (79, '2023-11-19', '收入', 2500, '销售收入', '其他', '现金', 1, 9, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (80, '2023-11-20', '支出', 400, '设备维护', '设备维护', '微信支付', 2, 10, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (81, '2023-11-21', '支出', 1000, '运输费用', '运输', '银行转账', 3, 1, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (82, '2023-11-22', '支出', 500, '广告宣传费', '广告', '支付宝', 4, 2, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (83, '2023-11-23', '支出', 200, '设备维护', '设备维护', '现金', 1, 3, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (84, '2023-11-24', '支出', 1000, '市场推广费用', '市场推广', '信用卡', 2, 4, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (85, '2023-11-25', '支出', 500, '办公用品购买', '办公费用', '现金', 3, 5, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (86, '2023-11-26', '支出', 400, '税费', '税费', '支付宝', 4, 6, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (88, '2023-11-28', '收入', 2000, '销售收入', '其他', '银行转账', 2, 8, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (89, '2023-11-29', '收入', 1500, '销售收入', '其他', '支付宝', 3, 9, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (90, '2023-11-30', '支出', 300, '设备维护', '设备维护', '银行转账', 4, 10, '2023-11-27 17:16:28');
INSERT INTO `financial_transaction` VALUES (91, '2024-03-30', '支出', 3454, '是否v谁的风格VB', '租金', '支付宝', 3, NULL, '2024-03-30 15:38:14');
INSERT INTO `financial_transaction` VALUES (113, '2024-04-01', '收入', 2500, '销售收入', '其他', '银行转账', 1, 1, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (114, '2024-04-02', '收入', 1500, '服务收入', '其他', '现金', 2, 2, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (115, '2024-04-03', '收入', 3000, '销售收入', '其他', '银行转账', 3, 3, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (116, '2024-04-04', '收入', 2000, '服务收入', '其他', '支付宝', 4, 4, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (117, '2024-04-05', '收入', 3500, '销售收入', '其他', '银行转账', 1, 5, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (118, '2024-04-06', '收入', 1800, '服务收入', '其他', '现金', 2, 6, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (119, '2024-04-07', '收入', 2800, '销售收入', '其他', '银行转账', 3, 7, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (120, '2024-04-08', '收入', 2200, '服务收入', '其他', '支付宝', 4, 8, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (121, '2024-04-09', '收入', 3200, '销售收入', '其他', '银行转账', 1, 9, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (122, '2024-04-10', '收入', 2100, '服务收入', '其他', '现金', 2, 10, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (123, '2024-04-11', '收入', 2900, '销售收入', '其他', '银行转账', 3, 11, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (124, '2024-04-12', '收入', 2300, '服务收入', '其他', '支付宝', 4, 12, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (125, '2024-04-13', '收入', 3300, '销售收入', '其他', '银行转账', 1, 13, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (126, '2024-04-14', '收入', 1900, '服务收入', '其他', '现金', 2, 14, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (127, '2024-04-15', '收入', 2700, '销售收入', '其他', '银行转账', 3, 15, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (128, '2024-04-16', '收入', 2400, '服务收入', '其他', '支付宝', 4, 16, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (129, '2024-04-17', '收入', 3100, '销售收入', '其他', '银行转账', 1, 17, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (130, '2024-04-18', '收入', 2000, '服务收入', '其他', '现金', 2, 18, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (131, '2024-04-19', '收入', 2600, '销售收入', '其他', '银行转账', 3, 19, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (132, '2024-04-20', '收入', 2500, '服务收入', '其他', '支付宝', 4, 20, '2024-04-01 20:35:10');
INSERT INTO `financial_transaction` VALUES (133, '2024-04-01', '收入', 2500, '租金收入', '其他', '银行转账', 1, 1, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (134, '2024-04-02', '收入', 1500, '版权使用费', '其他', '现金', 2, 2, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (135, '2024-04-03', '收入', 3000, '租金收入', '其他', '银行转账', 3, 3, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (136, '2024-04-04', '收入', 2000, '版权使用费', '其他', '支付宝', 4, 4, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (137, '2024-04-05', '收入', 3500, '租金收入', '其他', '银行转账', 1, 5, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (138, '2024-04-06', '收入', 1800, '版权使用费', '其他', '现金', 2, 6, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (139, '2024-04-07', '收入', 2800, '租金收入', '其他', '银行转账', 3, 7, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (140, '2024-04-08', '收入', 2200, '版权使用费', '其他', '支付宝', 4, 8, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (141, '2024-04-09', '收入', 3200, '租金收入', '其他', '银行转账', 1, 9, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (142, '2024-04-10', '收入', 2100, '版权使用费', '其他', '现金', 2, 10, '2024-04-01 20:38:27');
INSERT INTO `financial_transaction` VALUES (143, '2024-04-11', '收入', 2900, '租金收入', '其他', '支付宝', 3, 11, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (144, '2024-04-12', '收入', 1750, '版权使用费', '其他', '现金', 4, 12, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (145, '2024-04-13', '收入', 3100, '租金收入', '其他', '银行转账', 1, 13, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (146, '2024-04-14', '收入', 2300, '版权使用费', '其他', '支付宝', 2, 14, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (147, '2024-04-15', '收入', 3400, '租金收入', '其他', '现金', 3, 15, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (148, '2024-04-16', '收入', 1650, '版权使用费', '其他', '银行转账', 4, 16, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (149, '2024-04-17', '收入', 2700, '租金收入', '其他', '支付宝', 1, 17, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (150, '2024-04-18', '收入', 1950, '版权使用费', '其他', '现金', 2, 18, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (151, '2024-04-19', '收入', 3300, '租金收入', '其他', '银行转账', 3, 19, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (152, '2024-04-20', '收入', 2400, '版权使用费', '其他', '支付宝', 4, 20, '2024-04-01 20:38:58');
INSERT INTO `financial_transaction` VALUES (153, '2024-04-01', '支出', 500, '办公用品采购', '采购', '银行转账', 1, 1, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (154, '2024-04-02', '支出', 350, '广告宣传费', '广告', '现金', 2, 2, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (155, '2024-04-03', '支出', 2000, '设备维护费', '设备维护', '支付宝', 3, 3, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (156, '2024-04-04', '支出', 800, '运输费用', '运输', '银行转账', 4, 4, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (157, '2024-04-05', '支出', 600, '办公室租金', '租金', '支付宝', 1, 5, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (158, '2024-04-06', '支出', 450, '市场推广费', '市场推广', '现金', 2, 6, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (159, '2024-04-07', '支出', 300, '办公费用', '办公费用', '银行转账', 3, 7, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (160, '2024-04-08', '支出', 700, '税费', '税费', '支付宝', 4, 8, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (161, '2024-04-09', '支出', 950, '利息支出', '利息', '现金', 1, 9, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (162, '2024-04-10', '支出', 550, '其他支出', '其他', '银行转账', 2, 10, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (163, '2024-04-11', '支出', 400, '办公用品采购', '采购', '支付宝', 3, 11, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (164, '2024-04-12', '支出', 300, '广告宣传费', '广告', '现金', 4, 12, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (165, '2024-04-13', '支出', 1800, '设备维护费', '设备维护', '银行转账', 1, 13, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (166, '2024-04-14', '支出', 750, '运输费用', '运输', '支付宝', 2, 14, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (167, '2024-04-15', '支出', 550, '办公室租金', '租金', '现金', 3, 15, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (168, '2024-04-16', '支出', 400, '市场推广费', '市场推广', '银行转账', 4, 16, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (169, '2024-04-17', '支出', 250, '办公费用', '办公费用', '支付宝', 1, 17, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (170, '2024-04-18', '支出', 600, '税费', '税费', '现金', 2, 18, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (171, '2024-04-19', '支出', 850, '利息支出', '利息', '银行转账', 3, 19, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (172, '2024-04-20', '支出', 300, '其他支出', '其他', '支付宝', 4, 20, '2024-04-01 20:40:11');
INSERT INTO `financial_transaction` VALUES (173, '2024-04-26', '支出', 4340, '支付工资', '工资', '银行转账', 4, 4, '2024-04-26 20:46:24');
INSERT INTO `financial_transaction` VALUES (174, '2024-04-26', '支出', 232, '发票报销', '发票报销', '银行转账', 4, 1, '2024-04-26 20:52:42');
INSERT INTO `financial_transaction` VALUES (175, '2024-04-26', '支出', 3564, '支付工资', '工资', '银行转账', 4, 8, '2024-04-26 21:47:55');
INSERT INTO `financial_transaction` VALUES (176, '2024-04-27', '支出', 4657, '发票报销', '发票报销', '银行转账', 4, 9, '2024-04-27 11:23:43');
INSERT INTO `financial_transaction` VALUES (177, '2024-04-27', '支出', 5016, '支付工资', '工资', '银行转账', 4, 3, '2024-04-27 11:26:04');

-- ----------------------------
-- Table structure for invoice
-- ----------------------------
DROP TABLE IF EXISTS `invoice`;
CREATE TABLE `invoice`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `customer_id` int(0) NULL DEFAULT NULL,
  `issue_date` date NULL DEFAULT NULL,
  `due_date` date NULL DEFAULT NULL,
  `total_amount` double NULL DEFAULT NULL,
  `status` int(0) NULL DEFAULT NULL,
  `approve_status` int(0) NULL DEFAULT NULL,
  `approve_date` date NULL DEFAULT NULL,
  `user_id` int(0) NULL DEFAULT NULL,
  `ts` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `employee` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 88333 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoice
-- ----------------------------
INSERT INTO `invoice` VALUES (95, 'INV-002', 5, '2023-08-25', '2023-01-25', 2057.49, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (97, 'INV-004', 3, '2023-01-02', '2023-01-08', 1928.78, 1, 1, '2023-12-02', 7, '2023-12-02 14:44:34', 7);
INSERT INTO `invoice` VALUES (100, 'INV-007', 2, '2023-06-27', '2023-01-03', 9758.55, 1, 1, '2002-12-21', 2, '2023-12-01 17:25:20', 2);
INSERT INTO `invoice` VALUES (101, 'INV-008', 10, '2023-03-26', '2023-01-10', 9616.02, 2, 2, NULL, 2, '2023-12-01 17:25:20', 2);
INSERT INTO `invoice` VALUES (102, 'INV-009', 6, '2023-12-25', '2023-01-12', 9301.97, 1, 1, '2002-12-21', 9, '2023-12-01 17:25:20', 9);
INSERT INTO `invoice` VALUES (103, 'INV-010', 7, '2023-07-23', '2023-01-29', 242.69, 1, 1, '2023-12-02', 5, '2023-12-02 10:03:08', 5);
INSERT INTO `invoice` VALUES (104, 'INV-011', 4, '2023-06-03', '2023-01-01', 8981.36, 1, 1, '2002-12-21', 3, '2023-12-01 17:25:20', 3);
INSERT INTO `invoice` VALUES (105, 'INV-012', 3, '2023-03-26', '2023-01-16', 8762.13, 2, 2, NULL, 6, '2023-12-01 17:25:20', 6);
INSERT INTO `invoice` VALUES (106, 'INV-013', 4, '2023-11-19', '2023-01-15', 7069.75, 1, 1, '2023-12-02', 5, '2023-12-02 10:03:12', 5);
INSERT INTO `invoice` VALUES (107, 'INV-014', 10, '2023-07-30', '2023-01-27', 7055, 2, 2, NULL, 3, '2023-12-01 17:25:20', 3);
INSERT INTO `invoice` VALUES (108, 'INV-015', 6, '2023-11-18', '2023-01-27', 7155.82, 2, 2, NULL, 7, '2023-12-01 17:25:20', 7);
INSERT INTO `invoice` VALUES (109, 'INV-016', 5, '2023-06-01', '2023-01-19', 7769.75, 1, 1, '2023-12-02', 1, '2023-12-02 10:03:11', 1);
INSERT INTO `invoice` VALUES (110, 'INV-017', 10, '2023-09-14', '2023-01-19', 212.9, 1, 1, '2023-12-02', 1, '2023-12-02 10:03:18', 1);
INSERT INTO `invoice` VALUES (111, 'INV-018', 8, '2023-05-04', '2023-01-17', 6923.77, 2, 2, NULL, 2, '2023-12-01 17:25:20', 2);
INSERT INTO `invoice` VALUES (112, 'INV-019', 1, '2023-12-19', '2023-01-20', 3031.37, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (113, 'INV-020', 6, '2023-08-11', '2023-01-11', 9631.28, 2, 2, NULL, 9, '2023-12-01 17:25:20', 9);
INSERT INTO `invoice` VALUES (114, 'INV-021', 9, '2023-08-24', '2023-01-24', 249.66, 2, 2, NULL, 7, '2023-12-01 17:25:20', 7);
INSERT INTO `invoice` VALUES (115, 'INV-022', 1, '2023-04-11', '2023-01-07', 3113.76, 2, 2, NULL, 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (116, 'INV-023', 6, '2023-07-06', '2023-01-26', 7943.97, 1, 1, '2002-12-21', 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (117, 'INV-024', 3, '2023-01-12', '2023-01-09', 2512.89, 1, 1, '2002-12-21', 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (118, 'INV-025', 2, '2023-01-19', '2023-01-29', 5658.4, 2, 2, NULL, 3, '2023-12-01 17:25:20', 3);
INSERT INTO `invoice` VALUES (119, 'INV-026', 5, '2023-05-19', '2023-01-17', 6297.03, 1, 1, '2002-12-21', 6, '2023-12-01 17:25:20', 6);
INSERT INTO `invoice` VALUES (120, 'INV-027', 3, '2023-08-28', '2023-01-16', 5996.4, 1, 1, '2002-12-21', 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (121, 'INV-028', 1, '2023-08-30', '2023-01-08', 2605.61, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (122, 'INV-029', 4, '2023-10-05', '2023-01-22', 3819.8, 2, 2, NULL, 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (123, 'INV-030', 10, '2023-07-29', '2023-01-29', 973.22, 1, 1, '2002-12-21', 7, '2023-12-01 17:25:20', 7);
INSERT INTO `invoice` VALUES (124, 'INV-031', 7, '2023-03-22', '2023-01-04', 6.96, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (125, 'INV-032', 3, '2023-05-28', '2023-01-05', 4860.85, 1, 1, '2023-12-02', 6, '2023-12-02 15:12:37', 6);
INSERT INTO `invoice` VALUES (126, 'INV-033', 10, '2023-12-23', '2023-01-01', 1876.45, 2, 2, NULL, 8, '2023-12-01 17:25:20', 8);
INSERT INTO `invoice` VALUES (127, 'INV-034', 3, '2023-12-20', '2023-01-03', 4420.26, 1, 1, '2023-12-02', 7, '2023-12-02 15:06:55', 7);
INSERT INTO `invoice` VALUES (128, 'INV-035', 5, '2023-02-18', '2023-01-11', 3013.43, 1, 1, '2002-12-21', 6, '2023-12-01 17:25:20', 6);
INSERT INTO `invoice` VALUES (129, 'INV-036', 3, '2023-06-21', '2023-01-21', 848.33, 1, 1, '2023-12-02', 4, '2023-12-02 15:28:52', 4);
INSERT INTO `invoice` VALUES (130, 'INV-037', 10, '2023-09-11', '2023-01-17', 6694.27, 2, 2, NULL, 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (131, 'INV-038', 3, '2023-10-26', '2023-01-11', 3440.49, 1, 1, '2002-12-21', 2, '2023-12-01 17:25:20', 2);
INSERT INTO `invoice` VALUES (132, 'INV-039', 10, '2023-04-25', '2023-01-20', 3241.69, 1, 1, '2002-12-21', 4, '2023-12-01 17:25:20', 4);
INSERT INTO `invoice` VALUES (133, 'INV-040', 8, '2023-08-28', '2023-01-03', 3638.86, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (134, 'INV-041', 2, '2023-10-14', '2023-01-14', 9045.74, 1, 1, '2023-12-02', 2, '2023-12-02 15:28:46', 2);
INSERT INTO `invoice` VALUES (135, 'INV-042', 1, '2023-01-04', '2023-01-26', 1526.11, 1, 1, '2023-12-02', 9, '2023-12-02 15:36:15', 9);
INSERT INTO `invoice` VALUES (136, 'INV-043', 4, '2023-03-07', '2023-01-28', 365.02, 1, 1, '2002-12-21', 1, '2023-12-01 17:25:20', 1);
INSERT INTO `invoice` VALUES (137, 'INV-044', 1, '2023-03-21', '2023-01-25', 3911.2, 1, 1, '2002-12-21', 5, '2023-12-01 17:25:20', 5);
INSERT INTO `invoice` VALUES (138, 'INV-045', 8, '2023-07-26', '2023-01-13', 4346.28, 2, 2, NULL, 2, '2023-12-01 17:25:20', 2);
INSERT INTO `invoice` VALUES (139, 'INV-046', 2, '2023-05-07', '2023-01-07', 244.76, 1, 1, '2002-12-21', 4, '2023-12-01 17:25:20', 4);
INSERT INTO `invoice` VALUES (140, 'INV-047', 4, '2023-07-05', '2023-01-19', 4815.43, 1, 1, '2002-12-21', 6, '2023-12-01 17:25:20', 6);
INSERT INTO `invoice` VALUES (141, 'INV-048', 1, '2023-06-25', '2023-01-09', 284.75, 1, 1, '2023-12-02', 3, '2023-12-02 15:36:45', 3);
INSERT INTO `invoice` VALUES (142, 'INV-049', 3, '2023-08-29', '2023-01-16', 6563.71, 2, 2, NULL, 6, '2023-12-01 17:25:20', 6);
INSERT INTO `invoice` VALUES (143, 'INV-050', 7, '2023-06-12', '2023-01-12', 5744.82, 2, 2, NULL, 9, '2023-12-01 17:25:20', 9);
INSERT INTO `invoice` VALUES (157, '99', 2, '2023-12-20', '2023-12-13', 5678, 2, 2, NULL, 4, '2024-04-27 11:23:47', NULL);
INSERT INTO `invoice` VALUES (8567, '23', 23, '2023-12-14', '2023-12-26', 232, 1, 1, '2024-04-26', 1, '2024-04-26 20:52:41', NULL);
INSERT INTO `invoice` VALUES (13854, '232', 23, '2023-11-30', '2023-12-27', 23, 1, 1, '2024-03-30', 5, '2024-03-30 10:26:47', NULL);
INSERT INTO `invoice` VALUES (20325, '23', 45, '2023-12-13', '2023-12-27', 3333, 2, 2, NULL, 5, '2023-12-02 15:53:36', NULL);
INSERT INTO `invoice` VALUES (26628, '5678', 4567, '2023-12-13', '2023-12-28', 4657, 1, 1, '2024-04-27', 9, '2024-04-27 11:23:43', NULL);
INSERT INTO `invoice` VALUES (29320, '23', 23, '2023-12-21', '2023-12-26', 23, 1, 1, '2023-12-04', 1, '2023-12-04 13:46:01', NULL);
INSERT INTO `invoice` VALUES (44684, '43', 34, '2023-12-14', '2023-12-27', 34, 2, 2, NULL, 2, '2023-12-04 13:49:26', NULL);
INSERT INTO `invoice` VALUES (49687, '23', 23, '2023-12-06', '2023-12-27', 22, 0, 0, NULL, 1, '2023-12-02 15:18:38', NULL);
INSERT INTO `invoice` VALUES (60303, '66', 5, '2023-12-13', '2023-12-28', 343, 1, 1, '2023-12-14', 4, '2023-12-14 11:22:38', NULL);
INSERT INTO `invoice` VALUES (63917, '12', 12, '2023-12-25', '2023-12-19', 12, 1, 1, '2023-12-15', 6, '2023-12-15 11:27:18', NULL);
INSERT INTO `invoice` VALUES (69540, '99', 1, '2023-12-01', '2023-12-26', 13, 1, 1, '2023-12-02', 1, '2023-12-02 15:15:52', NULL);
INSERT INTO `invoice` VALUES (88331, '4', 24, '2023-12-07', '2023-12-29', 45, 1, 1, '2023-12-02', 6, '2023-12-02 16:04:33', NULL);
INSERT INTO `invoice` VALUES (88332, 'ind24343', NULL, '2024-04-01', '2024-04-04', 999, 0, 0, NULL, 6, '2024-04-27 11:24:12', NULL);

-- ----------------------------
-- Table structure for off
-- ----------------------------
DROP TABLE IF EXISTS `off`;
CREATE TABLE `off`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `employee_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` tinyint(0) NULL DEFAULT NULL,
  `employee_id` int(0) NULL DEFAULT NULL,
  `leave_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ts` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `approve_date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `employee_id`(`employee_id`) USING BTREE,
  CONSTRAINT `off_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 62601 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of off
-- ----------------------------
INSERT INTO `off` VALUES (1, '张三', '2023-11-01', '2023-11-03', '你管我呢', 1, 1, '事假', '2023-12-02 15:35:27', '2023-12-02');
INSERT INTO `off` VALUES (2, '李四', '2023-11-05', '2023-11-07', '你管我呢', 1, 2, '病假', '2023-12-02 15:59:58', '2023-12-02');
INSERT INTO `off` VALUES (3, '王五', '2023-11-10', '2023-11-12', '你管我呢', 1, 3, '事假', '2023-12-02 16:00:03', '2023-12-02');
INSERT INTO `off` VALUES (4, '张三', '2023-02-08', '2023-02-10', '你管我呢hhh', 1, 1, '病假', '2023-12-02 16:00:26', '2023-12-02');
INSERT INTO `off` VALUES (5, '李四', '2023-02-08', '2023-02-10', '你管我呢', 1, 2, '病假', '2023-12-02 16:07:29', '2023-12-02');
INSERT INTO `off` VALUES (6, '王五', '2023-02-08', '2023-02-10', '你管我呢', 2, 3, '病假', '2023-12-02 16:08:04', NULL);
INSERT INTO `off` VALUES (7, '赵六', '2023-02-08', '2023-02-10', '你管我呢', 0, 4, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (8, '刘七', '2023-02-08', '2023-02-10', '你管我呢', 0, 5, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (9, '陈八', '2023-02-08', '2023-02-10', '你管我呢', 0, 6, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (10, '周九', '2023-02-08', '2023-02-10', '你管我呢', 1, 7, '病假', '2023-12-15 10:39:39', '2023-12-15');
INSERT INTO `off` VALUES (11, '吴十', '2023-02-08', '2023-02-10', '你管我呢', 0, 8, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (12, '郑十一', '2023-02-08', '2023-02-10', '你管我呢', 1, 9, '病假', '2023-12-04 14:02:54', '2023-12-04');
INSERT INTO `off` VALUES (13, '孙十二', '2023-02-08', '2023-02-10', '你管我呢', 0, 10, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (19, '张三', '2023-01-04', '2023-01-06', '你管我呢', 1, 1, '病假', '2024-07-02 22:56:07', '2024-07-02');
INSERT INTO `off` VALUES (20, '李四', '2023-01-04', '2023-01-06', '你管我呢', 0, 2, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (21, '王五', '2023-01-04', '2023-01-06', '你管我呢', 0, 3, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (22, '赵六', '2023-01-04', '2023-01-06', '你管我呢', 0, 4, '病假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (24, '陈八', '2023-01-04', '2023-01-06', '你管我呢', 2, 6, '病假', '2024-07-02 22:55:59', NULL);
INSERT INTO `off` VALUES (25, '周九', '2023-01-04', '2023-01-06', '你管我呢', 1, 7, '病假', '2024-07-02 22:56:01', '2024-07-02');
INSERT INTO `off` VALUES (26, '吴十', '2023-01-04', '2023-01-06', '你管我呢', 1, 8, '病假', '2023-12-15 10:45:06', '2023-12-15');
INSERT INTO `off` VALUES (27, '郑十一', '2023-01-04', '2023-01-06', '你管我呢', 1, 9, '病假', '2023-12-15 11:00:15', '2023-12-15');
INSERT INTO `off` VALUES (28, '孙十二', '2023-01-04', '2023-01-06', '你管我呢', 1, 10, '病假', '2024-07-02 22:56:05', '2024-07-02');
INSERT INTO `off` VALUES (34, '张三', '2023-02-05', '2023-02-07', '你管我呢', 1, 1, '事假', '2024-03-30 17:33:06', '2024-03-30');
INSERT INTO `off` VALUES (35, '李四', '2023-02-05', '2023-02-07', '你管我呢', 0, 2, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (36, '王五', '2023-02-05', '2023-02-07', '你管我呢', 0, 3, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (37, '赵六', '2023-02-05', '2023-02-07', '你管我呢', 0, 4, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (38, '刘七', '2023-02-05', '2023-02-07', '你管我呢', 1, 5, '事假', '2024-03-30 10:25:15', '2024-03-30');
INSERT INTO `off` VALUES (39, '陈八', '2023-02-05', '2023-02-07', '你管我呢', 0, 6, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (40, '周九', '2023-02-05', '2023-02-07', '你管我呢', 1, 7, '事假', '2023-12-02 16:03:01', '2023-12-02');
INSERT INTO `off` VALUES (41, '吴十', '2023-02-05', '2023-02-07', '你管我呢', 0, 8, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (42, '郑十一', '2023-02-05', '2023-02-07', '你管我呢', 0, 9, '事假', '2023-12-02 14:43:08', NULL);
INSERT INTO `off` VALUES (43, '孙十二', '2023-02-05', '2023-02-07', '你管我呢', 1, 10, '事假', '2024-03-30 17:33:15', '2024-03-30');
INSERT INTO `off` VALUES (49, '张三', '2023-01-01', '2023-01-03', '你管我呢', 1, 1, '事假', '2023-12-02 16:20:14', '2023-12-02');
INSERT INTO `off` VALUES (50, '李四', '2023-01-01', '2023-01-03', '你管我呢', 2, 2, '事假', '2023-12-02 16:20:11', NULL);
INSERT INTO `off` VALUES (51, '王五', '2023-01-01', '2023-01-03', '你管我呢', 1, 3, '事假', '2023-12-15 11:27:27', '2023-12-15');
INSERT INTO `off` VALUES (52, '赵六', '2023-01-01', '2023-01-03', '你管我呢', 2, 4, '事假', '2024-04-27 11:19:41', NULL);
INSERT INTO `off` VALUES (53, '刘七', '2023-01-01', '2023-01-03', '你管我呢', 2, 5, '事假', '2023-12-04 14:02:59', NULL);
INSERT INTO `off` VALUES (54, '陈八', '2023-01-01', '2023-01-03', '你管我呢', 1, 6, '事假', '2024-04-27 11:24:49', '2024-04-27');
INSERT INTO `off` VALUES (55, '周九', '2023-01-01', '2023-01-03', '你管我呢', 1, 7, '事假', '2024-03-30 17:33:12', '2024-03-30');
INSERT INTO `off` VALUES (56, '吴十', '2023-01-01', '2023-01-03', '你管我呢', 2, 8, '事假', '2024-04-27 11:24:52', NULL);
INSERT INTO `off` VALUES (57, '郑十一', '2023-01-01', '2023-01-03', '你管我呢', 1, 9, '事假', '2024-04-27 11:19:37', '2024-04-27');
INSERT INTO `off` VALUES (58, '孙十二', '2023-01-01', '2023-01-03', '你管我呢', 1, 10, '事假', '2023-12-11 16:47:27', '2023-12-11');
INSERT INTO `off` VALUES (64, '张三', '2023-01-01', '2023-01-03', '你管我呢', 1, 1, '事假', '2024-03-30 10:41:34', '2024-03-30');
INSERT INTO `off` VALUES (65, '李四', '2023-01-01', '2023-01-03', '你管我呢', 1, 2, '事假', '2023-12-11 16:47:32', '2023-12-11');
INSERT INTO `off` VALUES (66, '王五', '2023-01-01', '2023-01-03', '你管我呢', 1, 3, '事假', '2024-07-02 22:55:54', '2024-07-02');
INSERT INTO `off` VALUES (67, '赵六', '2023-01-01', '2023-01-03', '你管我呢', 1, 4, '事假', '2024-04-01 17:17:11', '2024-04-01');
INSERT INTO `off` VALUES (68, '刘七', '2023-01-01', '2023-01-03', '你管我呢', 1, 5, '事假', '2024-04-26 21:58:07', '2024-04-26');
INSERT INTO `off` VALUES (69, '陈八', '2023-01-01', '2023-01-03', '你管我呢', 2, 6, '事假', '2023-12-02 16:20:09', NULL);
INSERT INTO `off` VALUES (70, '周九', '2023-01-01', '2023-01-03', '你管我呢', 2, 7, '事假', '2023-12-02 16:20:08', NULL);
INSERT INTO `off` VALUES (71, '吴十', '2023-01-01', '2023-01-03', '你管我呢', 1, 8, '事假', '2023-12-15 10:56:53', '2023-12-15');
INSERT INTO `off` VALUES (72, '郑十一', '2023-01-01', '2023-01-03', '你管我呢', 1, 9, '事假', '2024-04-26 21:58:12', '2024-04-26');
INSERT INTO `off` VALUES (73, '孙十二', '2023-01-01', '2023-01-03', '你管我呢', 1, 10, '事假', '2024-04-27 11:19:39', '2024-04-27');
INSERT INTO `off` VALUES (5852, '赵六', '2023-12-12', '2023-12-21', '不想上班', 0, 4, '事假', '2023-12-04 08:53:49', NULL);
INSERT INTO `off` VALUES (62175, '陈八', '2023-12-04', '2023-12-12', '不同', 0, 6, '事假', '2023-12-02 16:55:25', NULL);
INSERT INTO `off` VALUES (62598, '刘七', '2023-12-13', '2023-12-21', '不管你是', 1, 5, '病假', '2024-03-30 10:25:29', '2024-03-30');
INSERT INTO `off` VALUES (62599, '李四', '2024-04-01', '2024-04-02', '的身份擦速度', 0, 2, '病假', '2024-04-26 21:57:35', NULL);
INSERT INTO `off` VALUES (62600, '刘七', '2024-04-08', '2024-04-10', 'kjvbskjvsk', 1, 5, '病假', '2024-04-27 11:25:18', '2024-04-27');

-- ----------------------------
-- Table structure for salary
-- ----------------------------
DROP TABLE IF EXISTS `salary`;
CREATE TABLE `salary`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `employee_id` int(0) NOT NULL,
  `basic_salary` decimal(10, 2) NOT NULL,
  `performance_salary` decimal(10, 2) NOT NULL,
  `social_security_base` decimal(10, 2) NOT NULL,
  `social_security_rate` decimal(5, 2) NOT NULL,
  `housing_fund_base` decimal(10, 2) NOT NULL,
  `housing_fund_rate` decimal(5, 2) NOT NULL,
  `annual_bonus` decimal(10, 2) NOT NULL,
  `hire_date` date NOT NULL,
  `position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ranking` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `get_salary` decimal(10, 2) GENERATED ALWAYS AS (((((`basic_salary` + (`percent` * `performance_salary`)) + `annual_bonus`) - (`housing_fund_base` * `housing_fund_rate`)) - (`social_security_base` * `social_security_rate`))) STORED NULL,
  `salary_month` date NOT NULL,
  `percent` double NULL DEFAULT NULL COMMENT '绩效完成比例',
  `off_days` int(0) NOT NULL COMMENT '请假天数',
  `status` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `employee_id`(`employee_id`) USING BTREE,
  CONSTRAINT `salary_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of salary
-- ----------------------------
INSERT INTO `salary` VALUES (1, 1, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2020-01-01', '经理', '高级', DEFAULT, '2023-11-01', 0.98, 0, 0);
INSERT INTO `salary` VALUES (2, 2, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2019-06-15', '工程师', '中级', DEFAULT, '2023-11-01', 0.9, 0, 1);
INSERT INTO `salary` VALUES (3, 3, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2018-03-10', '助理', '初级', DEFAULT, '2023-11-01', 0.67, 0, 0);
INSERT INTO `salary` VALUES (4, 4, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2021-09-05', '销售代表', '初级', DEFAULT, '2023-11-01', 0.87, 0, 1);
INSERT INTO `salary` VALUES (5, 5, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2017-11-20', '项目经理', '高级', DEFAULT, '2023-11-01', 0.6, 0, 0);
INSERT INTO `salary` VALUES (6, 6, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2019-02-25', '财务主管', '中级', DEFAULT, '2023-09-01', 0.45, 0, 0);
INSERT INTO `salary` VALUES (7, 7, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2020-07-10', '市场专员', '初级', DEFAULT, '2023-11-01', 0.87, 0, 0);
INSERT INTO `salary` VALUES (8, 8, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2018-04-18', '人力资源经理', '高级', DEFAULT, '2023-11-01', 0.88, 0, 1);
INSERT INTO `salary` VALUES (9, 9, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2022-02-05', '技术支持工程师', '初级', DEFAULT, '2023-11-01', 0.98, 0, 0);
INSERT INTO `salary` VALUES (10, 10, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2019-09-20', '行政助理', '初级', DEFAULT, '2023-11-01', 1, 0, 0);
INSERT INTO `salary` VALUES (12, 2, 5000.00, 1900.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2023-12-13', '地产商', '初级', DEFAULT, '2023-12-01', 0.7, 0, 1);
INSERT INTO `salary` VALUES (13, 2, 5000.00, 1900.00, 4000.00, 0.08, 3000.00, 0.10, 2000.00, '2023-12-13', '地产商', '初级', DEFAULT, '2023-10-01', 0.7, 0, 1);
INSERT INTO `salary` VALUES (14, 5, 6000.00, 2000.00, 5000.00, 0.07, 4000.00, 0.10, 0.00, '2023-12-01', '项目经理', '初级', DEFAULT, '2023-08-01', 0.9, 0, 0);
INSERT INTO `salary` VALUES (15, 5, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 2323.00, '2017-11-20', '项目经理', '高级', DEFAULT, '2023-12-01', 0.99, 1, 0);
INSERT INTO `salary` VALUES (16, 8, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 23.00, '2018-04-18', '人力资源经理', '高级', DEFAULT, '2023-02-01', 0.98, 8, 1);
INSERT INTO `salary` VALUES (17, 4, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 0.00, '2021-09-05', '销售代表', '初级', DEFAULT, '2023-06-01', 0.87, 4, 1);
INSERT INTO `salary` VALUES (18, 3, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 0.00, '2018-03-10', '助理', '初级', DEFAULT, '2023-01-01', 1, 5, 0);
INSERT INTO `salary` VALUES (19, 9, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 9.00, '2022-02-05', '技术支持工程师', '初级', DEFAULT, '2019-02-01', 1, 2, 0);
INSERT INTO `salary` VALUES (21, 9, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 10000.00, '2022-02-05', '技术支持工程师', '初级', DEFAULT, '2023-01-01', 0.98, 0, 1);
INSERT INTO `salary` VALUES (22, 3, 5000.00, 1000.00, 4000.00, 0.08, 3000.00, 0.10, 111.00, '2018-03-10', '助理', '初级', DEFAULT, '2024-05-01', 0.98, 2, 1);
INSERT INTO `salary` VALUES (23, 5, 6000.00, 2000.00, 5000.00, 0.07, 4000.00, 0.10, 444.00, '2017-11-20', '项目经理', '初级', DEFAULT, '2024-06-01', 1.12, 1, 0);
INSERT INTO `salary` VALUES (25, 5, 6000.00, 2000.00, 5000.00, 0.07, 4000.00, 0.10, 111.00, '2017-11-20', '项目经理', '初级', DEFAULT, '2024-01-01', 1, 11, 0);

SET FOREIGN_KEY_CHECKS = 1;
