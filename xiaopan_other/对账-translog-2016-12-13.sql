-- 账务记录
select t.ACC_NAME||'_',t.MONEY*0.01,t.MONEY_AFTER*0.01,TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60),TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) 
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) >= to_date( '2017-02-20' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) <= to_date('2017-02-20' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
order by t.CRT_TIME asc ;

-- select  TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME/1000)/24/60/60) from dual   t.CRT_TIME+28800000

-- 对账总数
select sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) >= to_date( '2017-02-20' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) <= to_date('2017-02-20' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');

    
-- 用户对账（人群）

select * from(    
select t.ACC_NAME,t.ACC_NAME||'_' ACC_NAME_,sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) value
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) >= to_date( '2017-02-20' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) <= to_date('2017-02-20' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
group by t.ACC_NAME
)tt order by tt.ACC_NAME asc;

-- 用户对账（个人）
select t.*,TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60) MOD_TIME,TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) CRT_TIME
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) >= to_date( '2017-02-20' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) <= to_date('2017-02-20' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 and t.ACC_NAME='1839477601558691669' 
order by t.CRT_TIME asc ;












 
