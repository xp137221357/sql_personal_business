set @beginTime='2017-03-31'; 
set @endTime='2017-03-31'; 
set @acctType='1001'; 

-- 赠送明细
-- 日常任务赠送,邀请赠送,活动赠送,代理返点,投注任务赠送,后台操作,复活券转化
-- 日期,总赠送,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币
-- stat_date,consume,task_reward_counts,task_reward_coins,invite_reward_counts,invite_reward_coins,activity_present_counts,activity_present_coins,agent_reward_counts,agent_reward_coins,user_task_counts,user_task_coins,admin_opt_counts,admin_opt_coins,revive_coupon_counts,revive_coupon_coins
select 
t.stat_date,
t1.task_reward_counts,
t1.task_reward_coins ,
t2.invite_reward_counts,
t2.invite_reward_coins ,
t3.activity_present_counts,
t3.activity_present_coins ,
t4.agent_reward_counts,
t4.agent_reward_coins ,
t5.user_task_counts,
t5.user_task_coins,
t6.admin_opt_counts,
t6.admin_opt_coins,
t7.revive_coupon_counts,
t7.revive_coupon_coins,
ifnull(t1.task_reward_coins,0)+ifnull(t2.invite_reward_coins,0)+ifnull(t3.activity_present_coins,0)+ifnull(t4.agent_reward_coins,0)+
ifnull(t5.user_task_coins,0)+ifnull(t6.admin_opt_coins,0)+ifnull(t7.revive_coupon_coins,0) consume 
from (
select 
date_format(t.stat_date,'%Y-%m-%d') stat_date
from report.t_stat_reference_time t 
where t.stat_date>=@beginTime
and t.stat_date<=@endTime
) t
left join (
select  
date_format(ai.pay_time,'%Y-%m-%d') stat_date,
	ifnull(count(distinct ai.user_id),0) task_reward_counts,
	ifnull(round(sum(ai.change_value)),0) task_reward_coins
from forum.t_acct_items ai
where ai.item_status in (10,-10)
  and ai.ACCT_TYPE in (@acctType)
  and ai.PAY_TIME >= @beginTime and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
	  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
	  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
	  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'  or ai.trade_no like '%EVENT_SHARE%' )) t1 on t.stat_date= t1.stat_date	
left join (	
select date_format(ai.pay_time,'%Y-%m-%d') stat_date, 
	ifnull(count(distinct ai.user_id),0) invite_reward_counts,
	ifnull(round(sum(ai.change_value)),0) invite_reward_coins
from forum.t_acct_items ai
where ai.item_status in (10,-10)
  and ai.ACCT_TYPE in (@acctType)
  and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and ai.TRADE_NO like 'USER_GJ-%' ) t2 on t.stat_date= t2.stat_date		  
left join (	
select date_format(ai.pay_time,'%Y-%m-%d') stat_date, 
	ifnull(count(distinct ai.user_id),0) activity_present_counts,
	ifnull(round(sum(ai.change_value)),0) activity_present_coins
from forum.t_acct_items ai
where  ai.item_status in (10,-10) 
   and ai.ACCT_TYPE in (@acctType)
   and ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT')
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.CHANGE_TYPE=0 and ai.PAY_TIME >= @beginTime  
	and ai.PAY_TIME <= concat(@endTime,' 23:59:59')  
	) t3 on t.stat_date= t3.stat_date				  
left join (
select date_format(ai.pay_time,'%Y-%m-%d') stat_date, 
	ifnull(count(distinct ai.user_id),0) agent_reward_counts,
	ifnull(round(sum(ai.change_value)),0) agent_reward_coins
from forum.t_acct_items ai
where ai.item_status in (10,-10) 
  and ai.ACCT_TYPE in (@acctType)
  and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_GROUP_PRIZE') t4 on t.stat_date= t4.stat_date	  
left join (
select date_format(ai.pay_time,'%Y-%m-%d') stat_date, 
	ifnull(count(distinct ai.user_id),0) user_task_counts,
	ifnull(round(sum(ai.change_value)),0) user_task_coins
from forum.t_acct_items ai
where ai.item_status in (10,-10)
  and ai.ACCT_TYPE in (@acctType)
  and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ITEM_EVENT='USER_TASK') t5 on t.stat_date= t5.stat_date
left join (
select 
	date_format(ai.pay_time,'%Y-%m-%d') stat_date,
	ifnull(count(distinct ai.user_id),0) admin_opt_counts,
   ifnull(round(sum(ai.change_value)),0) admin_opt_coins
	from forum.t_acct_items ai
where  ai.item_status in (10,-10)
   and ai.ACCT_TYPE in (@acctType)
	AND ai.ITEM_EVENT='ADMIN_USER_OPT' 
	and ai.COMMENTS not like '%网银充值%'
	and ai.COMMENTS not like '%异常%'
	and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
	and ai.USER_ID not in (select user_id from report.v_user_system)
) t6 on t.stat_date= t6.stat_date
left join (
	select date_format(ai.pay_time,'%Y-%m-%d') stat_date, 
	ifnull(count(distinct ai.user_id),0) revive_coupon_counts,
   ifnull(round(sum(ai.change_value)),0) revive_coupon_coins
	from forum.t_acct_items ai
	where ai.item_status in (10,-10)
     and ai.ACCT_TYPE in (@acctType)
	  and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
	  and ai.USER_ID not in (select user_id from report.v_user_system)
	  and ai.ITEM_EVENT='COUPON_TO_PCOIN'
	  and ai.COMMENTS LIKE '%使用复活券%'
)t7 on t.stat_date = t7.stat_date;


-- 后台操作

-- 操作明细
-- 周榜,内测,代理,活动,钻石兑换,异常充值
-- 日期,总金额,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币,人数,金币
-- stat_date,opt_weekly_counts,opt_weekly_coins,opt_community_counts,opt_community_coins,opt_inner_counts,opt_inner_coins,opt_agent_counts,opt_agent_coins,opt_act_counts,opt_act_coins,opt_redeem_counts,opt_redeem_coins,opt_recharge_counts,opt_recharge_coins

select 
	t.stat_date,
	t1.opt_weekly_counts,
	t1.opt_weekly_coins,
	t1.opt_community_counts,
	t1.opt_community_coins,
	t1.opt_inner_counts,
	t1.opt_inner_coins,
	t1.opt_agent_counts,
	t1.opt_agent_coins,
	t1.opt_act_counts,
	t1.opt_act_coins,
	t1.opt_redeem_counts,
	t1.opt_redeem_coins,
	t1.opt_recharge_counts,
	t1.opt_recharge_coins,
	ifnull(t1.opt_weekly_coins,0)+ifnull(t1.opt_community_coins,0)+ifnull(t1.opt_inner_coins,0)+ifnull(t1.opt_agent_coins,0)+
ifnull(t1.opt_act_coins,0)+ifnull(t1.opt_redeem_coins,0)+ifnull(t1.opt_recharge_coins,0) consume 
	
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from report.t_stat_reference_time t 
	where t.stat_date>=@beginTime
	and t.stat_date<=@endTime
) t
left join (
select 
   date_format(ai.pay_time,'%Y-%m-%d') stat_date,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_WEEKLY',ai.user_id,null)),0) opt_weekly_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_WEEKLY',ai.change_value,0))),0) opt_weekly_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_COMMUNITY',ai.user_id,null)),0) opt_community_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_COMMUNITY',ai.change_value,0))),0) opt_community_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_INNER',ai.user_id,null)),0) opt_inner_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_INNER',ai.change_value,0))),0) opt_inner_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_AGENT',ai.user_id,null)),0) opt_agent_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_AGENT',ai.change_value,0))),0) opt_agent_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_ACT',ai.user_id,null)),0) opt_act_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_ACT',ai.change_value,0))),0) opt_act_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_DIAMOND_REDEEM',ai.user_id,null)),0) opt_redeem_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_DIAMOND_REDEEM',ai.change_value,0))),0) opt_redeem_coins,
   ifnull(count(distinct if(ai.ITEM_EVENT='ADMIN_OPT_RECHARGE',ai.user_id,null)),0) opt_recharge_counts,
   ifnull(round(sum(if(ai.ITEM_EVENT='ADMIN_OPT_RECHARGE',ai.change_value,0))),0) opt_recharge_coins
	from forum.t_acct_items ai
where  ai.item_status in (10,-10)
   and ai.ACCT_TYPE in (@acctType)
	AND ai.ITEM_EVENT='ADMIN_OPT_%' 
	and ai.PAY_TIME >= @beginTime  and ai.PAY_TIME <= concat(@endTime,' 23:59:59')
	and ai.USER_ID not in (select user_id from report.v_user_system)
	group by stat_date
) t1 on t.stat_date=t1.stat_date;
	