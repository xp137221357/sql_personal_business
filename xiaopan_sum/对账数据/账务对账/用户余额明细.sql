
-- ǰ�����
select count(1),sum((decode(t.MONEY_BEFORE,null,0,t.MONEY_BEFORE)-decode(t.FREEZE_MONEY,null,0,t.FREEZE_MONEY)))/100 ACCT_BALANCE,sum(t.FREEZE_MONEY)/100 FREEZE_MONEY
from v_account_translog t
inner join (
  select t.ACC_NAME,min(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-21','yyyy-mm-dd')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-21','yyyy-mm-dd')+1
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10;
xp137221357

-- �������
select count(1),sum((decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)-decode(t.FREEZE_MONEY,null,0,t.FREEZE_MONEY)))/100 ACCT_BALANCE,sum(t.FREEZE_MONEY)/100 FREEZE_MONEY
from v_account_translog t
inner join (
  select t.ACC_NAME,count(distinct version),max(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-21','yyyy-mm-dd')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-21','yyyy-mm-dd')+1
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10;


-- ����
select count(distinct t.ACC_NAME),sum(t.MONEY_AFTER)/100-sum(t.MONEY_BEFORE)/100 CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-09-13','yyyy-mm-dd')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date( '2017-09-13','yyyy-mm-dd')+1 
and t.ITEM_TYPE = 1001 and t.acct_type=2 AND T.STATUS = 10;

-- ǰ�������ϸ

select t.ACC_NAME||'_',decode(t.MONEY_BEFORE,null,0,t.MONEY_BEFORE)/100 ACCT_BALANCE
from v_account_translog t
inner join (
  select t.ACC_NAME,min(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-21','yyyy-mm-dd')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-21','yyyy-mm-dd')+1
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10;


-- ���������ϸ
select t.ACC_NAME||'_',decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)/100 ACCT_BALANCE
from v_account_translog t
inner join (
  select t.ACC_NAME,max(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-21','yyyy-mm-dd')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-21','yyyy-mm-dd')+1
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10;


-- �����ϸ
select t.ACC_NAME||'_',sum(t.MONEY_AFTER)/100-sum(t.MONEY_BEFORE)/100 CHANGED_SUM
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) >= to_date( '2017-09-21','yyyy-mm-dd')
and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400) <= to_date( '2017-09-21','yyyy-mm-dd')+1 
and t.ITEM_TYPE = 1001 and t.acct_type=2 AND T.STATUS = 10
group by t.ACC_NAME;


-- ����
select t1.ACC_NAME||'_' ACC_NAME,t1.ACCT_BALANCE MONEY_BEFORE,t2.ACCT_BALANCE MONEY_AFTER  from (
select t.ACC_NAME,decode(t.MONEY_BEFORE,null,0,t.MONEY_BEFORE)/100 ACCT_BALANCE
from v_account_translog t
inner join (
  select t.ACC_NAME,min(t.VERSION) vers from v_account_translog t 
  where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-13','yyyy-mm-dd')
  and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-13','yyyy-mm-dd')+1
  group by t.ACC_NAME
) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10
) t1 
inner join (
  select t.ACC_NAME,decode(t.MONEY_AFTER,null,0,t.MONEY_AFTER)/100 ACCT_BALANCE
  from v_account_translog t
  inner join (
    select t.ACC_NAME,max(t.VERSION) vers from v_account_translog t 
    where t.ITEM_TYPE=1001 and t.acct_type=2 and t.VERSION>=0 and t.TRANS_TIME>=0
    and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)>=to_date( '2017-09-13','yyyy-mm-dd')
    and TO_DATE('19700101','yyyymmdd') + ((floor(t.CRT_TIME/1000)+28800)/86400)<to_date( '2017-09-13','yyyy-mm-dd')+1
    group by t.ACC_NAME
  ) t1 on t.ACC_NAME=t1.ACC_NAME and t.VERSION=t1.vers and t.ITEM_TYPE=1001 and t.acct_type=2 and t.STATUS=10
)t2 on t1.ACC_NAME=t2.ACC_NAME;
