select * from forum.t_user u where u.ACCT_NUM in (
'13468818',
'13469055',
'13469064',
'13468995',
'11133239',
'12657149',
'12793811',
'13180578',
'13234098',
'11010347',
'12598085',
'12796487',
'13154904',
'12991293',
'13165038');


-- 总金币动向
select ai.ITEM_EVENT,ai.CHANGE_TYPE,round(sum(ai.CHANGE_VALUE)) from forum.t_acct_items ai 
where ai.USER_ID='347' and ai.ACCT_TYPE=1001
group by ai.ITEM_EVENT;

-- 总钻石动向
select ai.ITEM_EVENT,ai.CHANGE_TYPE,round(sum(ai.CHANGE_VALUE)) from forum.t_acct_items ai 
where ai.USER_ID='347' and ai.ACCT_TYPE=1003
group by ai.ITEM_EVENT;


-- 总充值金币
select tc.charge_method,sum(tc.coins)
 from report.t_trans_user_recharge_coin tc
where tc.charge_user_id='347'
group by tc.charge_method;

-- 总充值钻石
select sum(tc.diamonds) from report.t_trans_merchant_recharge_diamond tc
where tc.charge_user_id='347';

-- 提现
SELECT SUM(tc.coins)
FROM report.t_trans_user_withdraw tc WHERE tc.user_id='347';



1.赠送
2.红包
3.pk场
4.悬赏答题
-- 4.充值
-- 5.投注
-- 

select t.USER_ID,t.nick_name from (
SELECT u.NICK_NAME,u.user_id,u.ACCT_NUM
FROM forum.t_user_present t
inner join forum.t_user u on t.TUSER_ID=u.USER_ID
WHERE t.USER_ID ='347' 

union all 

SELECT u.NICK_NAME,u.user_id,u.ACCT_NUM
FROM forum.t_user_present t
inner join forum.t_user u on t.USER_ID=u.USER_ID
WHERE t.TUSER_ID ='347' 
) t
group by t.user_id
-- OR t.TUSER_ID='347';






