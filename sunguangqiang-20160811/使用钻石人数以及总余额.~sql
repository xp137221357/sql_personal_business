select (date '2016-08-15' - date '1970-01-01') * (24 * 60 * 60 * 1000) from dual;

select '钻石余额人数',count(distinct t.ACC_NAME),'钻石总余额',sum(t.MONEY_AFTER)*0.01  from (
SELECT B.MONEY_AFTER,c.ACC_NAME, b.CRT_TIME, dense_rank() over (partition by c.ACC_NAME order by b.CRT_TIME desc) rn
FROM v_ACCOUNT_OPT_REQUEST C 
INNER JOIN v_ACCOUNT_TRANSLOG b ON B.TRANSACTION=C.TRANSACTION AND B.MONEY_AFTER>0
INNER JOIN v_account t on B.ACC_NAME=T.UA_NAME and C.ACC_NAME=T.UA_NAME
WHERE b.ITEM_TYPE=1003 and b.STATUS=10 
and b.CRT_TIME < 1471219200000
)t where t.rn = 1;
