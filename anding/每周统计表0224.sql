set @param0='2017-01-01';
set @param1='2017-02-26 23:59:59';

-- 比赛场次
select * from (
select 
date_format(tm.MATCH_TIME,'%Y-%m-%d') stat_time,
count(if(tm.league_level=1,1,null)) '一级联赛场次',
count(if(tm.league_level=2,1,null)) '二级联赛场次',
count(if(tm.league_level not in (1,2),1,null)) '其他联赛场次'
from game.t_match_ref tm  
where tm.MATCH_TIME>=@param0 and tm.MATCH_TIME<=@param1
group by stat_time
) t1
left join (
-- 赠送金币
select 
t1.stat_date stat_time,
(ifnull(t.task_reward_coins,0)+ifnull(t1.invite_reward_coins,0)+ifnull(t2.activity_present_coins,0)+ifnull(t3.activity_daily_coins,0)+
ifnull(t4.agent_reward_coins,0)+ifnull(t6.user_task_coins,0)) reward_coins
from (
select  
date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date,
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) task_reward_coins   
from forum.t_acct_items ai
where ai.item_status = 10
  and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
	  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
	  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
	  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'  or ai.trade_no like '%EVENT_SHARE%' )
	  group by stat_date
	  ) t
left join (	
select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) invite_reward_coins
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and ai.TRADE_NO like 'USER_GJ-%' 
  group by stat_date
  ) t1 on t.stat_date= t1.stat_date
			  
left join (	
select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_present_coins  
from forum.t_acct_items ai
where  ai.item_status = 10 and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1 
	group by stat_date
) t2 on t.stat_date= t2.stat_date
			
left join (
select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) activity_daily_coins
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='FREE_COIN_TTACT'
  group by stat_date
) t3 on t.stat_date= t3.stat_date
			  
left join (
select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date, 
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) agent_reward_coins
from forum.t_acct_items ai
where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_GROUP_PRIZE'
  group by stat_date
) t4 on t.stat_date= t4.stat_date
    
left join (
select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_date,  
round(sum(if(ai.ACCT_TYPE=1001,ai.change_value,0))) user_task_coins
from forum.t_acct_items ai
where ai.item_status = 10 
  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_TASK'
  group by stat_date  
) t6 on t.stat_date= t6.stat_date
) t2 on t1.stat_time=t2.stat_time

-- 第三方收金币
left join (
select 
date_format(tw.crt_time,'%Y-%m-%d') stat_time,
sum(tw.coins) in_coins from report.t_trans_user_withdraw tw 
where tw.crt_time>=@param0 and tw.crt_time<=@param1
group by stat_time
)t3 on t1.stat_time=t3.stat_time

left join (

-- 第三方出金币
select 
date_format(tc.crt_time,'%Y-%m-%d') stat_time,
sum(tc.coins) out_coins from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0 and tc.crt_time<=@param1
and tc.charge_method!='app'
group by stat_time
) t4 on t1.stat_time=t4.stat_time

-- 总存金币
left join (
select 
date_add(t.stat_date,interval -1 day) stat_time,
t.fore_asserts_normal_coins 
from report.t_stat_coin_operate t where 
t.stat_date>=date_add(@param0,interval 1 day)
and t.stat_date<=date_add(@param1,interval 1 day)
group by t.stat_date
) t5 on t1.stat_time=t5.stat_time


-- 投注返奖
select 
t.*,concat(round(prize_coins*100/bet_coins,2),'%') return_rate from (
	select date_format(ai.PAY_TIME,'%Y-%m-%d') stat_time,
	round(sum(if(ai.ITEM_EVENT='trade_coin',ai.CHANGE_VALUE,0))) bet_coins,
	round(sum(if(ai.ITEM_EVENT='prize_coin',ai.CHANGE_VALUE,0))) prize_coins
	from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE in (1001) 
	and ai.ITEM_EVENT in ('trade_coin','prize_coin')
	and ai.TRADE_NO not in (
	select cast(ms.MSG_ID as char) from game.t_msg ms where ms.ADD_TIME >=date_add(@param0,interval -1 hour)
	)
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.ITEM_STATUS in (10,-10)
	group by stat_time
) t group by t.stat_time
) t3 on t1.stat_time=t3.stat_time

-- 第三方存金币
select 
concat(@param0,'~',@param1) stat_time,
sum(ai.AFTER_VALUE) from (
select t.NICK_NAME,t.USER_ID,max(ai.ADD_TIME) add_time from report.t_user_merchant t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and ai.ADD_TIME<=@param1
group by t.USER_ID
) t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and t.add_time=ai.ADD_TIME
;



