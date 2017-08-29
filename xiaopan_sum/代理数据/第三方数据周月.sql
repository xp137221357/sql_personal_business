select date_format(curdate(),'%x-%v') stat_date,
2 stat_type,
count(distinct u.USER_ID) new_recharge_counts,
ifnull(sum(tc.coins),0) new_recharge_coins 
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
and u.crt_time>=date_add(date_add(curdate(),interval -7 day),interval 12 hour) and u.crt_time<date_add(curdate(),interval 12 hour)
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
and tc.crt_time>=date_add(date_add(curdate(),interval -7 day),interval 12 hour)
and tc.crt_time<date_add(curdate(),interval 12 hour)


-- 周
INSERT into t_stat_partner_coin_operate(stat_date,stat_type,old_recharge_counts,old_recharge_coins)
select 
date_format(date_add(curdate(),-1 day),'%x-%v') stat_date,
2 stat_type,
sum(t.new_recharge_counts),
sum(t.new_recharge_coins) 
from report.t_stat_partner_coin_operate t 
where t.stat_date>=date_add(curdate(),interval -7 day)
and t.stat_date<date_add(curdate(),interval -1 day)
on duplicate key update 
new_recharge_counts = values(new_recharge_counts),
new_recharge_coins = values(new_recharge_coins);

-- 月
INSERT into t_stat_partner_coin_operate(stat_date,new_recharge_counts,new_recharge_coins)
select 
date_format(date_add(curdate(),-1 day),'%x-%v') stat_date,
3 stat_type,
sum(t.new_recharge_counts),
sum(t.new_recharge_coins) 
from report.t_stat_partner_coin_operate t 
where t.stat_date>=date_add(curdate(),interval -1 month)
and t.stat_date<date_add(curdate(),interval -1 day)
on duplicate key update 
new_recharge_counts = values(new_recharge_counts),
new_recharge_coins = values(new_recharge_coins);



INSERT into t_stat_partner_coin_operate(stat_date,old_recharge_counts,old_recharge_coins)
select date(date_add(curdate(),interval -12 hour)) stat_date,
count(distinct u.USER_ID) old_recharge_counts,
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











