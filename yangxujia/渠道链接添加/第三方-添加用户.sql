
-- 生成随机密码

-- MD5加密

-- 找到对应渠道
select * from report.t_device_channel t where t.CHANNEL_NO='apple_p022';


select * from report.t_device_channel t where t.COMPANY_NAME ='简思网络' -- jiansiwl -- mjY3Yuab

select * from report.t_device_channel t where t.CHANNEL_NAME='北京足球PK10';

-- 创建用户数据
-- KxvfFT12
INSERT INTO `console`.`t_partner_user` (`u_user_name`, `u_login_name`, `u_login_pwd`)
 VALUES ('有百科技1', 'youbaikj', '24eabaf5ca31900da1d2f2e92bc603ef');
 	
select * from console.t_partner_user tt where tt.u_user_name;


-- 通过ID给用户分配渠道
INSERT INTO `report`.`t_rpt_user_cooperator_ref` (`USER_ID`, `CHANNEL_NO`) 
select u_user_id,'youbaikj' from  console.t_partner_user u where u.u_login_name='youbaikj';

-- 在页面上给用户分配页面权限
-- 5Irkbaxh
select * from console.t_partner_user t where t.u_login_name='chuanglian';

select * from  report.t_rpt_user_cooperator_ref t where t.USER_ID='344';


select u_user_id,'lqwx' from  console.t_partner_user u where u.u_login_name='lqwx';

select * from t_rpt_user_cooperator_ref t where t.USER_ID='466';

select * from t_rpt_user_cooperator_ref t where t.CHANNEL_NO='zy1';











