set @param0='2017-06-05 12:00:00';
set @param1='2017-06-12 11:59:59';


-- select * from t_partner_group t where t.is_valid=0;

select '汇总',count(distinct o.USER_ID) bet_users,round(sum(o.COIN_BUY_MONEY)) bet_coins,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins
from game.t_order_item o
inner join (

	SELECT 
	       u.user_code,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	 union all

	select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0
	
) t1 on o.USER_ID=t1.user_code and o.crt_time>t1.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
 and o.PAY_TIME>=@param0
 and o.PAY_TIME<=@param1
 and o.COIN_BUY_MONEY>0;


-- 新增首次
select '新增',count(distinct o.USER_ID) bet_users,round(sum(o.COIN_BUY_MONEY)) bet_coins ,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins
from game.t_order_item o
inner join report.t_stat_user_first_bet_time tb 
	on o.USER_ID=tb.USER_CODE and tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1
inner join (

	SELECT 
	       u.user_code,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	 union all

	select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0
	
) t1 on o.USER_ID=t1.user_code and o.crt_time>t1.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.COIN_BUY_MONEY>0;



-- 老用户
select '老用户',count(distinct o.USER_ID) bet_users,round(sum(o.COIN_BUY_MONEY)) bet_coins ,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins
from game.t_order_item o
left join report.t_stat_user_first_bet_time tb 
	on o.USER_ID=tb.USER_CODE and tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1
inner join (

	SELECT 
	       u.user_code,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	 union all

	select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0
	
) t1 on o.USER_ID=t1.user_code and o.crt_time>t1.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.COIN_BUY_MONEY>0
and tb.USER_ID is null;

