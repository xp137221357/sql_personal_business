/*
sunl(孙亮) 09-01 10:23:11
送券FREE_RECOM_COUPON  -acct_type=100
消费 BUY_RECOM -acct_type=100
sunl(孙亮) 09-01 10:24:03
BUY_DIAMEND ACCT_TYPE=1003 comments like '%ACT_YYLB%'
sunl(孙亮) 09-01 10:28:10
送券FREE_RECOM_COUPON  -acct_type=100  TRADE=REG
TRADE= LIKE 'ACT_YYLB%'
*/
-- -------------------------------------------------------------------------------
-- 表1：活动用户人数

-- 新增激活
set @beginTime='2016-09-06';
set @endTime='2016-09-08 23:59:59';
select t.PERIOD_NAME '日期',sum(t.FIRST_DNUM) '首次激活' 
from report.t_rpt_overview t 
where t.PERIOD_TYPE=1 and t.PERIOD_NAME>=@beginTime 
and t.PERIOD_NAME<= @endTime
group by PERIOD_NAME;

-- 新增注册

select date(u.CRT_TIME)'日期',count(distinct u.user_id) '注册用户数' 
from forum.t_user u 
where u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
group by date(u.CRT_TIME);

-- 购买一元礼包

select date(t.add_time) '日期', count(distinct t.user_id) '充值一元礼包人数',sum(t.cost_value) '充值一元礼包金额' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event='BUY_DIAMEND'
and t.ACCT_TYPE=1003 
and t.comments like '%ACT_YYLB%'
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time);

-- 充值
select date(t.add_time) '日期', count(distinct t.user_id) '充值人数',sum(t.cost_value) '充值金额' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='BUY_DIAMEND'
and t.ACCT_TYPE=1003 
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time);

-- ---------------------------------------------------------
-- 表2：专家体验劵

-- 新增注册人数
select date(u.CRT_TIME)'日期',count(distinct u.user_id) '注册用户数' 
from forum.t_user u 
where u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
group by date(u.CRT_TIME);

-- 领取人数

select date(t.add_time) '日期', count(distinct t.user_id) '领取人数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='FREE_RECOM_COUPON' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time);

-- 使用人数
select date(t.add_time) '日期', count(distinct t.user_id) '使用人数' ,count(t.user_id) '使用次数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='BUY_RECOM ' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time);

-- 充值钻石人数,金额
select date(td.crt_time) '日期', count(distinct td.charge_user_id) '充值钻石人数',sum(td.rmb_value) '充值金额'
from report.t_trans_user_recharge_diamond td 
inner join forum.t_user u on td.charge_user_id= u.USER_ID and date(u.CRT_TIME)= date(td.crt_time)
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where td.crt_time >= @beginTime 
and td.crt_time<= @endTime
group by date(td.crt_time);


-- -----------------------------------------------------------------
-- 表3：总结数据
-- 日期 2016-08-16~2016-08-31，2016-09-01~2016-09-10，2016-09-11~2016-09-20
-- 终端 android,ios,全部
-- set @beginTime='2016-09-01';
-- set @endTime='2016-09-04 23:59:59';

select concat(@beginTime,'~',@endTime) '日期',tu.SYSTEM_MODEL '终端类型',count(distinct u.user_id) '注册用户数' 
from forum.t_user u 
inner join report.t_trans_user_attr tu on u.USER_ID = tu.USER_ID  
and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
group by tu.SYSTEM_MODEL;

-- 领取人数

select concat(@beginTime,'~',@endTime)  '日期',tu.SYSTEM_MODEL '终端类型', count(distinct t.user_id) '领取人数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and u.CRT_TIME>=@beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join report.t_trans_user_attr tu on t.USER_ID = tu.USER_ID
where t.item_event ='FREE_RECOM_COUPON' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by tu.SYSTEM_MODEL;

-- 使用人数
select concat(@beginTime,'~',@endTime)  '日期', tu.SYSTEM_MODEL '终端类型', count(distinct t.user_id) '使用人数' ,count(t.user_id) '使用次数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and u.CRT_TIME>=@beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join report.t_trans_user_attr tu on t.USER_ID = tu.USER_ID
where t.item_event ='BUY_RECOM ' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by tu.SYSTEM_MODEL;

-- 充值钻石人数,金额
select concat(@beginTime,'~',@endTime)  '日期', tu.SYSTEM_MODEL '终端类型', count(distinct td.charge_user_id) '充值钻石人数',sum(td.rmb_value) '充值金额'
from report.t_trans_user_recharge_diamond td 
inner join forum.t_user u on td.charge_user_id= u.USER_ID and u.CRT_TIME>=@beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join report.t_trans_user_attr tu on td.charge_user_id = tu.USER_ID
where td.crt_time >= @beginTime 
and td.crt_time<= @endTime
group by tu.SYSTEM_MODEL;