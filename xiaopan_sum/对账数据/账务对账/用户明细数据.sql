select ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_TYPE,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
where ai.PAY_TIME>=curdate()
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE in (1001,1003,1004)
group  by ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_TYPE;


SELECT *
FROM report.t_sql_query t
WHERE t.sql_function LIKE '%吴%'