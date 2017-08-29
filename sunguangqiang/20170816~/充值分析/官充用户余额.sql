-- 官充用户余额
set @param0='2017-08-14';
set @param1='2017-08-21';

-- 仅仅官充每笔充值金额
-- drop table t_stat_app_recharge_user_app_70170821;
CREATE TABLE `t_stat_app_recharge_user_app_70170821` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`NICK_NAME` VARCHAR(100) NULL DEFAULT NULL,
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`ACCT_NUM` VARCHAR(50) NULL DEFAULT NULL COMMENT '用户会员号',
	`recharge_coins` DOUBLE NULL DEFAULT NULL,
	`rmb_value` DOUBLE NULL DEFAULT NULL,
	`after_value` DOUBLE NULL DEFAULT NULL,
	`is_only_app` INT(1) NOT NULL DEFAULT '0',
	`is_inner_ip` INT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `USER_ID` (`USER_ID`)
);

insert into t_stat_app_recharge_user_app_70170821(NICK_NAME,USER_ID,ACCT_NUM,recharge_coins,rmb_value,after_value,is_only_app,is_inner_ip)
select u.NICK_NAME,u.USER_ID, u.ACCT_NUM,sum(tc.coins) recharge_coins,sum(tc.rmb_value) rmb_value,0 after_value, 0 is_only_app,0 is_inner_ip
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.`STATUS`=10
where tc.crt_time<@param1
and tc.charge_method='app'
group by tc.charge_user_id
on duplicate key update 
recharge_coins = values(recharge_coins),
rmb_value = values(rmb_value),
after_value = values(after_value),
is_only_app = values(is_only_app),
is_inner_ip = values(is_inner_ip);

update t_stat_app_recharge_user_app_70170821 t
inner join report.t_trans_user_recharge_coin tc on t.USER_ID=tc.charge_user_id
and tc.charge_method!='app'
set t.is_only_app=1;


-- 第三方每笔充值金额
-- drop table t_stat_app_recharge_user_third_70170821;
CREATE TABLE `t_stat_app_recharge_user_third_70170821` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`NICK_NAME` VARCHAR(100) NULL DEFAULT NULL,
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`ACCT_NUM` VARCHAR(50) NULL DEFAULT NULL COMMENT '用户会员号',
	`recharge_coins` DOUBLE NULL DEFAULT NULL,
	`rmb_value` DOUBLE NULL DEFAULT NULL,
	`after_value` DOUBLE NULL DEFAULT NULL,
	`is_only_third` INT(1) NOT NULL DEFAULT '0',
	`is_inner_ip` INT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `USER_ID` (`USER_ID`)
);

insert into t_stat_app_recharge_user_third_70170821(NICK_NAME,USER_ID,ACCT_NUM,recharge_coins,rmb_value,after_value,is_only_third,is_inner_ip)
select u.NICK_NAME,u.USER_ID, u.ACCT_NUM,sum(tc.coins) recharge_coins,sum(tc.rmb_value) rmb_value,0 after_value,0 is_only_third,0 is_inner_ip
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.`STATUS`=10
where tc.crt_time<@param1
and tc.charge_method!='app'
group by tc.charge_user_id
on duplicate key update 
recharge_coins = values(recharge_coins),
rmb_value = values(rmb_value),
after_value = values(after_value),
is_only_third = values(is_only_third),
is_inner_ip = values(is_inner_ip);

update t_stat_app_recharge_user_third_70170821 t
inner join report.t_trans_user_recharge_coin tc on t.USER_ID=tc.charge_user_id
and tc.charge_method='app'
set t.is_only_third=1;

call pro_t_stat_app_recharge_user_app_70170821();
call pro_t_stat_app_recharge_user_third_70170821();


-- -----------------------------------------------------------------------------------
select  
'仅官充',
t.USER_ID'用户ID',
t.NICK_NAME '用户昵称',
t.ACCT_NUM '会员号',
t.recharge_coins '充值金币',
t.rmb_value '充值金额',
round(t.after_value) '余额',
if(t.is_inner_ip=1,'内部ip','外部ip') 'ip归属'
from t_stat_app_recharge_user_app_70170821 t
where t.is_only_app =0;

select  
'仅官充',
t.USER_ID'用户ID',
t.NICK_NAME '用户昵称',
t.ACCT_NUM '会员号',
t.recharge_coins '充值金币',
t.rmb_value '充值金额',
round(t.after_value) '余额',
if(t.is_inner_ip=1,'内部ip','外部ip') 'ip归属'
from t_stat_app_recharge_user_third_70170821 t
where t.is_only_third =0;


select 
'既官充又第三方',
t1.USER_ID'用户ID',
t1.NICK_NAME '用户昵称',
t1.ACCT_NUM '会员号',
sum(t1.recharge_coins)+sum(t2.recharge_coins) '充值金币',
sum(t1.rmb_value)+sum(t2.rmb_value) '充值金额',
round(t1.after_value) '余额',
if(t1.is_inner_ip=1,'内部ip','外部ip') 'ip归属'
from t_stat_app_recharge_user_app_70170821 t1
inner join t_stat_app_recharge_user_third_70170821 t2
on t1.USER_ID=t2.USER_ID
group by t1.USER_ID;







