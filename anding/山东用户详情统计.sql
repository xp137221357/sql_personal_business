set @param0='2016-10-01';
set @param1 = '2016-10-31 23:59:59';



##山东投注详情
select * from (
		SELECT 
		'山东投注详情',
		concat(@param0,'~',@param1) '日期',
		COUNT(distinct oi.USER_ID) '总下注人数',
		COUNT(distinct oi.BALANCE_MATCH_ID) '总下注场次',
		COUNT(oi.USER_ID) '总下注单数',	
		COUNT(distinct if(oi.COIN_BUY_MONEY>0,oi.USER_ID,null)) '金币下注人数',
		COUNT(distinct if(oi.COIN_BUY_MONEY>0,oi.BALANCE_MATCH_ID,null)) '金币下注场次',
		COUNT(if(oi.COIN_BUY_MONEY>0,oi.USER_ID,null)) '金币下注单数',
		COUNT(distinct if(oi.P_COIN_BUY_MONEY>0,oi.USER_ID,null)) '体验币下注人数',
		COUNT(distinct if(oi.P_COIN_BUY_MONEY>0,oi.BALANCE_MATCH_ID,null)) '体验币下注场次',
		COUNT(if(oi.P_COIN_BUY_MONEY>0,oi.USER_ID,null)) '体验币下注单数',
		SUM(oi.COIN_BUY_MONEY) '下注金币',
		SUM(oi.P_COIN_BUY_MONEY) '下注体验币'
		FROM report.T_USER_SHANGDONG ts
		inner join report.t_trans_user_attr tu on tu.USER_ID= ts.user_id
		inner join game.t_order_item oi on oi.USER_ID= tu.USER_CODE
		and  oi.channel_code = 'GAME'
		AND oi.item_status NOT IN ( -5, -10, 210 )
		AND oi.crt_time >= @param0
		AND oi.crt_time <= @param1
		)t1 
left join (
		SELECT
		SUM(oi.COIN_PRIZE_MONEY) '返还金币',
		SUM(oi.P_COIN_PRIZE_MONEY) '返还体验币'
		FROM report.T_USER_SHANGDONG ts
		inner join report.t_trans_user_attr tu on tu.USER_ID= ts.user_id
		inner join game.t_order_item oi on oi.USER_ID= tu.USER_CODE
		and  oi.channel_code = 'GAME'
		AND oi.item_status NOT IN ( -5, -10, 210 )
		AND oi.BALANCE_TIME >= @param0
		AND oi.BALANCE_TIME <= @param1
)t2 on 1=1
;


##山东充值金币详情
select 
'山东总充值金币详情',
concat(@param0,'~',@param1) '日期',
count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币',sum(tc.rmb_value) '充值金额' 
from 
report.T_USER_SHANGDONG ts
inner join report.t_trans_user_recharge_coin tc on ts.user_id= tc.charge_user_id
and tc.crt_time >= @param0
AND tc.crt_time <= @param1
union all
select 
'新增充值金币详情',
concat(@param0,'~',@param1) '日期',
count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币',sum(tc.rmb_value) '充值金额' 
from 
report.t_trans_user_recharge_coin tc 
inner join (
select * from report.T_USER_SHANGDONG ts
	inner join (
		select tt.charge_user_id,min(tt.crt_time) crt_time from (
		select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t group by t.charge_user_id   -- where t.charge_method ='APP'
		union all
		select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_diamond t group by t.charge_user_id
		)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 group by tt.charge_user_id
	) tt on ts.user_id = tt.charge_user_id 
) tt on tt.user_id= tc.charge_user_id
and tc.crt_time >= @param0
AND tc.crt_time <= @param1;
