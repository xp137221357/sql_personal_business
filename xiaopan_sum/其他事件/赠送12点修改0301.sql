-- 12点
INSERT into t_stat_coin_operate_noon(stat_date,reward_coins,reward_free_coins)
select 
t.stat_date,
(ifnull(t.task_reward_coins,0)+ifnull(t1.invite_reward_coins,0)+ifnull(t2.activity_present_coins,0)+ifnull(t3.activity_daily_coins,0)+
ifnull(t4.agent_reward_coins,0)+ifnull(t6.user_task_coins,0)+ ifnull(t8.coupon_coins,0) + ifnull(t9.coins,0) + ifnull(t10.coins,0)+ifnull(t11.red_packet_consume,0)) reward_coins,

(ifnull(t.task_reward_free,0)+ifnull(t1.invite_reward_free,0)+ifnull(t2.activity_present_free,0)+ifnull(t3.activity_daily_free,0)+
ifnull(t4.agent_reward_free,0)+ifnull(t6.user_task_free,0) + ifnull(t8.coupon_free_coins,0) + ifnull(t9.free_coins,0)+ ifnull(t10.free_coins,0)) reward_free_coins
from (
select  
date(date_add(curdate(),interval -12 hour)) stat_date,
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) task_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) task_reward_free    
from forum.t_acct_items ai
where ai.item_status = 10
  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour) and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
	  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
	  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
	  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'  or ai.trade_no like '%EVENT_SHARE%' )) t
left join (	
select date(date_add(curdate(),interval -12 hour)) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) invite_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) invite_reward_free 
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and ai.TRADE_NO like 'USER_GJ-%' ) t1 on t.stat_date= t1.stat_date
			  
left join (	
select date(date_add(curdate(),interval -12 hour)) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_present_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) activity_present_free  
from forum.t_acct_items ai
where  ai.item_status = 10 and ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT')
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour) 
	) t2 on t.stat_date= t2.stat_date
			
left join (
select date(date_add(curdate(),interval -12 hour)) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_daily_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) activity_daily_free 
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='FREE_COIN_TTACT') t3 on t.stat_date= t3.stat_date
			  
left join (
select date(date_add(curdate(),interval -12 hour)) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) agent_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) agent_reward_free
from forum.t_acct_items ai
where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_GROUP_PRIZE') t4 on t.stat_date= t4.stat_date		  

left join (
select date(date_add(curdate(),interval -12 hour)) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) user_task_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) user_task_free
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_TASK') t6 on t.stat_date= t6.stat_date

left join (
	select date(date_add(curdate(),interval -12 hour)) stat_date, 
	round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) coupon_coins,
	round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) coupon_free_coins 
	from forum.t_acct_items ai
	where ai.item_status = 10 
	  and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
	  and ai.USER_ID not in (select user_id from report.v_user_system)
	  and ai.ITEM_EVENT='COUPON_TO_PCOIN'
	  and ai.COMMENTS LIKE '%使用复活券%'
)t8 on t.stat_date = t8.stat_date

left join (
	select date(date_add(curdate(),interval -12 hour)) stat_date, 
	sum(b.coins) - sum(a.coins) coins,
	sum(b.free_coins) - sum(a.free_coins) free_coins
	 from (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		from forum.t_acct_items ai 
		where ai.ITEM_EVENT = 'USER_PRESENT' 
		AND ai.ADD_TIME >= date_add(curdate(),interval -12 hour)
		and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
		and ai.ITEM_STATUS in (10, -10)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) a , (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		 from forum.t_acct_items ai 
		where ai.ITEM_EVENT = 'PRESENT_FROM_USER' 
		AND ai.ADD_TIME >= date_add(curdate(),interval -12 hour)
		and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001, 1015)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) b
)t9 on t.stat_date = t9.stat_date

left join (
	select 
	date(date_add(curdate(),interval -12 hour)) stat_date, 
	sum(b.coins) - sum(a.coins) coins,
	sum(b.free_coins) - sum(a.free_coins) free_coins
	 from (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		from forum.t_acct_items ai 
		where ai.ITEM_EVENT = 'CP_TRADE' 
		AND ai.ADD_TIME >= date_add(curdate(),interval -12 hour)
		and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001, 1015)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) a , (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		 from forum.t_acct_items ai 
		where ai.ITEM_EVENT in ('CP_PRIZE' , 'CP_TRADE-REFUND')
		AND ai.ADD_TIME >= date_add(curdate(),interval -12 hour)
		and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001, 1015)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) b
)t10 on t.stat_date = t10.stat_date
left join (
	select 
	date(date_add(curdate(),interval -12 hour)) stat_date, 
	ai.ITEM_EVENT,round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE))) red_packet_consume
	from FORUM.t_acct_items ai 
	left join report.v_user_system v on v.USER_ID=ai.USER_ID 
	where  ai.ADD_TIME>=date_add(curdate(),interval -12 hour)
	and ai.ADD_TIME<date_add(curdate(),interval 12 hour)
	and ai.ACCT_TYPE in (1001) 
	and ai.ITEM_STATUS in (10,-10)
	and v.USER_ID is null
	and ai.ITEM_EVENT in ('PACKET_RECIVE','PCKET_EXPIRE','ROOM_PACKET_TRADE')
		
)t11 on t.stat_date = t11.stat_date
on duplicate key update 
reward_coins = values(reward_coins),
reward_free_coins = values(reward_free_coins);


-- 后台操作
INSERT into t_stat_coin_operate(stat_date,opt_coins_consume,opt_free_consume)
select 
date_add(curdate(),interval -12 hour) stat_date,
sum(if(ai.ACCT_TYPE=1001,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0)) opt_coins_consume,
sum(if(ai.ACCT_TYPE=1015,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0)) opt_free_consume
from forum.t_acct_items ai
where  ai.ITEM_STATUS = 10 
AND ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%'
and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)  
and ai.ADD_TIME <date_add(curdate(),interval 12 hour) 
and ai.USER_ID not in (select user_id from report.v_user_system)
on duplicate key update 
opt_coins_consume = values(opt_coins_consume),
opt_free_consume = values(opt_free_consume);

-- 所有事件(新事件，未统计到)
INSERT into t_stat_coin_operate(stat_date,all_event_coins_consume,all_event_free_consume)
select 
date_add(curdate(),interval -12 hour) stat_date,
round(sum(if(ai.ACCT_TYPE=1001,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))) all_event_coins_consume,
round(sum(if(ai.ACCT_TYPE=1015,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))) all_event_free_consume
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10) 
and ai.ADD_TIME >= date_add(curdate(),interval -12 hour)
and ai.ADD_TIME <date_add(curdate(),interval 12 hour)
and ai.USER_ID not in (select user_id from report.v_user_system)
on duplicate key update 
all_event_coins_consume = values(all_event_coins_consume),
all_event_free_consume = values(all_event_free_consume);


-- 12点的赛事投注消耗(每隔两小时计算一次)

INSERT into t_stat_coin_operate_noon(stat_date,football_coins_consume,football_free_consume) 
SELECT date_add(curdate(),interval -12 hour) stat_date,
       t.return_coins-t.bet_coins football_coins_consume,
       t.return_free_currency-t.bet_free_currency football_free_consume
 from (
		SELECT 
		Ifnull(Round(Sum(w.coin_buy_money)), 0) bet_coins,
		Ifnull(Round(Sum(w.p_coin_buy_money)), 0) bet_free_currency,
		Ifnull(Sum(w.coin_prize_money), 0)+ Ifnull(Sum(w.coin_return_money), 0) return_coins,
		Ifnull(Sum(w.p_coin_prize_money), 0)+ Ifnull(Sum(w.p_coin_return_money), 0) return_free_currency
		FROM   game.t_order_item w
		INNER JOIN forum.t_user tu
		        ON w.user_id = tu.user_code 
				  and tu.USER_ID not in(select user_id from report.v_user_system)
		INNER JOIN fb_main.t_match m
		        ON w.balance_match_id = m.match_id
		           AND m.match_time >= date_add(curdate(),interval -12 hour)
		           AND m.match_time < date_add(curdate(),interval 12 hour)
		           AND w.channel_code = 'GAME'
      ) t
on duplicate key update 
football_coins_consume = values(football_coins_consume),
football_free_consume = values(football_free_consume);




