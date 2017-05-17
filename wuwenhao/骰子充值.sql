set @param0='2017-03-28';
select * from report.t_trans_user_recharge_coin tc 
where tc.charge_method='app'
and tc.crt_time>=@param0;


select * from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT='TB_TRADE';







