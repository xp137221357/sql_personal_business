set @param0='2016-11-14';
set @param1='2016-11-22 23:59:59';

-- 日期
select 
t1.stat_time,t2.reg_count,t3.pv,t3.uv,
t4.new_recharge_count,t4.new_recharge_value,
t5.recharge_count,t5.recharge_value,
t6.new_bet_count,t6.new_bet_coins,
t7.bet_count,t7.bet_coins,
t8.pk_consume,t9.pk_roulette
from (
	select 1 stat_time,'2016-11-14' a,'2016-11-15' b from dual 
)t1
left join (
	select 1 stat_time,count(tu.user_id) reg_count from forum.t_user_event tu 
	where tu.EVENT_CODE='REG' and tu.CHANNEL_NO like '%mbyzq%' 
	and tu.CRT_TIME>=@param0 and tu.CRT_TIME<=@param1
)t2 on t1.stat_time=t2.stat_time
left join (
	select 1 stat_time,sum(pv) pv,sum(uv) uv 
	from t_rpt_h5_url_pv_uv th 
	inner join report.t_channel_promote tu on th.CHANNEL_NAME=tu.CHANNEL_NAME and tu.CHANNEL_NO like '%mbyzq%'
	where th.PERIOD_TYPE=1 and th.PERIOD_NAME>=@param0 and th.PERIOD_NAME<=@param1
)t3 on t1.stat_time=t3.stat_time
left join (
	select 1 stat_time,count(distinct t.charge_user_id) new_recharge_count,sum(t.rmb_value) new_recharge_value from (
	select tt0.crt_time stat_time,tt1.* from (
	select tt.charge_user_id,min(tt.crt_time) crt_time from (
	select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t 
	inner join report.t_trans_user_attr tu on tu.USER_ID = t.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
	group by t.charge_user_id  
	union all
	select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_diamond t 
	inner join report.t_trans_user_attr tu on tu.USER_ID = t.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
	group by t.charge_user_id
	)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 group by tt.charge_user_id
	) tt0  
	inner join (
	select tc.crt_time,tc.charge_user_id,tc.rmb_value from report.t_trans_user_recharge_coin tc  
		inner join report.t_trans_user_attr tu on tu.USER_ID = tc.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
		and tc.crt_time>=@param0 and tc.crt_time<=@param1
		union all
	select  td.crt_time,td.charge_user_id,td.rmb_value from report.t_trans_user_recharge_diamond td 
		inner join report.t_trans_user_attr tu on tu.USER_ID = td.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
		and td.crt_time>=@param0 and td.crt_time<=@param1
		) tt1 on tt1.charge_user_id= tt0.charge_user_id and date(tt0.crt_time)=date(tt1.crt_time)
	) t 
)t4 on t1.stat_time=t4.stat_time
left join (
	select 1 stat_time,count(distinct t.charge_user_id) recharge_count,sum(rmb_value) recharge_value 
	from (
	select tc.crt_time,tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tu.USER_ID = tc.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
	and tc.crt_time>=@param0 and tc.crt_time<=@param1
	union all 
	select td.crt_time,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td  
	inner join report.t_trans_user_attr tu on tu.USER_ID = td.charge_user_id and tu.CHANNEL_NO like '%mbyzq%'
	and td.crt_time>=@param0 and td.crt_time<=@param1
	) t  
)t5 on t1.stat_time=t5.stat_time
left join (
	select 1 stat_time,count(distinct oi.USER_ID) new_bet_count,round(sum(oi.COIN_BUY_MONEY)) new_bet_coins 
	from report.t_stat_first_recharge_bet tf
	inner join report.t_trans_user_attr tu on tf.USER_ID = tu.user_id and tu.CHANNEL_NO like '%mbyzq%'
	inner join game.t_order_item oi on tf.USER_CODE = oi.USER_ID
	and oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
	and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
	and oi.COIN_BUY_MONEY>0
)t6 on t1.stat_time=t6.stat_time
left join ( 
	select 1 stat_time,count(distinct oi.USER_ID) bet_count,round(sum(oi.COIN_BUY_MONEY)) bet_coins  
	from game.t_order_item oi 
	inner join report.t_trans_user_attr tu on oi.USER_ID = tu.user_code and tu.CHANNEL_NO like '%mbyzq%'
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
	and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
	and oi.COIN_BUY_MONEY>0
)t7 on t1.stat_time=t7.stat_time
left join (
	select 1 stat_time,sum(earn - pay) pk_consume  
	from h5game.t_pk_act tpk
	inner join report.t_trans_user_attr tu on tpk.USER_ID = tu.user_code and tu.CHANNEL_NO like '%mbyzq%'
	where `status` = 1 and create_time >=@param0 and create_time <= @param1
)t8 on t1.stat_time=t8.stat_time
left join (
	select 1 stat_time,sum(earn - pay) pk_roulette 
	from h5game.t_roulette_act tra
	inner join report.t_trans_user_attr tu on tra.USER_ID = tu.user_code and tu.CHANNEL_NO like '%mbyzq%'
	where `status` = 1 and create_time >=@param0 and create_time <= @param1
) t9 on t1.stat_time=t9.stat_time
order by t1.stat_time asc

-- 体验币
-- select sum(pcoin_earn - pcoin_pay) from h5game.t_pk_act where create_time >= '2016-11-18' and status = 1;
-- select sum(pcoin_earn - pcoin_pay) from h5game.t_roulette_act where create_time >='2016-11-18'  and status = 1;










