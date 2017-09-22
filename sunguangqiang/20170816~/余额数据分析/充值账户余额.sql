用户分类：
一、充值类（过滤已封的号）
仅官充
仅第三方充
官充+第三方充

二、未充值用户（过滤已封的号）
三、已封禁的帐号
四、第三方帐号

-- 官充用户余额

set @param1=now();

select @param1;

-- 仅仅官充每笔充值金额
-- drop table t_stat_app_recharge_user_app_20170912;
CREATE TABLE `t_stat_app_recharge_user_app_20170912` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`NICK_NAME` VARCHAR(100) NULL DEFAULT NULL,
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`ACCT_NUM` VARCHAR(50) NULL DEFAULT NULL COMMENT '用户会员号',
	`recharge_coins` DOUBLE NULL DEFAULT NULL,
	`rmb_coins` DOUBLE NULL DEFAULT NULL,
	`recharge_diamonds` DOUBLE NULL DEFAULT NULL,
	`rmb_diamonds` DOUBLE NULL DEFAULT NULL,
	`coin_balance` DOUBLE NULL DEFAULT NULL,
	`coin_freeze` DOUBLE NULL DEFAULT NULL,
	`is_only_app` INT(1) NOT NULL DEFAULT '0',
	`is_inner_ip` INT(1) NOT NULL DEFAULT '0',
	`agent_name` VARCHAR(50) NULL DEFAULT NULL,
	`agent_acct_num` VARCHAR(50) NULL DEFAULT NULL,
	`last_luanch_time` datetime NULL DEFAULT NULL,
	`last_bet_time`  datetime NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `IDX_USER_ID` (`USER_ID`)
);

insert into t_stat_app_recharge_user_app_20170912(NICK_NAME,USER_ID,ACCT_NUM,recharge_coins,rmb_coins,coin_balance,is_only_app,is_inner_ip)
select u.NICK_NAME,u.USER_ID, u.ACCT_NUM,sum(tc.coins) recharge_coins,sum(tc.rmb_value) rmb_value,0 after_value, 0 is_only_app,0 is_inner_ip
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.`STATUS`=10 and u.CLIENT_ID='byapp'
where tc.crt_time<@param1
and tc.charge_method='app'
and u.USER_ID not in (
select user_id from report.t_user_system
union all
select user_id from report.t_user_merchant
)
group by tc.charge_user_id
on duplicate key update 
recharge_coins = values(recharge_coins),
rmb_coins = values(rmb_coins),
coin_balance = values(coin_balance),
is_only_app = values(is_only_app),
is_inner_ip = values(is_inner_ip);


insert into t_stat_app_recharge_user_app_20170912(NICK_NAME,USER_ID,ACCT_NUM,recharge_diamonds,rmb_diamonds,coin_balance,is_only_app,is_inner_ip)
select u.NICK_NAME,u.USER_ID, u.ACCT_NUM,sum(tc.diamonds) recharge_diamonds,sum(tc.rmb_value) rmb_diamonds,0 after_value, 0 is_only_app,0 is_inner_ip
from report.t_trans_user_recharge_diamond tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.`STATUS`=10 and u.CLIENT_ID='byapp'
where tc.crt_time<@param1
and tc.charge_method='app'
and u.USER_ID not in (
select user_id from report.t_user_system
union all
select user_id from report.t_user_merchant
)
group by tc.charge_user_id
on duplicate key update 
recharge_diamonds = values(recharge_diamonds),
rmb_diamonds = values(rmb_diamonds),
coin_balance = values(coin_balance),
is_only_app = values(is_only_app),
is_inner_ip = values(is_inner_ip);


update t_stat_app_recharge_user_app_20170912 t
inner join report.t_trans_user_recharge_coin tc on t.USER_ID=tc.charge_user_id
and tc.crt_time<@param1
and tc.charge_method!='app'
set t.is_only_app=1;

update t_stat_app_recharge_user_app_20170912 t
inner join report.t_trans_user_recharge_diamond tc on t.USER_ID=tc.charge_user_id
and tc.crt_time<@param1
and tc.charge_method!='app'
set t.is_only_app=1;


-- 第三方每笔充值金额
-- drop table t_stat_app_recharge_user_third_20170912;

CREATE TABLE `t_stat_app_recharge_user_third_20170912` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`NICK_NAME` VARCHAR(100) NULL DEFAULT NULL,
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`ACCT_NUM` VARCHAR(50) NULL DEFAULT NULL COMMENT '用户会员号',
	`recharge_coins` DOUBLE NULL DEFAULT NULL,
	`rmb_coins` DOUBLE NULL DEFAULT NULL,
	`recharge_diamonds` DOUBLE NULL DEFAULT NULL,
	`rmb_diamonds` DOUBLE NULL DEFAULT NULL,
	`coin_balance` DOUBLE NULL DEFAULT NULL,
	`coin_freeze` DOUBLE NULL DEFAULT NULL,
	`is_only_third` INT(1) NOT NULL DEFAULT '0',
	`is_inner_ip` INT(1) NOT NULL DEFAULT '0',
	`agent_name` VARCHAR(50) NULL DEFAULT NULL,
	`agent_acct_num` VARCHAR(50) NULL DEFAULT NULL,
	`last_luanch_time` DATETIME NULL DEFAULT NULL,
	`last_bet_time` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `IDX_USER_ID` (`USER_ID`)
)
;

insert into t_stat_app_recharge_user_third_20170912(NICK_NAME,USER_ID,ACCT_NUM,recharge_coins,rmb_coins,coin_balance,is_only_third,is_inner_ip)
select u.NICK_NAME,u.USER_ID, u.ACCT_NUM,sum(tc.coins) recharge_coins,sum(tc.rmb_value) rmb_coins,0 after_value,0 is_only_third,0 is_inner_ip
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.`STATUS`=10 and u.CLIENT_ID='byapp'
where tc.crt_time<@param1
and tc.charge_method!='app'
and u.USER_ID not in (
select user_id from report.t_user_system
union all
select user_id from report.t_user_merchant
)
group by tc.charge_user_id
on duplicate key update 
recharge_coins = values(recharge_coins),
rmb_coins = values(rmb_coins),
coin_balance = values(coin_balance),
is_only_third = values(is_only_third),
is_inner_ip = values(is_inner_ip);

update t_stat_app_recharge_user_third_20170912 t
inner join report.t_trans_user_recharge_coin tc on t.USER_ID=tc.charge_user_id
and tc.charge_method='app'
and tc.crt_time<@param1
set t.is_only_third=1;

update t_stat_app_recharge_user_third_20170912 t
inner join report.t_trans_user_recharge_diamond tc on t.USER_ID=tc.charge_user_id
and tc.charge_method='app'
and tc.crt_time<@param1
set t.is_only_third=1;

-- 注：修改下面参数-日期-表名
-- call pro_t_stat_app_recharge_user_app();

-- call pro_t_stat_app_recharge_user_third();

call pro_t_stat_app_recharge_user_agent();


-- -----------------------------------------------------------------------------------
select * from (
select  
'仅官充',
t.USER_ID'用户ID',
t.NICK_NAME '用户昵称',
t.ACCT_NUM '会员号',
t.recharge_coins '充值金币',
t.rmb_coins '充值金币金额',
t.recharge_diamonds '充值钻石',
t.rmb_diamonds '充值钻石金额',
-- t.coin_balance '非冻结余额',
-- t.coin_freeze '冻结金币',
-- if(t.is_inner_ip=1,'内部ip','外部ip') 'ip归属',
t.agent_name '所属代理',
t.agent_acct_num '代理会员号',
-- t.last_bet_time '最后一次投注时间',
-- date(ifnull(t.last_luanch_time,ifnull(t.last_bet_time,'2016-06-01'))) '最后一次启动app时间'
concat(u.user_code,'_'),
u.user_code
from t_stat_app_recharge_user_app_20170912 t
inner join forum.t_user u on t.user_id=u.USER_ID
where t.is_only_app =0
) t order by t.user_code asc;


select * from (
select  
'仅第三方充',
t.USER_ID'用户ID',
t.NICK_NAME '用户昵称',
t.ACCT_NUM '会员号',
t.recharge_coins '充值金币',
t.rmb_coins '充值金币金额',
t.recharge_diamonds '充值钻石',
t.rmb_diamonds '充值钻石金额',
-- t.coin_balance '非冻结余额',
-- t.coin_freeze '冻结金币',
-- if(t.is_inner_ip=1,'内部ip','外部ip') 'ip归属',
t.agent_name '所属代理',
t.agent_acct_num '代理会员号',
-- t.last_bet_time '最后一次投注时间',
-- date(ifnull(t.last_luanch_time,u.CRT_TIME)) '最后一次启动app时间'
concat(u.user_code,'_'),
u.user_code
from t_stat_app_recharge_user_third_20170912 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
where t.is_only_third =0
) t order by t.user_code asc;

select * from (
select 
'既官充又第三方',
t1.USER_ID'用户ID',
t1.NICK_NAME '用户昵称',
t1.ACCT_NUM '会员号',
ifnull(sum(t1.recharge_coins),0)+ifnull(sum(t2.recharge_coins),0) '充值金币',
ifnull(sum(t1.rmb_coins),0)+ifnull(sum(t2.rmb_coins),0) '充值金额',
ifnull(sum(t1.recharge_diamonds),0)+ifnull(sum(t2.recharge_diamonds),0) '充值钻石',
ifnull(sum(t1.rmb_diamonds),0)+ifnull(sum(t2.rmb_diamonds),0) '充值钻石金额',
-- t1.coin_balance '非冻结余额',
-- t1.coin_freeze '冻结金币',
-- if(t1.is_inner_ip=1,'内部ip','外部ip') 'ip归属',
t1.agent_name '所属代理',
t1.agent_acct_num '代理会员号',
-- t1.last_bet_time '最后一次投注时间',
-- date(ifnull(t1.last_luanch_time,u.CRT_TIME)) '最后一次启动app时间'
concat(u.user_code,'_'),
u.user_code
from t_stat_app_recharge_user_app_20170912 t1
inner join t_stat_app_recharge_user_third_20170912 t2 on t1.USER_ID=t2.USER_ID
inner join forum.t_user u on t1.USER_ID=u.USER_ID
group by t1.USER_ID
) t order by t.user_code asc;







