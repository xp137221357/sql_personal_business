2017-09-12 12:00:00
调整前余额：1090648209.27
调整后余额：1090650209.27
差额：2000.00

-- 系统用户之前23730308.25
-- 系统用户当前17306967.25
select sum(t.ACCT_BALANCE)/100 from v_account_item t where t.ACC_NAME in ('3472351858331386256','6149208545176280651','8270936710946839603') and t.ITEM_TYPE=1001 and t.acct_type=2;

-- 2017-09-19
-- 3580998
-- 1104639775.05
select count(1),sum(t.ACCT_BALANCE)/100 ACCT_BALANCE,sum(t.FREEZE_MONEY)/100 FREEZE_MONEY
from v_account_item as of timestamp to_date( '2017-09-19' ||' 13:00:00','yyyy-mm-dd hh24:mi:ss') t where 
t.ITEM_TYPE=1001 and t.acct_type=2;

-- 3581362
-- 1113948551.62

select sum(t.MONEY_AFTER*0.01)-sum(t.MONEY_BEFORE*0.01) CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-09-19' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date('2017-09-19' ||' 13:00:00','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 


-- 226364185.35 -- 95961002
-- 新版余额计算方式
select count(1),sum((decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)-decode(t.FREEZE_MONEY,null,0,t.FREEZE_MONEY)))/100 ACCT_BALANCE,
sum(t.FREEZE_MONEY)/100 FREEZE_MONEY from v_account_translog t
inner join (
  select t.ACC_NAME,max(t.VERSION) vers from v_account_translog t 
  inner join (
    select t.ACC_NAME from v_account_item as of timestamp trunc(sysdate)+1/2 t where 
    t.ITEM_TYPE=1001 and t.acct_type=2
    and t.MOD_DATE>=to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
    and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
  ) ta on ta.ACC_NAME=t.ACC_NAME
  where t.ITEM_TYPE=1001  and t.VERSION>0 and t.TRANS_TIME>0 and t.STATUS=10
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)<to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10;

-- 816222519.16 -- 92478805
select count(1),sum(t.ACCT_BALANCE)/100 ACCT_BALANCE,sum(t.FREEZE_MONEY)/100 FREEZE_MONEY
from v_account_item as of timestamp trunc(sysdate)+1/2 t where 
t.ITEM_TYPE=1001 and t.acct_type=2
and t.MOD_DATE<to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');



-- -------------------------------- 最新方式

select count(1),sum((decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)-decode(t.FREEZE_MONEY,null,0,t.FREEZE_MONEY)))/100 ACCT_BALANCE
from v_account_translog t
inner join (
  select t.ACC_NAME,max(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>0 and t.TRANS_TIME>0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)>=to_date( '2017-09-14' ||' 23:30:00','yyyy-mm-dd hh24:mi:ss')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)<to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');


select count(1),sum(v.ACCT_BALANCE)/100 from v_account_item as of timestamp to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss') v 
left join (
  select t.ACC_NAME from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>0 and t.TRANS_TIME>0 and t.STATUS=10
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)>=to_date( '2017-09-14' ||' 23:30:00','yyyy-mm-dd hh24:mi:ss')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)<to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
  group by t.ACC_NAME
 ) t1 on v.ACC_NAME=t1.ACC_NAME
where t1.ACC_NAME is null
and v.ITEM_TYPE=1001 and v.acct_type=2
and v.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');



select count(1),sum(t.ACCT_BALANCE)/100 ACCT_BALANCE
from v_account_item as of timestamp to_date( '2017-09-17' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss') t where 
t.ITEM_TYPE=1001 and t.acct_type=2
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');


select count(1),sum(t.ACCT_BALANCE)/100 ACCT_BALANCE
from v_account_item as of timestamp to_date( '2017-09-17' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss') t where 
t.ITEM_TYPE=1001 and t.acct_type=2
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603');


select t.ACC_NAME from v_account_translog t 
where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>0 and t.TRANS_TIME>0 and t.STATUS=10
and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)>=to_date( '2017-09-14' ||' 23:30:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)<to_date( '2017-09-15' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')


-- 找到一种新的方式

v_account_translog--> 最后一条记录来匹配
v_account_item  -->匹配这里的数据SCN;
-- 然后根据这个SCN数据回滚


select * from t_user_attribute

truncate table t_user_attribute







