
set @param0='2017-06-19 12:00:00';
set @param1='2017-06-20 12:00:00';

-- 第三方运营数据

-- 新增用户数
select date(date_add(curdate(),interval -12 hour)) stat_date,count(1) new_user_counts from (

	SELECT 
       u.user_code,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_code,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0
	
) t1 where t1.CRT_TIME>=@param0 and t1.CRT_TIME<=@param1;


-- 新增充值用户


select count(distinct tc.charge_user_id) first_recharge_counts,sum(tc.coins) first_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id and t.crt_time>=@param0 and t.crt_time<=@param1
inner join (
   SELECT 
       u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.crt_time>=tt.crt_time;

-- 新增官方充值用户
select count(distinct tc.charge_user_id) first_recharge_counts,sum(tc.coins) first_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	where tc.charge_method='app'
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id and t.crt_time>=@param0 and t.crt_time<=@param1
inner join (
   SELECT 
       u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.crt_time>=tt.crt_time
and tc.charge_method='app';


-- 新增非官方充值用户
select count(distinct tc.charge_user_id) first_recharge_counts,sum(tc.coins) first_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	where tc.charge_method!='app'
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id and t.crt_time>=@param0 and t.crt_time<=@param1
inner join (
   SELECT 
       u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.crt_time>=tt.crt_time
and tc.charge_method!='app';



-- 新增投注
select count(distinct o.USER_ID) first_bet_counts,
round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
from game.t_order_item o
inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID and tb.crt_time>=@param0 and tb.crt_time<=@param1
inner join (
   SELECT 
       u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0

) tt on tb.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<=@param1
and o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0;


-- 盘内返水(投注任务奖励)

select sum(ai.CHANGE_VALUE) handicap_inner_rebate
from forum.t_acct_items ai 
inner join (
   SELECT 
       u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0

) tt on ai.USER_ID=tt.user_id
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME>=tt.CRT_TIME
and ai.PAY_TIME<=@param1
and ai.ITEM_STATUS=10
and ai.CHANGE_VALUE>=2500
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';


-- 有效流水 
-- 盘外返水

select sum(t.EFFECTIVE_MONEY) effective_flow_coins,
sum(t.EFFECTIVE_MONEY)*0.02 handicap_outside_rebate
from game.t_partner_order_info t 
inner join (
    select u.user_code,tg.crt_time from report.t_partner_group tg 
	 inner join forum.t_user u on tg.agent_acct_num=u.acct_num  where tg.is_valid=0
) tt on t.USER_ID=tt.user_code 
and t.`TYPE`=2
where date(t.EXPECT)>=@param0 
and date(t.EXPECT)<=@param1;



