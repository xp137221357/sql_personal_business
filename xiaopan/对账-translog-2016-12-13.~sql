select t.ACC_NAME,t.MONEY*0.01,t.MONEY_AFTER*0.01,TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60),TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) 
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60) >= to_date( '2016-12-04' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60) <= to_date('2016-12-04' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 and t.ACC_NAME='8780943156219273635'
order by t.MOD_TIME asc 

-- select  TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME/1000)/24/60/60) from dual   t.CRT_TIME+28800000




 
