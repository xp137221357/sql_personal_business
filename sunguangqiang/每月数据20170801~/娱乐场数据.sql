('dq_trade','dq_prize') -- 点球大战
('lp_trade','lp_prize') -- 双轮大转盘
('TB_BINGO','TB_CANCEL','TB_TRADE') -- 欢乐骰子坊
('FQ_TRADE','FQ_PRIZE','FQ_RETURN') -- 猜猜乐
('LPD_BINGO','LPD_CANCEL','LPD_TRADE') -- 幸运24
('SIGNIN_PRIZE','SIGNIN_PRIZE','SIGNIN_LOTTO') --签到派奖
('ADMIN_OPT_H5GAME') -- 后台操作
('DWSP_BINGO','DWSP_CANCEL','DWSP_TRADE') -- 动物赛跑

set @param0 = '2017-08-01'; 
set @param2 = '8月份';

select @param2 '时间','娱乐场总',t1.counts '人数',ifnull(t1.bets,0)-ifnull(t3.cancel,0) '投注',t2.prize '返奖' from (
	select count(distinct ai.USER_ID) counts,sum(ai.CHANGE_VALUE) bets from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=1
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade','lpd_trade','dwsp_trade')
) t1
left join 
(
	select sum(ai.CHANGE_VALUE) prize from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('dp_prize','lp_prize','tb_bingo','fq_prize','lpd_bingo','dwsp_bingo')
) t2 on 1=1
left join 
(
	select sum(ai.CHANGE_VALUE) cancel from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<date_add(@param0,interval 1 month)
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('tb_cancel','lpd_cancel','fq_return','dwsp_cancel')
) t3 on 1=1;


