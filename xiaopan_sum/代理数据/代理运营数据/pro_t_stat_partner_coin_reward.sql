CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_stat_partner_coin_reward`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

set @day_time = '2017-07-01';

label1: WHILE @day_time <='2017-08-10' Do

INSERT into t_stat_partner_coin_reward(stat_date,acct_num,reward_coins)
select  date_add(@day_time,interval -1 day),tt.agent_acct_num,sum(ai.CHANGE_VALUE) bet_reward_coins
from forum.t_acct_items ai 
inner join (
	 SELECT 
       u.user_id,r1.CRT_TIME,tg.agent_acct_num
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time,tg.agent_acct_num from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM 
) tt on ai.user_id=tt.user_id
where ai.PAY_TIME>=date_add(@day_time,interval -12 hour)
and ai.PAY_TIME<date_add(@day_time,interval 12 hour)
and ai.PAY_TIME>=tt.CRT_TIME
and ai.CHANGE_VALUE>=2500
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
group by tt.agent_acct_num
on duplicate key update 
reward_coins = values(reward_coins);


SET @day_time = date_add(@day_time,interval 1 day);

end while label1;

END