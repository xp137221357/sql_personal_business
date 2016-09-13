set @beginTime='2016-08-15 00:00:00';
set @endTime = '2016-08-21 23:59:59';


INSERT into t_stat_coin_operate(stat_date,reward_coins,reward_free_coins)
select 
t.stat_date,
(ifnull(t.task_reward_coins,0)+ifnull(t1.invite_reward_coins,0)+ifnull(t2.activity_present_coins,0)+ifnull(t3.activity_daily_coins,0)+
ifnull(t4.agent_reward_coins,0)+ifnull(t5.system_reward_coins,0)) reward_coins,
(ifnull(t.task_reward_free,0)+ifnull(t1.invite_reward_free,0)+ifnull(t2.activity_present_free,0)+ifnull(t3.activity_daily_free,0)+
ifnull(t4.agent_reward_free,0)) reward_free_coins
from (
select  
date_add(curdate(),interval -1 day) stat_date,
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) task_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) task_reward_free    
from forum.t_acct_items ai
where ai.item_status = 10
  and ai.ADD_TIME >= date_add(curdate(),interval -1 day) and ai.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
  and ai.USER_ID not in (select user_id from forum.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
	  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
	  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
	  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000') ) t
					  
left join (					  
select date_add(curdate(),interval -1 day) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) invite_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) invite_reward_free 
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= date_add(curdate(),interval -1 day)  and ai.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
  and ai.USER_ID not in (select user_id from forum.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and ai.TRADE_NO like 'USER_GJ-%' ) t1 on t.stat_date= t1.stat_date
			  
left join (					

select date_add(curdate(),interval -1 day) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_present_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) activity_present_free  
from forum.t_acct_items ai
where  ai.item_status = 10 and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
	and ai.USER_ID not in (select user_id from forum.v_user_system)
	and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= date_add(curdate(),interval -1 day)  and ai.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59') 
	) t2 on t.stat_date= t2.stat_date
			
left join (
			
select date_add(curdate(),interval -1 day) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_daily_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) activity_daily_free 
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= date_add(curdate(),interval -1 day)  and ai.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
  and ai.USER_ID not in (select user_id from forum.v_user_system)
  and ai.ITEM_EVENT='FREE_COIN_TTACT') t3 on t.stat_date= t3.stat_date
			  
left join (
			 
select date_add(curdate(),interval -1 day) stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) agent_reward_coins,
round(sum(if(ai.ACCT_TYPE=1015,ai.change_value,0))) agent_reward_free
from forum.t_acct_items ai
where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
  and ai.ADD_TIME >= date_add(curdate(),interval -1 day)  and ai.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
  and ai.USER_ID not in (select user_id from forum.v_user_system)
  and ai.ITEM_EVENT='USER_GROUP_PRIZE') t4 on t.stat_date= t4.stat_date
			  
left join (
			
select date_add(curdate(),interval -1 day) stat_date, 
round(t1.MONEY + t3.OFFER_GRATUITY) system_reward_coins from (
SELECT ifnull(Sum(p.money),0) MONEY
        FROM   forum.t_user_present p
        inner join forum.v_user_system vs on p.USER_ID = vs.USER_ID
               AND p.`status` = 10
               AND p.crt_time >= date_add(curdate(),interval -1 day)
               AND p.crt_time <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
			   )t1, (
select ifnull(sum(gift_sum),0) OFFER_GRATUITY from (

select oa.USER_ID receiver, o.OFFER_GRATUITY - o.OFFER_PRIZE gift_sum, o.USER_ID sender 
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join forum.v_user_system vus on o.USER_ID = vus.USER_CODE and oa.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME >= date_add(curdate(),interval -1 day) and oa.OFFER_APPLY_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')

union all 

select o.USER_ID, o.OFFER_PRIZE - o.OFFER_GRATUITY gift_sum, oa.USER_ID from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join forum.v_user_system vus on oa.USER_ID = vus.USER_CODE and o.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME >= date_add(curdate(),interval -1 day) and oa.OFFER_APPLY_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59')
) t2
) t3 
)t5 on t.stat_date= t5.stat_date
on duplicate key update 
reward_coins = values(reward_coins),
reward_free_coins = values(reward_free_coins)
;


			  

	