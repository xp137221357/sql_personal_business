
-- 生成随机密码

-- MD5加密

-- 找到对应渠道
select * from report.t_device_channel t where t.CHANNEL_NO='ZHYGX1';

select * from report.t_device_channel t where t.CHANNEL_NAME='优启科技1';

-- 创建用户数据
INSERT INTO `console`.`t_sys_user` (`u_user_name`, `u_login_name`, `u_login_pwd`, `u_remark`, `u_user_code`,`crt_date`)
 VALUES ('优启科技1', 'youqikj', '27c2105dbec6413cf6144d9a57b2a3e1', '优启科技1', 'youqikj','2017-02-16 15:12:03');
select * from console.t_sys_user tt where tt.u_user_name;


-- 通过ID给用户分配渠道
INSERT INTO `report`.`t_rpt_user_cooperator_ref` (`USER_ID`, `CHANNEL_NO`) 
select u_user_id,'apple_p014' from  console.t_sys_user u where u.u_login_name='youqikj';

-- 在页面上给用户分配页面权限

-- 6FCaRbFx





