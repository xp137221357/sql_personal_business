-- 新用户充值
INSERT into t_stat_partner_coin_operate(stat_date,new_recharge_counts,new_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct u.USER_ID) new_recharge_counts,
sum(tc.coins) new_recharge_coins 
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
and u.crt_time>=date(date_add(curdate(),interval -12 hour)) and u.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and tc.crt_time>=tt.CRT_TIME
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
new_recharge_counts = values(new_recharge_counts),
new_recharge_coins = values(new_recharge_coins);

-- 老用户充值
INSERT into t_stat_partner_coin_operate(stat_date,old_recharge_counts,old_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct u.USER_ID) old_recharge_counts,
sum(tc.coins) old_recharge_coins 
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.crt_time<date(date_add(curdate(),interval -12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and tc.crt_time>=tt.CRT_TIME
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
old_recharge_counts = values(old_recharge_counts),
old_recharge_coins = values(old_recharge_coins);



-- 新用户提现
INSERT into t_stat_partner_coin_operate(stat_date,new_withdraw_counts,new_withdraw_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct u.USER_ID) new_withdraw_counts,
sum(tc.coins) new_withdraw_coins 
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
and u.crt_time>=date(date_add(curdate(),interval -12 hour)) and u.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and tc.crt_time>=tt.CRT_TIME
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
new_withdraw_counts = values(new_withdraw_counts),
new_withdraw_coins = values(new_withdraw_coins);

-- 老用户提现
INSERT into t_stat_partner_coin_operate(stat_date,old_withdraw_counts,old_withdraw_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct u.USER_ID) old_withdraw_counts,
sum(tc.coins) old_withdraw_coins 
from report.t_trans_user_withdraw tc
inner join forum.t_user u on tc.user_id=u.USER_ID and u.crt_time<date(date_add(curdate(),interval -12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and tc.crt_time>=tt.CRT_TIME
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
old_withdraw_counts = values(old_withdraw_counts),
old_withdraw_coins = values(old_withdraw_coins);



-- 新用户投注
INSERT into t_stat_partner_coin_operate(stat_date,new_bet_counts,new_bet_coins,new_prize_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct o.USER_ID) new_bet_counts,
round(sum(o.COIN_BUY_MONEY)) new_bet_coins ,
round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) new_prize_coins
from game.t_order_item o
inner join forum.t_user u on o.user_id=u.USER_CODE 
and u.crt_time>=date(date_add(curdate(),interval -12 hour)) and u.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.ITEM_STATUS not in (-5,-10,210)
and o.BALANCE_TIME>=date(date_add(curdate(),interval -12 hour))
and o.BALANCE_TIME<date(date_add(curdate(),interval 12 hour))
and o.COIN_BUY_MONEY>0
on duplicate key update 
new_bet_counts = values(new_bet_counts),
new_bet_coins = values(new_bet_coins),
new_prize_coins = values(new_prize_coins);



-- 老用户投注
INSERT into t_stat_partner_coin_operate(stat_date,old_bet_counts,old_bet_coins,old_prize_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct o.USER_ID) old_bet_counts,
round(sum(o.COIN_BUY_MONEY)) old_bet_coins ,
round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) old_prize_coins
from game.t_order_item o
inner join forum.t_user u on o.user_id=u.USER_CODE and u.crt_time<date(date_add(curdate(),interval -12 hour)) 
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.ITEM_STATUS not in (-5,-10,210)
and o.BALANCE_TIME>=date(date_add(curdate(),interval -12 hour))
and o.BALANCE_TIME<date(date_add(curdate(),interval 12 hour))
and o.COIN_BUY_MONEY>0
on duplicate key update 
old_bet_counts = values(old_bet_counts),
old_bet_coins = values(old_bet_coins),
old_prize_coins = values(old_prize_coins);



-- 新增用户数
INSERT into t_stat_partner_coin_operate(stat_date,new_user_counts)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(1) new_user_counts from (

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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
	
) t1 where t1.CRT_TIME>=date(date_add(curdate(),interval -12 hour)) and t1.CRT_TIME<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
new_user_counts = values(new_user_counts);

-- 新增充值用户

INSERT into t_stat_partner_coin_operate(stat_date,first_recharge_counts,first_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct tc.charge_user_id) first_recharge_counts,
sum(tc.coins) first_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id 
and t.crt_time>=date(date_add(curdate(),interval -12 hour)) and t.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
and tc.crt_time>=tt.crt_time
on duplicate key update 
first_recharge_counts = values(first_recharge_counts),
first_recharge_coins = values(first_recharge_coins);

-- 新增官方充值用户
INSERT into t_stat_partner_coin_operate(stat_date,first_app_recharge_counts,first_app_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct tc.charge_user_id) first_app_recharge_counts,
ifnull(sum(tc.coins),0) first_app_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	where tc.charge_method='app'
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id 
and t.crt_time>=date(date_add(curdate(),interval -12 hour)) and t.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
and tc.crt_time>=tt.crt_time
and tc.charge_method='app'
on duplicate key update 
first_app_recharge_counts = values(first_app_recharge_counts),
first_app_recharge_coins = values(first_app_recharge_coins);


-- 新增非官方充值用户
INSERT into t_stat_partner_coin_operate(stat_date,first_third_recharge_counts,first_third_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct tc.charge_user_id) first_third_recharge_counts,
sum(tc.coins) first_third_recharge_coins
from report.t_trans_user_recharge_coin tc
inner join (
	select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
	where tc.charge_method!='app'
	group by tc.charge_user_id
) t on tc.charge_user_id=t.charge_user_id 
and t.crt_time>=date(date_add(curdate(),interval -12 hour)) and t.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on tc.charge_user_id=tt.user_id
and tc.crt_time>=date(date_add(curdate(),interval -12 hour))
and tc.crt_time<date(date_add(curdate(),interval 12 hour))
and tc.crt_time>=tt.crt_time
and tc.charge_method!='app'
on duplicate key update 
first_third_recharge_counts = values(first_third_recharge_counts),
first_third_recharge_coins = values(first_third_recharge_coins);



-- 新增投注
INSERT into t_stat_partner_coin_operate(stat_date,first_bet_counts,first_bet_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct o.USER_ID) first_bet_counts,
round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
from game.t_order_item o
inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
and tb.crt_time>=date(date_add(curdate(),interval -12 hour)) and tb.crt_time<date(date_add(curdate(),interval 12 hour))
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on tb.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.BALANCE_TIME>=date(date_add(curdate(),interval -12 hour))
and o.BALANCE_TIME<date(date_add(curdate(),interval 12 hour))
and o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
on duplicate key update 
first_bet_counts = values(first_bet_counts),
first_bet_coins = values(first_bet_coins);


-- 盘内返水(投注任务奖励)
INSERT into t_stat_partner_coin_operate(stat_date,handicap_inner_rebate)
select date(date_add(curdate(),interval -12 hour)) stat_date,
ifnull(sum(ai.CHANGE_VALUE),0) handicap_inner_rebate
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
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on ai.USER_ID=tt.user_id
where ai.PAY_TIME>=date(date_add(curdate(),interval -12 hour)) 
and ai.PAY_TIME>=tt.CRT_TIME
and ai.PAY_TIME< date(date_add(curdate(),interval 12 hour))
and ai.ITEM_STATUS=10
and ai.CHANGE_VALUE>=2500
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
on duplicate key update 
handicap_inner_rebate = values(handicap_inner_rebate);


-- 有效流水 
-- 盘外返水
INSERT into t_stat_partner_coin_operate(stat_date,effective_flow_coins,handicap_outside_rebate)
select date(date_add(curdate(),interval -12 hour)) stat_date,
round(sum(t.EFFECTIVE_MONEY),2) effective_flow_coins,
round(sum(t.EFFECTIVE_MONEY)*0.02,2) handicap_outside_rebate
from game.t_partner_order_info t 
inner join (
    select u.user_code,tg.crt_time from report.t_partner_group tg 
	 inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on t.USER_ID=tt.user_code 
and t.`TYPE`=2
where date(t.EXPECT)>=date(date_add(curdate(),interval -12 hour)) 
and date(t.EXPECT)<date(date_add(curdate(),interval 12 hour))
on duplicate key update 
effective_flow_coins = values(effective_flow_coins),
handicap_outside_rebate = values(handicap_outside_rebate);

