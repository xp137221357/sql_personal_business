set @param0='2017-05-19';
set @param1='2017-05-19 23:59:59';



-- 对帐时间事件
SELECT ai.ITEM_EVENT,round(sum(ai.CHANGE_VALUE))
FROM FORUM.t_acct_items ai
where ai.PAY_TIME>=@param0 
AND ai.PAY_TIME<=@param1
and ai.ACCT_TYPE=1001
group by ai.ITEM_EVENT
;
-- COIN_F_DIAMEND
-- 账务明细对账

truncate t_acct_item_20170322;
truncate t_acct_item_20170322_log;


-- create table t_acct_item_20170322
insert into t_acct_item_20170322
select t.ACCT_ID user_id,t.value from (
select 
 ai.ACCT_ID,concat(ai.ACCT_ID,'_') ACCT_ID_,round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE))) value
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10)
and v.USER_ID is null 
group by ai.ACCT_ID
)t;

-- 明细
SELECT *
FROM FORUM.t_acct_items ai
WHERE ai.ACCT_ID='1943656544649697060' 
AND ai.PAY_TIME>=@param0 
AND ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10)
order by ai.PAY_TIME asc;

-- 修改
update t_acct_item_20170322_log t set t.user_id=replace(t.user_id,'_','');


set @param0='2017-03-26';
set @param1='2017-03-26 23:59:59';
select * from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and date(ai.UPDATE_TIME)>date(ai.PAY_TIME);

truncate t_acct_item_20170322;
truncate t_acct_item_20170322_log;


select count(1),sum(t.value) from t_acct_item_20170322 t;
select count(1),sum(t.value) from t_acct_item_20170322_log t;


select sum(t.value) from (
select t1.* from t_acct_item_20170322_log t1
left join t_acct_item_20170322 t2 on t1.user_id=t2.user_id
where t2.user_id is null
) t ;

select sum(t.value) from (
select t1.* from t_acct_item_20170322 t1
left join t_acct_item_20170322_log t2 on t1.user_id=t2.user_id
where t2.user_id is null
) t ;


-- 对账1
select * from t_acct_item_20170322 t1
left join t_acct_item_20170322_log t2 on t1.user_id=t2.user_id
where abs(ifnull(t1.value,0)-ifnull(t2.value,0))>100;

-- 对账2
select * from t_acct_item_20170322_log t1
left join t_acct_item_20170322 t2 on t1.user_id=t2.user_id
where abs(ifnull(t1.value,0)-ifnull(t2.value,0))>10;

-- 3892548685162290383
-- 4542312563226341722

-- 
select * from forum.t_acct_items ai   
where ai.ITEM_EVENT='USER_TASK'
and ai.PAY_TIME>='2017-05-22'
and ai.ACCT_ID='1287547987317586063'
order by ai.PAY_TIME desc;


SELECT *
FROM FORUM.t_acct_items ai
WHERE ai.ACCT_ID in ('4542312563226341722','3892548685162290383')
and ai.ITEM_EVENT in ('USER_TASK')
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10)
and ai.UPDATE_TIME>='2017-04-05'
and date(ai.UPDATE_TIME)>date(ai.pay_time)
order by ai.PAY_TIME asc;


update FORUM.t_acct_items ai set ai.PAY_TIME=ai.UPDATE_TIME 
WHERE ai.ACCT_ID in ('4542312563226341722','3892548685162290383')
and ai.ITEM_EVENT in ('TB_BINGO')
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10)
and ai.UPDATE_TIME>='2017-04-05'
and date(ai.UPDATE_TIME)>date(ai.pay_time)
;




-- a9e25c883b2a46768b12b17990c8b1c4

select * from forum.t_acct_items ai where ai.TRADE_NO like '%5c39dfd4082641469bece0e74646815c%';


select * from game.t_order_item o where o.ITEM_ID='0bee22d8c4db429eb1a659a90af09b3a';










