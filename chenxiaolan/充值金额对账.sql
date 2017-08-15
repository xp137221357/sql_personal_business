-- 生产后台8月12号支付数据汇总跟整体运营数据中微信差异128

-- 整体运营与支付宝对账

set @param0='2017-08-12';

set @param1='2017-08-13';


select u.REALNAME,u.NICK_NAME,u.GROUP_TYPE,ai.ITEM_SRC,ai.CHANGE_VALUE from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID = u.USER_ID and u.CLIENT_ID='byapp' and u.GROUP_TYPE!=0
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1;



select * from t_third_pay_log t where t.TRADE_NO='20170812000186513'; -- 商户订单号

select * from t_third_pay_log t where t.OUT_TRADE_NO='4010212001201708125858096564'; -- 支付订单号

select * from forum.t_acct_items ai 
where 
ai.PAY_TIME>='2017-08-01'
and ai.TRADE_NO='4010212001201708125858096564'; -- 支付订单号