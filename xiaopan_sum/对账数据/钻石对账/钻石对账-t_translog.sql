-- 标准时间戳
select  TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) from dual;

-- 通过v_account_translog计算余额
-- MONEY_AFTER+t.MONEY_BEFORE计算方式
-- 账务记录
select t.ACC_NAME||'_',t.MONEY*0.01,t.MONEY_AFTER*0.01,TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400),TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) 
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-03-05' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-03-05' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1015 AND T.STATUS = 10 
order by t.CRT_TIME asc ;

-- select  TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME/1000)/24/60/60) from dual   t.CRT_TIME+28800000

-- 对账总数

select sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-05-22' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-05-22' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');

    
-- 用户对账（人群）
select tt.ACC_NAME_,tt.value from(    
select t.ACC_NAME,t.ACC_NAME||'_' ACC_NAME_,sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) value
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-06-27' ||' 12:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-06-28' ||' 11:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1004 AND T.STATUS = 10 
group by t.ACC_NAME
)tt order by tt.ACC_NAME asc;

-- 用户对账（个人）
select t.*,t.MONEY_AFTER*0.01-t.MONEY_BEFORE*0.01 value,TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) MOD_TIME,TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) CRT_TIME
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-06-27' ||' 12:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-06-28' ||' 11:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1004 AND T.STATUS = 10 and t.ACC_NAME='5491782735690769177' 
order by t.CRT_TIME asc ;


select t.*,t.MONEY_AFTER*0.01-t.MONEY_BEFORE*0.01 value,TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) MOD_TIME,TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) CRT_TIME
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-01-25' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-01-25' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1001 AND T.STATUS = 10
and t.ACC_NAME='5931572109727412625'
and t.OPT_TYPE=5;

-- 修改时间
select tt.ACC_NAME_,tt.value,tt.crt_time from(    
select t.ACC_NAME,t.ACC_NAME||'_' ACC_NAME_,sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) value,TO_DATE('19700101','yyyymmdd') + ((floor(min(t.CRT_TIME)/1000)+28800)/86400) CRT_TIME
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-03-28' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-03-28' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1015 AND T.STATUS = 10 
group by t.ACC_NAME
)tt order by tt.ACC_NAME asc;

select * from (
select to_date(t.CRT_TIME,'yyyy-mm-dd') stat_time,sum(t.value)
from (
select t.MONEY_AFTER*0.01-t.MONEY_BEFORE*0.01 value,
to_char(TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400),'yyyy-mm-dd') MOD_TIME,
to_char(TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400),'yyyy-mm-dd') CRT_TIME
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-01-01' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-04-14' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.ITEM_TYPE = 1001 AND T.STATUS = 10
and t.OPT_TYPE=6
)t group by to_date(t.CRT_TIME,'yyyy-mm-dd')
)t order by t.stat_time asc ;

-- OPT_TYPE+MONEY计算方式

select 
sum(
   case 
     when t.OPT_TYPE in (2,5,8,10,13) then t.MONEY*0.01 
     when t.OPT_TYPE in (3,4,6,9,12,14) then -t.MONEY*0.01
     else 0
   end 
) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-05-24' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-05-24' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');

-- 对比计算方式
-- 5141054.21
-- 5141054.21

select sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-05-02' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-05-02' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');

-- 检查问题
select * from (
select 
t.ID,abs(decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)-decode(t.MONEY_BEFORE,null,0,t.MONEY_BEFORE))-decode(t.MONEY,null,0,t.MONEY) change_value
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-05-02' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-05-02' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
) t where t.change_value>10;

-- 通过v_account_item计算余额
-- 数据回滚
select sum(t.ACCT_BALANCE) from v_account_item t
where t.ITEM_TYPE=1001
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_DATE/1000)+28800)/86400) >= to_date( '2017-0-01' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_DATE/1000)+28800)/86400) <= to_date('2017-04-14' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');

SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp trunc(sysdate)
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp to_date('2017-04-20 18:03:03','yyyy-mm-dd hh24:mi:ss')
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;

SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp 
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;

-- 2144854;
-- 2144856

-- 账务余额明细

select * from (
select t.ACC_NAME||'_' ACC_NAME,
SUM(T.ACCT_BALANCE) from v_account_item t
where t.ITEM_TYPE=1001
and t.CRT_DATE>=to_date( '2017-04-20' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and t.CRT_DATE<=to_date( '2017-04-20' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss')
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
group by t.ACC_NAME
)tt order by tt.ACC_NAME asc;


-- 账务分批同步

select t.* from (
select rownum as id,t.* from v_account_item t
) t where t.id>=10 and t.id<11;

select count(1) from v_account_item as of timestamp trunc(sysdate)-1/(24*3600) ;

select MIN(T.ACCT_ITEM_ID),MAX(T.ACCT_ITEM_ID) from v_account_item t ; 

SELECT TIMESTAMP_TO_SCN(SYSDATE) FROM DUAL;

select count(1) from v_account_item as of scn TIMESTAMP_TO_SCN(SYSDATE);
-- 19557835
select count(1) from v_account_item as of TIMESTAMP SYSDATE;
-- 19557673

SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp to_date('2017-05-03 22:59:59','yyyy-mm-dd hh24:mi:ss')
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of scn TIMESTAMP_TO_SCN(to_date('2017-04-28 10:30:00','yyyy-mm-dd hh24:mi:ss'))
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
select TIMESTAMP_TO_SCN(to_date('2017-04-28 15:00:02','yyyy-mm-dd hh24:mi:ss')) from dual;
  -- 2017-04-28 23:59:59, 293600547 ,294073029
  -- 2017-04-28 23:59:56, 293600547
SELECT to_char(SCN_TO_TIMESTAMP(293600547),'yyyy-mm-dd hh24:mi:ss') FROM DUAL;


SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp to_date('2017-05-03 23:59:59','yyyy-mm-dd hh24:mi:ss')
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
SELECT ITEM_TYPE ITEM_TYPE, SUM(decode(ACCT_BALANCE,null,0,ACCT_BALANCE) + decode(FREEZE_MONEY,null,0,FREEZE_MONEY)) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp to_date('2017-05-03 23:59:59','yyyy-mm-dd hh24:mi:ss')
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;

-- 新余额计算方案

select 
sum(
   case 
     when t.OPT_TYPE in (2,5,8,10,13) then t.MONEY*0.01 
     when t.OPT_TYPE in (3,4,6,9,12,14) then -t.MONEY*0.01
     else 0
   end 
) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) >= to_date( '2017-05-24' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) <= to_date('2017-05-24' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and t.id not in (
select id from v_account_translog t where t.REFUND_MONEY>0
and  TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) >= to_date( '2017-05-24' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400) <= to_date('2017-05-24' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and to_char(TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400),'yyyy-mm-dd')!=to_char(TO_DATE('19700101','yyyymmdd') + ((floor(t.MOD_TIME/1000)+28800)/86400),'yyyy-mm-dd')

);



