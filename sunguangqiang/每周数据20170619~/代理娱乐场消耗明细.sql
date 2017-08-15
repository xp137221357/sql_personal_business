set @param0='2017-08-07 12:00:00';
set @param1='2017-08-14 12:00:00';
set @param2=concat(@param0,'~',@param1);
-- 娱乐场

select '娱乐场投注',
   count(distinct ai.user_id) bet_users,
	round(sum(ai.CHANGE_VALUE)) bet_coins
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
) tt on ai.user_id=tt.user_id and ai.pay_time>=tt.crt_time
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE =1001  
	and ai.ITEM_EVENT in ('dq_trade''lp_trade''FQ_TRADE','TB_TRADE','LPD_TRADE')
	and ai.ITEM_STATUS =10;
	
-- 返奖
select '娱乐场返奖',
	round(sum(ai.CHANGE_VALUE)) prize_coins
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
) tt on ai.user_id=tt.user_id and ai.pay_time>=tt.crt_time
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE =1001  
	and ai.ITEM_EVENT in ('dq_prize','lp_prize','FQ_PRIZE','FQ_RETURN','TB_BINGO','TB_CANCEL','LPD_BINGO','LPD_CANCEL')
	and ai.ITEM_STATUS =10;