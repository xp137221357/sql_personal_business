set @bt:='2016-08-20';
set @et:='2016-08-31';
select sum(urc.rmb_value), count(distinct urc.charge_user_id) from report.t_trans_user_recharge_coin urc 
 where urc.crt_time >= @bt and urc.crt_time < @et;


# 投注人数 & 投注金币
select count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) from game.t_order_item oi 
WHERE oi.USER_ID in (
select distinct u.user_code from 
forum.t_user u 
inner join report.t_trans_user_recharge_coin urc 
on u.USER_ID = urc.charge_user_id
 where urc.crt_time >= @bt and urc.crt_time < @et
) and oi.ITEM_STATUS not in (-5, -10, 210)
 and oi.CHANNEL_CODE = 'GAME'
and oi.PAY_TIME >= @bt and oi.PAY_TIME < @et;




# 充值钻石人数与金额
select sum(urc.rmb_value), count(distinct urc.charge_user_id) from report.t_trans_user_recharge_diamond urc 
where urc.crt_time >= @bt and urc.crt_time < @et
and urc.charge_user_id in (
	select distinct u.USER_ID from 
	forum.t_user u 
	inner join report.t_trans_user_recharge_coin urc 
	on u.USER_ID = urc.charge_user_id
	 where urc.crt_time >= @bt and urc.crt_time < @et
);




set @bt:='2016-08-20';
set @et:='2016-08-31';
select count(distinct di.USER_CODE) from t_device_statistic di
where di.USER_CODE in (
	select distinct u.user_code from 
	forum.t_user u 
	inner join report.t_trans_user_recharge_coin urc 
	on u.USER_ID = urc.charge_user_id
	 where urc.crt_time >= @bt and urc.crt_time < @et

)
and di.STAT_TYPE = 1
and di.ACT_DATE >= '2016-08-31'
and di.ACT_DATE < '2016-09-11'
;


select sum(urc.rmb_value), count(distinct urc.charge_user_id) from report.t_trans_user_recharge_coin urc where
 urc.crt_time >= '2016-08-31' and urc.crt_time < '2016-09-11'
 and urc.charge_user_id in (
 select distinct u.USER_ID from 
	forum.t_user u 
	inner join report.t_trans_user_recharge_coin urc 
	on u.USER_ID = urc.charge_user_id
	 where urc.crt_time >= @bt and urc.crt_time < @et
 );
 
 
 
 

# 投注人数 & 投注金币
select count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) from game.t_order_item oi 
where oi.ITEM_STATUS not in (-5, -10, 210)
and oi.USER_ID in (
select distinct u.user_code from 
	forum.t_user u 
	inner join report.t_trans_user_recharge_coin urc 
	on u.USER_ID = urc.charge_user_id
	 where urc.crt_time >= @bt and urc.crt_time < @et
)
and oi.CHANNEL_CODE = 'GAME'
and oi.PAY_TIME >= '2016-08-31' and oi.PAY_TIME < '2016-09-11';



select sum(urc.rmb_value), count(distinct urc.charge_user_id) from report.t_trans_user_recharge_diamond urc where
 urc.crt_time >= '2016-08-31' and urc.crt_time < '2016-09-11'
 and urc.charge_user_id in (
 select distinct u.USER_ID from 
	forum.t_user u 
	inner join report.t_trans_user_recharge_coin urc 
	on u.USER_ID = urc.charge_user_id
	 where urc.crt_time >= @bt and urc.crt_time < @et
 );
 