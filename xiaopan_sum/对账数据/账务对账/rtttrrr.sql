select t1.ACCT_BALANCE+t2.ACCT_BALANCE,t1.FREEZE_MONEY+t2.FREEZE_MONEY
from (
select sum((decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)-decode(v.FREEZE_MONEY,null,0,v.FREEZE_MONEY)))/100 ACCT_BALANCE,
sum(v.FREEZE_MONEY)/100 FREEZE_MONEY from v_account_translog t
inner join  v_account_item as of timestamp trunc(sysdate)+1/2 v on t.ACC_NAME=v.ACC_NAME and v.ITEM_TYPE=1001 and v.acct_type=2
inner join (
  select t.ACC_NAME,max(t.VERSION) vers from v_account_translog t 
  inner join (
    select t.ACC_NAME from v_account_item as of timestamp trunc(sysdate)+1/2 t where 
    t.ITEM_TYPE=1001 and t.acct_type=2
    and t.MOD_DATE>=to_date( '2017-09-11' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
    and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603')
  ) ta on ta.ACC_NAME=t.ACC_NAME
  where t.ITEM_TYPE=1001 and t.VERSION>0 and t.TRANS_TIME>0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.TRANS_TIME/1000)+28800)/86400)<to_date( '2017-09-11' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2
)t1
,
(select sum(t.ACCT_BALANCE)/100 ACCT_BALANCE,sum(t.FREEZE_MONEY)/100 FREEZE_MONEY
from v_account_item as of timestamp trunc(sysdate)+1/2 t where 
t.ITEM_TYPE=1001 and t.acct_type=2
and t.MOD_DATE<to_date( '2017-09-11' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and t.ACC_NAME not in ('3472351858331386256','6149208545176280651','8270936710946839603'))t2;


-- select trunc(sysdate)+3/4 from dual
    
    
    
