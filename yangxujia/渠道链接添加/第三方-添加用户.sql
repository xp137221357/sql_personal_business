
-- 生成随机密码

-- MD5加密

-- 找到对应渠道
select * from report.t_device_channel t where t.CHANNEL_NO='apple_p022';


select * from report.t_device_channel t where t.COMPANY_NAME ='简思网络' -- jiansiwl -- mjY3Yuab

select * from report.t_device_channel t where t.CHANNEL_NAME='北京足球PK10';

-- 创建用户数据
INSERT INTO `console`.`t_sys_user` (`u_user_name`, `u_login_name`, `u_login_pwd`, `u_remark`, `u_user_code`,`crt_date`)
 VALUES ('北京足球PK10', 'jiansiwl', 'c67abed0c2166749906aa8925410db1d', '北京足球PK10', 'jiansiwl',now());
 	
select * from console.t_sys_user tt where tt.u_user_name;


-- 通过ID给用户分配渠道
INSERT INTO `report`.`t_rpt_user_cooperator_ref` (`USER_ID`, `CHANNEL_NO`) 
select u_user_id,'apple_p022' from  console.t_sys_user u where u.u_login_name='jiansiwl';

-- 在页面上给用户分配页面权限
-- 5Irkbaxh
select * from console.t_sys_user t where t.u_login_name='chuanglian';

select * from  report.t_rpt_user_cooperator_ref t where t.USER_ID='344';


select u_user_id,'lqwx' from  console.t_sys_user u where u.u_login_name='lqwx';

select * from t_rpt_user_cooperator_ref t where t.CHANNEL_NO='jrtt-jingcai';


