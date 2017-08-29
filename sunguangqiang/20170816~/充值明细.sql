

set @param0='2016-01-01';
set @param1='2017-08-10';


drop table t_stat_user_charge_20170817_1615;
create table t_stat_user_charge_20170817_1615
select ai.ITEM_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ai.PAY_TIME,ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,ai.ITEM_SRC
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg' 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS=10
and ai.item_event IN ('BUY_DIAMEND', 'ADMIN_USER_OPT');


-- update-20170824
create table t_stat_user_charge_20170824
select u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ai.PAY_TIME,ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,ai.ITEM_SRC,
if(ai.COMMENTS like '{"buy_coin"%' or ai.CHANGE_VALUE=1,'金币充值','购买钻石') types 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS=10
and ai.item_event IN ('BUY_DIAMEND','ADMIN_USER_OPT');



drop table t_stat_user_charge_20170824;

create table t_stat_user_charge_20170824
select ai.ITEM_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ai.PAY_TIME,ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,ai.ITEM_SRC,
'购买金币' types 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.item_event = 'COIN_FROM_DIAMEND'

union all

select ai.ITEM_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ai.PAY_TIME,ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,ai.ITEM_SRC,
'购买钻石' types 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1003
and ai.COMMENTS not like '{"buy_coin"%' 
and ai.CHANGE_VALUE!=1
and ai.ITEM_STATUS=10
and ai.item_event = 'BUY_DIAMEND'
;


select ai.ITEM_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ai.PAY_TIME,ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,ai.ITEM_SRC,
'购买钻石' types 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1003
and ai.COMMENTS not like '{"buy_coin"%' 
and ai.CHANGE_VALUE!=1
and ai.ITEM_STATUS=10
and ai.item_event = 'BUY_DIAMEND';


UPDATE report.t_stat_user_charge_20170817_1615 t 
inner join forum.t_acct_items ai on t.ITEM_ID=ai.REF_ITEM_ID 
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10
and ai.item_event = 'DIAMEND_TO_COIN'
set t.CHANGE_VALUE=ai.COST_VALUE,
t.ACCT_TYPE=1001;



SELECT * from t_stat_user_charge_20170817_1615 t where t.ACCT_TYPE=1001 and t.ITEM_SRC!=0 limit 1000






-- 63096258

select t.stat_date,t1.COST_VALUE from report.t_stat_reference_time t
left join (
select 
date(ai.PAY_TIME) stat_time,
sum(ai.COST_VALUE) COST_VALUE 
from t_stat_user_charge_20170817_1615 ai
-- inner join forum.t_user u on ai.user_id =u.USER_ID and u.GROUP_TYPE !=1
where 
-- ai.ITEM_SRC in (3,4,9)
ai.item_src in (3,4,6,9,11)
and ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-08-10'
group by stat_time
) t1 on t.stat_date=t1.stat_time
where t.stat_date>='2017-01-01'
and t.stat_date<'2017-08-10';




-- 缺少pay_time记录(item_id)
-- 13964456
-- 50382633
-- 解决
select * from forum.t_acct_items ai where ai.ITEM_STATUS=10 and ai.PAY_TIME is null;

update forum.t_acct_items ai 
set ai.PAY_TIME=ai.ADD_TIME
where ai.ITEM_STATUS=10 and ai.PAY_TIME is null
and ai.ITEM_ID in (13964456,50382633);

-- 普通用户在沙箱渠道充值
-- 19415580
-- 36395715
select * from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.GROUP_TYPE!=1 and ai.ITEM_SRC=10;

update forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.GROUP_TYPE!=1 and ai.ITEM_SRC=10
set ai.ITEM_SRC=9
and ai.ITEM_ID in (19415580,36395715);


-- 沙箱用户在普通渠道充值
-- 2016-01-13,2016-01-20,2016-01-23,2016-01-24
select sum(ai.COST_VALUE) from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.GROUP_TYPE=1 and ai.ITEM_SRC!=10 and ai.ITEM_SRC!=0
where date(ai.PAY_TIME) in ('2016-01-13','2016-01-20','2016-01-23','2016-01-24');

update forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.GROUP_TYPE=1 and ai.ITEM_SRC!=10 and ai.ITEM_SRC!=0
and date(ai.PAY_TIME) in ('2016-01-13','2016-01-20','2016-01-23','2016-01-24')
set ai.ITEM_SRC=10;



-- 计算金额出错，将钻石数当作金额
-- 19815516(用户：1936863)
select * from forum.t_acct_items ai where ai.ITEM_ID='19815516';

select 
u.GROUP_TYPE,
ai.*
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
where  ai.ADD_TIME>='2016-10-17'
and ai.ADD_TIME<'2016-10-18'
and ai.item_event='BUY_DIAMEND'
and ai.ITEM_STATUS=10
and ai.ITEM_SRC=9;



SELECT * FROM (
select 
u.GROUP_TYPE,
ai.*
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
where  ai.ADD_TIME>='2017-05-11'
and ai.ADD_TIME<'2017-05-12'
and ai.item_event='BUY_DIAMEND'
and ai.ITEM_STATUS=10
)t1
left join (
select 
u.GROUP_TYPE,
ai.*
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
where  ai.PAY_TIME>='2017-05-11'
and ai.ADD_TIME<'2017-05-12'
and ai.item_event='BUY_DIAMEND'
and ai.ITEM_STATUS=10
) t2 on t1.item_id =t2.item_id
where t2.item_id is null;

select 
sum(ai.COST_VALUE)
from forum.t_acct_items ai
where ai.item_src in (3,4,6,9,11)
and ai.PAY_TIME>='2016-10-14'
and ai.PAY_TIME<'2016-10-15'
and ai.ITEM_STATUS=10
and ai.item_event='BUY_DIAMEND';

select 
sum(ai.COST_VALUE)
from forum.t_acct_items ai
where ai.item_src in (3,4,6,9,11)
and ai.ADD_TIME>='2016-10-14'
and ai.ADD_TIME<'2016-10-15'
and ai.ITEM_STATUS=10
and ai.item_event='BUY_DIAMEND';

select 
ai.ITEM_SRC,
sum(ai.COST_VALUE)
from forum.t_acct_items ai
where ai.item_src in (3,4,6,9,10,11)
and ai.PAY_TIME>='2017-05-11'
and ai.PAY_TIME<='2017-05-12'
and ai.ITEM_STATUS=10
and ai.item_event='BUY_DIAMEND'
GROUP BY ai.ITEM_SRC;


select 
ai.ITEM_SRC,
sum(ai.COST_VALUE)
from forum.t_acct_items ai
where ai.item_src in (3,4,6,9,10,11)
and ai.ADD_TIME>='2017-05-11'
and ai.ADD_TIME<='2017-05-12'
and ai.ITEM_STATUS=10
and ai.item_event='BUY_DIAMEND'
GROUP BY ai.ITEM_SRC;


-- 修正数据1
insert into t_stat_user_charge_20170817_1615(NICK_NAME,ACCT_NUM,USER_ID,USER_CODE,CRT_TIME,DEVICE_CODE,IP,PAY_TIME,COST_VALUE,CHANGE_VALUE,ACCT_TYPE,ITEM_SRC)
select u.NICK_NAME,u.ACCT_NUM,u.USER_ID,u.USER_CODE,u.CRT_TIME,e.DEVICE_CODE,e.IP,ifnull(ai.PAY_TIME,ai.ADD_TIME),ai.COST_VALUE,ai.CHANGE_VALUE,ai.ACCT_TYPE,if(ai.ITEM_SRC=10,9,ai.ITEM_SRC) 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID 
left join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
where ai.ITEM_ID in (13964456,50382633,19415580,36395715);

-- 修正数据2

update t_stat_user_charge_20170817_1615 t 
inner join (
select ai.ITEM_ID,ai.USER_ID,ai.ITEM_EVENT,ai.CHANGE_VALUE,ai.PAY_TIME from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.GROUP_TYPE=1 and ai.ITEM_SRC!=10 and ai.ITEM_SRC!=0
where date(ai.PAY_TIME) in ('2016-01-13','2016-01-20','2016-01-23','2016-01-24')
) t1 on t.USER_ID=t1.user_id and t.PAY_TIME=t1.PAY_TIME and t.COST_VALUE=t.COST_VALUE
set t.ITEM_SRC=10;


-- ---------------------------------------------------------
UPDATE report.t_stat_user_charge_20170817_1615 t 
inner join forum.t_acct_items e on t.USER_ID=e.USER_ID
and e.EVENT_ID= (
	select * from (
	select max(t1.EVENT_ID) from report.t_stat_user_charge_20170817_1615 t 
	inner join forum.t_acct_items t1 on t.USER_ID =t1.USER_ID 
	and t.id=temp_id
	and t1.CRT_TIME<=t.PAY_TIME
	and t1.IP is not null 
	and t1.DEVICE_CODE is not null
	) t
) and (t.IP is null or t.DEVICE_CODE is null)
set t.IP=e.IP,
t.DEVICE_CODE=e.DEVICE_CODE ;

-- ----------------------------------------------------
insert into report.t_stat_user_charge_20170817_1615(USER_ID,BUY_DIAMONDS,BUY_COINS) 
	select t.user_id,ifnull(t.COST_VALUE,0)-ifnull(t.BUY_COINS,0) BUY_DIAMONDS,ifnull(BUY_COINS,0) BUY_COINS from (
	select ai.user_id,t.COST_VALUE,sum(ai.CHANGE_VALUE) BUY_COINS from t_stat_user_charge_20170817_1615 t
	inner join from forum.t_acct_items ai on t.USER_ID=ai.USER_ID and t.ID=temp_id
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1003
	and ai.PAY_TIME<stat_time
	and ai.ITEM_EVENT='diamend_t_coin'
) t;

-- --------------------------------------------------------

select ai.CHANGE_VALUE from forum.t_acct_items ai 
where ai.ITEM_EVENT ='buy_diamend' 
and (ai.COMMENTS like '{"buy_coin"%' or ai.CHANGE_VALUE=1) 

-- -----------------------------------------------





select 
ai.*,
CASE
        WHEN ai.item_src = 3 THEN '微信'
        WHEN ai.item_src = 4 THEN '支付宝'
        WHEN ai.item_src =9 THEN '苹果'
        WHEN ai.item_src = 10 THEN '苹果沙箱'
        WHEN ai.item_src = 11 THEN '百度支付'
        WHEN ai.item_src = 0 THEN '系统'
        WHEN ai.item_src = 6 THEN '银行卡'
        ELSE ai.item_src
end     AS item_src

from t_stat_user_charge_20170817_1615 ai 
where ai.item_src in (3,4,6,9,11);


select 

sum(ai.COST_VALUE)

from t_stat_user_charge_20170817_1615 ai 
where ai.item_src in (3,4,6,9,11)
and ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-08-10';


-- 14884155
-- 14884151 

-- 12541256
-- 12541256



select 
ai.*,
CASE
        WHEN ai.item_src = 3 THEN '微信'
        WHEN ai.item_src = 4 THEN '支付宝'
        WHEN ai.item_src =9 THEN '苹果'
        WHEN ai.item_src = 10 THEN '苹果沙箱'
        WHEN ai.item_src = 11 THEN '百度支付'
        WHEN ai.item_src = 0 THEN '系统'
        WHEN ai.item_src = 6 THEN '银行卡'
        ELSE ai.item_src
end     AS item_src,
if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0) '购买金币数',
if(ai.ACCT_TYPE=1003,ai.CHANGE_VALUE,0) '购买钻石数'

from t_stat_user_charge_20170817_1615 ai 
where ai.item_src in (3,4,6,9,11)
and ai.PAY_TIME>='2016-01-01'
and ai.PAY_TIME<'2017-08-10';



delete t from t_stat_user_charge_20170817_1615 t
inner join forum.t_acct_items ai on ai.ITEM_ID=t.ITEM_ID and ai.ITEM_EVENT='ADMIN_USER_OPT';






-- 13964456
-- 50382633
-- 19415580
-- 36395715


