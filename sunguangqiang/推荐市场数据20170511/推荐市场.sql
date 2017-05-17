

set @param0='2017-04-01';
set @param1='2017-05-01';
set @param2='四月份';

--  激活
select @param2,'激活',sum(t.FIRST_DNUM) '激活','-' from report.t_rpt_overview t 
where t.PERIOD_TYPE=1 
and t.PERIOD_NAME>=@param0
and t.PERIOD_NAME<@param1

union all

-- 注册
select  @param2,'注册',count(1) '注册','-' from forum.t_user t 
where t.CRT_TIME>=@param0
and t.CRT_TIME<@param1
and t.CLIENT_ID='BYAPP'

union all

-- 新增用户充值钻石

select @param2,'新增用户充值钻石',count(distinct u.user_id) '新增充值人数',sum(t.rmb_value) '新增充值金额' 
from report.t_trans_user_recharge_diamond t
inner join forum.t_user u on t.charge_user_id=u.USER_ID 
and u.CRT_TIME>=@param0
and u.CRT_TIME<@param1
and u.CLIENT_ID='BYAPP'
and t.CRT_TIME>=@param0
and t.CRT_TIME<@param1

union all

-- 老用户充值钻石
select @param2,'老用户充值钻石',count(distinct u.user_id) '老用户充值钻石人数',sum(t.rmb_value) '老用户充值钻石金额' 
from report.t_trans_user_recharge_diamond t
inner join forum.t_user u on t.charge_user_id=u.USER_ID 
and u.CRT_TIME<@param0
and u.CLIENT_ID='BYAPP'
and t.CRT_TIME>=@param0
and t.CRT_TIME<@param1

union all

-- 总充值钻石
select @param2,'总充值钻石',count(distinct t.charge_user_id) '总充值钻石人数',sum(t.rmb_value) '总充值钻石金额' 
from report.t_trans_user_recharge_diamond t
where t.CRT_TIME>=@param0
and t.CRT_TIME<@param1

union all

-- 赠送钻石(登录送+充值钻石)

select @param2,'赠送钻石',count(distinct user_id) '赠送人数', sum(ai.CHANGE_VALUE) '赠送金额' from forum.t_acct_items ai 
where ai.item_status = 10
and ((ai.TRADE_NO like 'SIGN_%' and ai.ITEM_EVENT='GET_FREE_COIN') or ai.ITEM_EVENT='DIAMEND_PRESENT')
and ai.ACCT_TYPE=1003
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<@param1

union all

-- 新增购买

select @param2,'新增购买服务',count(distinct ai.USER_ID) '新增购买服务人数',sum(ai.CHANGE_VALUE) '新增购买服务买金额'
from forum.t_user u
inner join forum.t_acct_items ai on u.USER_ID=ai.USER_ID
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM','BUY_VIP')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and u.CRT_TIME>=@param0
and u.CRT_TIME<@param1
and u.CLIENT_ID='BYAPP'

union all


-- 总购买服务
select @param2,'总购买服务',count(distinct ai.USER_ID) '总购买服务人数',sum(ai.CHANGE_VALUE) '总购买服务金额'
from forum.t_acct_items ai 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM','BUY_VIP')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1 

union all

-- 专家推荐
select @param2,'购买推荐',count(distinct ai.USER_ID) '购买专家推荐人数',sum(ai.CHANGE_VALUE) '购买专家推荐金额'
from forum.t_acct_items ai 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_RECOM')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1

union all

-- 数据产品
select @param2,'购买数据产品',count(distinct ai.USER_ID) '购买数据产品人数',sum(ai.CHANGE_VALUE) '购买数据产品金额'
from forum.t_acct_items ai 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_SERVICE')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1 

union all

-- vip购买
select @param2,'购买vip',count(distinct ai.USER_ID) '购买vip人数',sum(ai.CHANGE_VALUE) '购买vip金额'
from forum.t_acct_items ai 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_VIP')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1 ;



