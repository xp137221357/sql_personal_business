/*
 用户前总余额查询
 参考时间 ：2016-06-23 00:00:00
 参考时间戳 ：1466611200000 
*/
set @deadlineDay='2016-06-23 00:00:00';
set @deadlineStamp=1466611200000;

-- 大户前总余额
select @deadlineDay '截止时间','大户前总余额',sum(t.MONEY_AFTER)*0.01  from (
SELECT B.MONEY_AFTER,c.ACC_NAME, b.CRT_TIME, dense_rank() over (partition by c.ACC_NAME order by b.CRT_TIME desc) rn
FROM v_ACCOUNT_OPT_REQUEST C 
INNER JOIN v_ACCOUNT_TRANSLOG b ON B.TRANSACTION=C.TRANSACTION 
inner join t_user_boss t on B.ACC_NAME=T.USER_CODE and C.ACC_NAME=T.USER_CODE
WHERE b.ITEM_TYPE=1001  and b.STATUS=10 and b.CRT_TIME<@deadlineStamp 
)t where t.rn = 1


union all

-- 留存用户前总余额
select @deadlineDay '截止时间','留存用户前总余额',sum(t.MONEY_AFTER)*0.01  from (
SELECT B.MONEY_AFTER,c.ACC_NAME, b.CRT_TIME, dense_rank() over (partition by c.ACC_NAME order by b.CRT_TIME desc) rn
FROM v_ACCOUNT_OPT_REQUEST C 
INNER JOIN v_ACCOUNT_TRANSLOG b ON B.TRANSACTION=C.TRANSACTION 
inner join v_account t on B.ACC_NAME=T.UA_NAME and C.ACC_NAME=T.UA_NAME and not exists (select 1 from t_user_boss ub where ub.USER_CODE=t.UA_NAME)
WHERE b.ITEM_TYPE=1001  and b.STATUS=10 and b.CRT_TIME<@deadlineStamp
)t where t.rn = 1
