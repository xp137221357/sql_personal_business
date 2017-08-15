



set @param0='2017-07-10 12:00:00';
set @param1='2017-07-17 12:00:00';
-- 娱乐场


select
concat(@param0,'~',@param1) '时间', 
t1.bet_users '总投注人数',
round(ifnull(t1.bet_coins,0)-ifnull(t3.return_coins,0)) '总投注金币',
round(t2.prize_coins) '总返奖金币'
from (
	select 
	   count(distinct ai.user_id) bet_users,
		round(sum(ai.CHANGE_VALUE)) bet_coins
	from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE =1001  
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','FQ_TRADE','TB_TRADE','LPD_TRADE')
	and ai.ITEM_STATUS =10
) t1
left join (
	select 
		round(sum(ai.CHANGE_VALUE)) prize_coins
	from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE =1001  
	and ai.ITEM_EVENT in ('dq_prize','lp_prize','FQ_PRIZE','TB_BINGO','LPD_BINGO')
	and ai.ITEM_STATUS =10
) t2 on 1=1
left join (
	select 
	round(sum(ai.CHANGE_VALUE)) return_coins
	from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ACCT_TYPE =1001  
	and ai.ITEM_EVENT in ('FQ_RETURN','TB_CANCEL','LPD_CANCEL')
	and ai.ITEM_STATUS =10
) t3 on 1=1;