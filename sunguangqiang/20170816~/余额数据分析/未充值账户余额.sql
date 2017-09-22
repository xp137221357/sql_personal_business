
set @param1='2017-09-11 00:00:00';

truncate t_no_recharge_user_balance20170911;

CREATE TABLE `t_no_recharge_user_balance20170911` (
	`ID` BIGINT(19) NOT NULL AUTO_INCREMENT,
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`COIN_BALANCE` DECIMAL(14,2) NULL DEFAULT NULL,
	`COIN_FREEZE` DECIMAL(14,2) NULL DEFAULT NULL,
	`IS_INNER_IP` INT(11) NULL DEFAULT NULL,
	`LAST_BET_TIME` DATETIME NULL DEFAULT NULL,
	`LAST_LUANCH_TIME` DATE NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `USER_ID` (`USER_ID`),
	INDEX `LAST_LUANCH_TIME` (`LAST_LUANCH_TIME`),
	INDEX `LAST_BET_TIME` (`LAST_BET_TIME`),
	INDEX `COIN_BALANCE` (`COIN_BALANCE`)
)
;

insert into t_no_recharge_user_balance20170911(user_id)
select u.USER_ID from forum.t_user u 
left join (
	select charge_user_id user_id from (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc where tc.CRT_TIME<@param1
	union all
	select tc.charge_user_id from report.t_trans_user_recharge_diamond tc where tc.CRT_TIME<@param1
	union all
	
	select user_id from report.t_user_system
	union all
	select user_id from report.t_user_merchant	
	) t group by user_id
)t on u.USER_ID=t.user_id
where u.`STATUS`=10 and u.CLIENT_ID='byapp'
and u.CRT_TIME<@param1
and t.user_id is null;

call pro_t_no_recharge_user_balance();


update t_no_recharge_user_balance20170911 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
set t.COIN_BALANCE=v.coin_balance,
t.COIN_FREEZE=v.coin_freeze;

-- update t_no_recharge_user_balance20170911 t set t.IS_INNER_IP=null

insert into t_no_recharge_user_balance20170911(user_id,IS_INNER_IP)
select t.USER_ID,sum(if(tt.inner_ip is null,0,1)) 
from report.t_no_recharge_user_balance20170911 t
inner join forum.t_user_event e on e.USER_ID=t.USER_ID
left join report.t_stat_inner_ip_address tt on e.IP like concat(tt.inner_ip,'%')
where t.COIN_BALANCE>1000
group by t.USER_ID
on duplicate key update  
IS_INNER_IP = VALUES(IS_INNER_IP);


select 
t.ID,
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额',
t.LAST_BET_TIME '最后一次投注时间',
date(ifnull(t.LAST_LUANCH_TIME,u.CRT_TIME)) '最后一次启动app时间',
if(t.IS_INNER_IP>0,'内部IP',if(t.IS_INNER_IP=0,'外部IP','余额小于1000')) 'IP归属'
from report.t_no_recharge_user_balance20170911 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
and t.ID<100000;

select 
t.ID,
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额',
t.LAST_BET_TIME '最后一次投注时间',
date(ifnull(t.LAST_LUANCH_TIME,u.CRT_TIME)) '最后一次启动app时间',
if(t.IS_INNER_IP>0,'内部IP',if(t.IS_INNER_IP=0,'外部IP','余额小于1000')) 'IP归属'
from report.t_no_recharge_user_balance20170911 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
and t.ID>=1000000
and t.ID<2000000;

select 
t.ID,
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额',
t.LAST_BET_TIME '最后一次投注时间',
date(ifnull(t.LAST_LUANCH_TIME,u.CRT_TIME)) '最后一次启动app时间',
if(t.IS_INNER_IP>0,'内部IP',if(t.IS_INNER_IP=0,'外部IP','余额小于1000')) 'IP归属'
from report.t_no_recharge_user_balance20170911 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
and t.ID>=2000000
and t.ID<3000000;

select 
t.ID,
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额',
t.LAST_BET_TIME '最后一次投注时间',
date(ifnull(t.LAST_LUANCH_TIME,u.CRT_TIME)) '最后一次启动app时间',
if(t.IS_INNER_IP>0,'内部IP',if(t.IS_INNER_IP=0,'外部IP','余额小于1000')) 'IP归属'
from report.t_no_recharge_user_balance20170911 t
inner join forum.t_user u on t.USER_ID=u.USER_ID
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
and t.ID>=3000000
and t.ID<4000000;










