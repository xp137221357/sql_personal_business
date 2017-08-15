-- 
-- 直接导数据
set @param0 = '2017-06-01'; 
set @param2 = '6月份';

select @param2,'',sum(ai.CHANGE_VALUE) from forum.t_acct_items ai
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'