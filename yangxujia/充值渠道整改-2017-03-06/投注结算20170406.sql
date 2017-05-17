set @beginTime='2017-03-01 00:00:00';
set @endTime = '2017-03-31 23:59:59';

select '总投注',date_format(oi.CRT_TIME,'%Y-%m') stat_time,
	round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
	round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins
   from game.t_order_item oi
where  
	oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
	and oi.PAY_TIME >= @beginTime 
	and oi.PAY_TIME <= @endTime
group by stat_time


union all


select '总返奖',date_format(oi.BALANCE_TIME,'%Y-%m') stat_time,
	round(ifnull(sum(oi.COIN_PRIZE_MONEY),0)+ifnull(sum(oi.COIN_RETURN_MONEY),0)) return_coins,
	round(ifnull(sum(oi.P_COIN_PRIZE_MONEY),0)+ifnull(sum(oi.P_COIN_RETURN_MONEY),0)) return_p_coins
from game.t_order_item oi 
where  oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
	and oi.BALANCE_STATUS=20
	and oi.BALANCE_TIME >= @beginTime 
	and oi.BALANCE_TIME <= @endTime
group by stat_time
;



select '代理投注',date_format(oi.CRT_TIME,'%Y-%m') stat_time,
	round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
	round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins
   from game.t_order_item oi
where  
	oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
	and oi.PAY_TIME >= @beginTime 
	and oi.PAY_TIME <= @endTime
	and oi.user_id in (
		SELECT 
		       u.user_code
		FROM   forum.t_user u
		       INNER JOIN game.t_group_ref r1
		               ON u.user_code = r1.user_id
		       INNER JOIN game.t_group_ref r2
		               ON r1.root_id = r2.ref_id
		       INNER JOIN report.t_user_general_agent tu 
		       			ON r2.user_id = tu.user_code
		WHERE  u.client_id = 'BYAPP'
		union 
		select user_id from  report.t_user_general_agent
	)
group by stat_time


union all


select '代理返奖',date_format(oi.BALANCE_TIME,'%Y-%m') stat_time,
	round(ifnull(sum(oi.COIN_PRIZE_MONEY),0)+ifnull(sum(oi.COIN_RETURN_MONEY),0)) return_coins,
	round(ifnull(sum(oi.P_COIN_PRIZE_MONEY),0)+ifnull(sum(oi.P_COIN_RETURN_MONEY),0)) return_p_coins
from game.t_order_item oi 
where  oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
	and oi.BALANCE_STATUS=20
	and oi.BALANCE_TIME >= @beginTime 
	and oi.BALANCE_TIME <= @endTime
	and oi.user_id in (
		SELECT 
		       u.user_code
		FROM   forum.t_user u
		       INNER JOIN game.t_group_ref r1
		               ON u.user_code = r1.user_id
		       INNER JOIN game.t_group_ref r2
		               ON r1.root_id = r2.ref_id
		       INNER JOIN report.t_user_general_agent tu 
		       			ON r2.user_id = tu.user_code
		WHERE  u.client_id = 'BYAPP'
		union 
		select user_id from  report.t_user_general_agent
	)
group by stat_time
;
