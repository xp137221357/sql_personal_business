-- 生产后台8月12号支付数据汇总跟整体运营数据中微信差异128

-- 整体运营与支付宝对账

set @param0='2017-09-01';

set @param1='2017-09-02';


select u.REALNAME,u.NICK_NAME,u.GROUP_TYPE,ai.ITEM_SRC,ai.CHANGE_VALUE from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID = u.USER_ID -- and u.CLIENT_ID='byapp' -- and u.GROUP_TYPE=0
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'
and ai.COST_VALUE=1.04
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1;



select * from t_third_pay_log t where t.TRADE_NO='20170812000186513'; -- 商户订单号

select * from t_third_pay_log t where t.OUT_TRADE_NO='4010212001201708125858096564'; -- 支付订单号

select * from forum.t_acct_items ai 
where 
ai.PAY_TIME>='2017-08-01'
and ai.TRADE_NO='4010212001201708125858096564'; -- 支付订单号


select sum(t.TOTAL_FEE) from t_third_pay_log t 
where t.CRT_TIME>=@param0
and t.CRT_TIME<@param1
and t.`STATUS`=10
and t.TRADE_TYPE=0
and t.IS_SENDBOX=0
and t.PAY_TYPE=3;




select t1.*,t2.*,t1.TOTAL_FEE-t2.CHANGE_VALUE from (
select t.OUT_TRADE_NO,t.TOTAL_FEE from t_third_pay_log t 
where t.CRT_TIME>=@param0
and t.CRT_TIME<@param1
and t.`STATUS`=10
and t.TRADE_TYPE=0
and t.IS_SENDBOX=0
and t.PAY_TYPE=3
) t1
left join (
select ai.TRADE_NO,ai.CHANGE_VALUE*100 CHANGE_VALUE from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_EVENT ='buy_diamend'
and ai.ACCT_TYPE=1003
and ai.ITEM_SRC=3
and ai.ITEM_STATUS=10
) t2 on t1.OUT_TRADE_NO=t2.TRADE_NO;


select * from t_third_pay_log t where t.OUT_TRADE_NO='4004292001201709019404276357';

select * from forum.t_acct_items ai where ai.TRADE_NO='20170901063963429';




