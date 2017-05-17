create table t_rpt_yylb_20170406
select t.* from (
select u.NICK_NAME,u.USER_ID,u.CRT_TIME,u.USER_MOBILE,e.DEVICE_CODE,e.IP,t.crt_time pay_time 
from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
and t.charge_method='app' 
and t.rmb_value=1
where e.DEVICE_CODE in (
	select t.DEVICE_CODE from (
	select e.DEVICE_CODE,count(u.USER_ID) counts from report.t_trans_user_recharge_coin t 
	inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
	inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
	and t.charge_method='app' 
	and t.rmb_value=1
	group by e.DEVICE_CODE
	) t where t.DEVICE_CODE is not null and  counts>1
)
order by e.DEVICE_CODE)t ;



insert into t_rpt_yylb_20170406(user_id,coins)
select charge_user_id user_id,sum(tc.coins) coins 
from report.t_trans_user_recharge_coin tc 
inner join t_rpt_yylb_20170406 t on t.USER_ID=tc.charge_user_id
group by t.USER_ID
on duplicate key update 
coins = values(coins);

insert into t_rpt_yylb_20170406(user_id,after_value)
select * from (
select ai.USER_ID,ai.AFTER_VALUE 
from forum.t_acct_items ai
inner join t_rpt_yylb_20170406 t on t.USER_ID=ai.USER_ID
where ai.ACCT_TYPE=1001
and ai.ITEM_STATUS=10
order by ai.ITEM_ID desc
) t group by t.USER_ID
on duplicate key update 
after_value = values(after_value);



select 
t.NICK_NAME '用户昵称',
t.USER_ID,
t.CRT_TIME '注册时间',
t.USER_MOBILE '手机号码',
t.DEVICE_CODE '设备ID',
t.IP 'IP地址',
t.pay_time '购买一元礼包时间',
t.coins '充值金币数',
t.after_value '金币余额'
from report.t_rpt_yylb_20170406 t


 
-- 设备
select t.* from (
select u.NICK_NAME '用户昵称',u.USER_ID,u.CRT_TIME '注册时间',u.USER_MOBILE '手机号码',e.DEVICE_CODE '设备ID',e.IP 'IP地址',t.crt_time '购买一元礼包时间' 
from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
and t.charge_method='app' 
and t.rmb_value=1
where e.DEVICE_CODE in (
	select t.DEVICE_CODE from (
	select e.DEVICE_CODE,count(u.USER_ID) counts from report.t_trans_user_recharge_coin t 
	inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
	inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
	and t.charge_method='app' 
	and t.rmb_value=1
	group by e.DEVICE_CODE
	) t where t.DEVICE_CODE is not null and  counts>1
)
order by e.DEVICE_CODE)t 


-- ip
select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.CRT_TIME '注册时间',u.USER_MOBILE '手机号码',e.DEVICE_CODE '设备ID',e.IP 'IP地址',t.crt_time '购买一元礼包时间' 
from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
and t.charge_method='app' 
and t.rmb_value=1
where e.IP in (
select t.IP from (
select e.IP,count(u.USER_ID) counts from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID ='BYAPP'
inner join forum.t_user_event e on t.charge_user_id=e.USER_ID and e.EVENT_CODE='reg'
and t.charge_method='app' 
and t.rmb_value=1
group by e.IP
) t where t.IP is not null and  counts>1
)
order by e.IP;




