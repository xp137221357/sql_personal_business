-- 6.26 12 ~ 7.24 12 
-- 有效代理
-- 盘内反水
-- 明细

set @param0='2017-07-24 12:00:00';
set @param1='2017-08-28 12:00:00';
set @param2=concat(@param0,'~',@param1);

select  @param2 '时间','代理任务投注任务赠送',tt.agent '代理',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID =u.USER_ID
inner join (
	 SELECT 
       u.user_id,r1.CRT_TIME,tg.agent
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  -- and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	inner join (select tg.user_id from report.t_partner_group_detail tg where tg.stat_time in ('2017-07') group by user_id) tr on tr.user_id=u2.USER_ID
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time,tg.agent from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  -- and tg.is_valid=0
	inner join (select tg.user_id from report.t_partner_group_detail tg where tg.stat_time in ('2017-07') group by user_id) tr on tr.user_id=u.USER_ID
	group by u.USER_ID
) tt on ai.user_id=tt.user_id
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME>=tt.CRT_TIME
and ai.PAY_TIME<@param1
and ai.CHANGE_VALUE>=2500
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
group by tt.agent;
