set @param0 = '2017-06-06'; 
set @param1 = '2017-06-07 23:59:59'; 


-- 新增充值钻石

select 
select count(distinct td.charge_user_id) '新增充值金额',sum(td.diamonds) '新增充值金额' 
from t_trans_user_recharge_diamond td
inner join t_stat_first_recharge_dmd tf on td.charge_user_id=tf.USER_ID 
and tf.crt_time>=@param0 and tf.crt_time<=@param1
and td.crt_time>=@param0 and td.crt_time<=@param1;


-- 全部充值钻石

select count(distinct td.charge_user_id) '充值金额',sum(td.diamonds) '充值金额' 
from t_trans_user_recharge_diamond td
where td.crt_time>=@param0 and td.crt_time<=@param1;


-- 充值赠送

select count(distinct ai.USER_ID) '充值人数',sum(ai.CHANGE_VALUE) '充值赠送钻石' 
from forum.t_acct_items ai 
where ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_EVENT ='DIAMEND_PRESENT'
and ai.ITEM_STATUS=10 
and ai.add_time>=@param0 and ai.add_time<=@param1;


-- 赠送券

-- 7天签到，一元礼包 

select count(distinct ai.USER_ID) '人数',sum(ai.CHANGE_VALUE*t.CHILD_CODE_VALUE) '金额' 
from forum.t_acct_items ai 
inner join forum.t_code t on convert(t.CHILD_CODE,signed)=ai.ACCT_TYPE 
and t.CODE ='COUPONS' 
and t.CHILD_CODE_VALUE!=-1 
and ai.ITEM_STATUS=10 
and (ai.TRADE_NO like 'SIGN_%' OR ai.TRADE_NO like 'ACT_YYLB%')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1;


-- 新增购买服务
select count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
inner join report.t_stat_first_buy_srv ts on ai.USER_ID=ts.USER_ID and ts.CRT_TIME>=@param0 and ts.CRT_TIME<=@param1
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_service','buy_recom','buy_vip');

-- 购买服务
select count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_service','buy_recom','buy_vip');

-- 专家推荐
select count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_recom');

-- 数字产品
select count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_service');

-- vip购买
select count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1003,1004)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_vip');


