set @param0 = '2017-07-01'; 
set @param2 = '7月份';

select @param2 '时间','娱乐场总',t1.counts '人数',ifnull(t1.bets,0)-ifnull(t3.cancel,0) '投注',t2.prize '返奖' from (
	select count(distinct ai.USER_ID) counts,sum(ai.CHANGE_VALUE) bets from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=1
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade','lpd_trade')
) t1
left join 
(
	select sum(ai.CHANGE_VALUE) prize from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('dp_prize','lp_prize','tb_bingo','fq_prize','lpd_bingo')
) t2 on 1=1
left join 
(
	select sum(ai.CHANGE_VALUE) cancel from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('tb_cancel','lpd_cancel','fq_return')
) t3 on 1=1;