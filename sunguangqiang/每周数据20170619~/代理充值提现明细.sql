set @param0='2017-09-04 12:00:00';
set @param1='2017-09-11 12:00:00';
set @param2=concat(@param0,'~',@param1);

select @param2,'充值汇总',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币'
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
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
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on u.user_id=tt.user_id 
and tc.crt_time>=tt.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1


union all




select @param2,'充值新增投注',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币'
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
left join(select user_code from report.t_stat_first_recharge_bet tb where tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1 group by user_code) tb 
	on u.USER_CODE=tb.USER_CODE 
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
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on u.user_id=tt.user_id and tc.crt_time>=tt.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1
and tb.USER_CODE is not null


union all


select @param2,'充值老投注用户',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币'
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
left join(select user_code from report.t_stat_first_recharge_bet tb where tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1 group by user_code) tb 
	on u.USER_CODE=tb.USER_CODE 
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
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on u.user_id=tt.user_id and tc.crt_time>=tt.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1
and tb.USER_CODE is null


union all


select @param2,'兑出汇总',count(distinct tc.user_id) '兑出人数',sum(tc.coins) '兑出金币'
from report.t_trans_user_withdraw tc
inner join forum.t_user u on tc.user_id=u.USER_ID
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
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on u.user_id=tt.user_id and tc.crt_time>=tt.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1

union all

select @param2,'兑出新增投注',count(distinct tc.user_id) '兑出人数',sum(tc.coins) '兑出金币'
from report.t_trans_user_withdraw tc
inner join forum.t_user u on tc.user_id=u.USER_ID
left join(select user_code from report.t_stat_first_recharge_bet tb where tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1 group by user_code) tb 
	on u.USER_CODE=tb.USER_CODE 
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
	
) t1 on u.USER_CODE=t1.user_code  and tc.crt_time>=t1.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1
and tb.USER_CODE is not null


union all


select @param2,'兑出老投注用户',count(distinct tc.user_id) '兑出人数',sum(tc.coins) '兑出金币'
from report.t_trans_user_withdraw tc
inner join forum.t_user u on tc.user_id=u.USER_ID
left join(select user_code from report.t_stat_first_recharge_bet tb where tb.CRT_TIME>=@param0 and tb.CRT_TIME<=@param1 group by user_code) tb 
	on u.USER_CODE=tb.USER_CODE 
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
	inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
) tt on u.user_id=tt.user_id and tc.crt_time>=tt.crt_time
where tc.CRT_TIME>=@param0
and tc.CRT_TIME<=@param1
and tb.USER_CODE is null;
