set @param0='2017-06-19 12:00:00';
set @param1='2017-06-20 12:00:00';


-- 新用户充值
select count(distinct u.USER_ID) new_recharge_counts,sum(tc.coins) new_recharge_coins 
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.crt_time>=@param0 and u.crt_time<=@param1
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
and tc.crt_time>=@param0
and tc.crt_time<=@param1;

-- 老用户充值
select count(distinct u.USER_ID) old_recharge_counts,sum(tc.coins) old_recharge_coins from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.crt_time<@param0
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
and tc.crt_time>=@param0
and tc.crt_time<=@param1;



-- 新用户提现
select count(distinct u.USER_ID) new_withdraw_counts,sum(tc.coins) new_withdraw_coins from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.user_id=u.USER_ID and u.crt_time>=@param0 and u.crt_time<=@param1
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
and tc.crt_time>=@param0
and tc.crt_time<=@param1;

-- 老用户提现
select count(distinct u.USER_ID) old_withdraw_counts,sum(tc.coins) old_withdraw_coins from report.t_trans_user_withdraw tc
inner join forum.t_user u on tc.user_id=u.USER_ID and u.crt_time<@param0
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
and tc.crt_time>=@param0
and tc.crt_time<=@param1;

