-- 9月7号生产后台支付汇总微信跟支付宝跟微信平台跟支付宝平台差异很大，微信差异了596.12，支付宝差了60.01



create table t_stat_diamond_balance_0908
select ai.USER_ID,ai.AFTER_VALUE from forum.t_acct_items ai 
inner join (
select ai.USER_ID,max(ai.ITEM_ID) ITEM_ID from forum.t_expert t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID
where t.IS_EXPERT=1 and t.`STATUS`=10
and ai.ACCT_TYPE=1004
and ai.ITEM_STATUS=10
and ai.PAY_TIME<'2017-08-01'
group by user_id
) t on ai.ITEM_ID=t.ITEM_ID;

truncate t_stat_diamond_balance_0908;
-- 收入钻石余额
insert into t_stat_diamond_balance_0908(user_id,AFTER_VALUE)
select ai.USER_ID,ai.AFTER_VALUE from forum.t_acct_items ai 
inner join (
select ai.USER_ID,max(ai.ITEM_ID) ITEM_ID from forum.t_expert t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID
where t.IS_EXPERT=1 and t.`STATUS`=10
and ai.ACCT_TYPE=1004
and ai.ITEM_STATUS=10
and ai.PAY_TIME<'2017-08-01'
group by user_id
) t on ai.ITEM_ID=t.ITEM_ID
on duplicate key update  
AFTER_VALUE = VALUES(AFTER_VALUE);


-- 收入钻石数
insert into t_stat_diamond_balance_0908(user_id,IN_COME)
select ai.USER_ID,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
inner join t_stat_diamond_balance_0908 t on ai.USER_ID=t.USER_ID
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>='2017-08-01'
and ai.PAY_TIME<'2017-09-01'
group by ai.USER_ID
on duplicate key update  
IN_COME = VALUES(IN_COME);


-- 购买金币-收入钻石数
insert into t_stat_diamond_balance_0908(user_id,BUY_COIN)
select ai.USER_ID,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
inner join t_stat_diamond_balance_0908 t on ai.USER_ID=t.USER_ID
and ai.ITEM_EVENT='DIAMEND_T_COIN'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
and ai.PAY_TIME>='2017-08-01'
and ai.PAY_TIME<'2017-09-01'
group by ai.USER_ID
on duplicate key update  
BUY_COIN = VALUES(BUY_COIN);


-- 提现金额
insert into t_stat_diamond_balance_0908(user_id,WITHDRAW)
select ai.USER_ID,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
inner join t_stat_diamond_balance_0908 t on ai.USER_ID=t.USER_ID 
and ai.ITEM_EVENT='WITHDRAW'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
and ai.PAY_TIME>='2017-08-01'
and ai.PAY_TIME<'2017-09-01'
group by ai.USER_ID
on duplicate key update  
WITHDRAW = VALUES(WITHDRAW);



select 
'专家收入钻石',
u.NICK_NAME '用户昵称',
u.USER_ID '用户ID',
u.ACCT_NUM '会员号',
t.AFTER_VALUE '8月前余额',
t.IN_COME '8月收入钻石数',
t.BUY_COIN '8月购买金币钻石数',
t.WITHDRAW '8月提现收入钻石数'

from t_stat_diamond_balance_0908 t
inner join forum.t_user u on t.USER_ID=u.USER_ID;





