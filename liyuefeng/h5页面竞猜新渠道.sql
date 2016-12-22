set @param0='2016-11-14';
set @param1='2016-11-20 23:59:59';

-- 日期
select PERIOD_NAME stat_time from t_rpt_h5_url_pv_uv t 
where t.PERIOD_TYPE=1 and t.PERIOD_NAME>=@param0 and t.PERIOD_NAME<=@param1 
group by stat_time;

-- 注册
select date_format(t.crt_time,'%Y-%m-%d') stat_time,count(te.user_id) from forum.t_user_event te 
where te.EVENT_CODE='REG' and te.CHANNEL_NO like '%mbyzq%' 
and te.CRT_TIME>=@param0 and te.CRT_TIME<=@param1
group by stat_time
;
-- pu,uv以及下载
select th.PERIOD_NAME stat_time,sum(pv) pv,sum(uv) uv 
from t_rpt_h5_url_pv_uv th 
inner join report.t_channel_promote tp on th.CHANNEL_NAME=tp.CHANNEL_NAME and tp.CHANNEL_NO like '%mbyzq%'
where th.PERIOD_TYPE=1 and th.PERIOD_NAME>=@param0 and th.PERIOD_NAME<=@param1
group by stat_time
;
-- new_recharge

-- 新增充值
select date_format(t.crt_time,'%Y-%m-%d') stat_time,count(distinct t.charge_user_id) new_recharge_count,sum(t.rmb_value) new_recharge_value from (
select tt1.* from (
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
	) tt1 on tt1.charge_user_id= tt0.charge_user_id
) t group by stat_time;

-- 充值
select date_format(t.CRT_TIME,'%Y-%m-%d') stat_time,count(distinct t.charge_user_id) recharge_count,sum(rmb_value) recharge_value from (
select tc.crt_time,tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tu.USER_ID = tc.charge_user_id and tu.CHANNEL_NO ---
and tc.crt_time>=@param0 and tc.crt_time<=@param1
union all 
select td.crt_time,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td  
inner join report.t_trans_user_attr tu on tu.USER_ID = td.charge_user_id and tu.CHANNEL_NO ---
and td.crt_time>=@param0 and td.crt_time<=@param1
) t  group by stat_time
;

-- 新增投注
select date_format(oi.CRT_TIME,'%Y-%m-%d') stat_time,count(distinct oi.USER_ID) new_bet_count,round(sum(oi.COIN_BUY_MONEY)) new_bet_coins from report.t_stat_first_recharge_bet tf
inner join report.t_trans_user_attr tu on tf.USER_ID = tu.user_id and tu.CHANNEL_NO like '%mbyzq%'
inner join game.t_order_item oi on tf.USER_CODE = oi.USER_ID
and oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
group by stat_time;


-- 投注

select date_format(oi.CRT_TIME,'%Y-%m-%d') stat_time,count(distinct oi.USER_ID) bet_count,round(sum(oi.COIN_BUY_MONEY)) bet_coins  from game.t_order_item oi 
inner join report.t_trans_user_attr tu on oi.USER_ID = tu.user_code and tu.CHANNEL_NO ---
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
group by stat_time;
-- 娱乐场 消耗

select date_format(tpk.create_time,'%Y-%m-%d') stat_time,sum(earn - pay) pk_consume  from h5game.t_pk_act tpk
inner join report.t_trans_user_attr tu on tpk.USER_ID = tu.user_code and tu.CHANNEL_NO ---
where create_time >= '2016-11-18' and status = 1
group by stat_time;

select  date_format(tra.create_time,'%Y-%m-%d'),sum(earn - pay) pk_roulette from h5game.t_roulette_act tra
inner join report.t_trans_user_attr tu on tra.USER_ID = tu.user_code and tu.CHANNEL_NO ---
where create_time >='2016-11-18'  and status = 1
group by stat_time;

-- 体验币
-- select sum(pcoin_earn - pcoin_pay) from h5game.t_pk_act where create_time >= '2016-11-18' and status = 1;
-- select sum(pcoin_earn - pcoin_pay) from h5game.t_roulette_act where create_time >='2016-11-18'  and status = 1;












