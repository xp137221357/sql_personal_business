-- -- 表1：活动用户人数

--
set @beginTime0='2016-09-26';
set @endTime0='2016-10-02 23:59:59';

set @beginTime='2016-09-19';
set @endTime='2016-09-25 23:59:59';

set @beginTime1='2016-09-26';
set @endTime1='2016-10-02 23:59:59';

-- 新增激活
select concat(@beginTime1,'~',@endTime1)  '日期',sum(t.FIRST_DNUM) '首次激活' 
from report.t_rpt_overview t 
where t.PERIOD_TYPE=1 and t.PERIOD_NAME>=@beginTime1
and t.PERIOD_NAME<= @endTime1;

-- 新增注册

select concat(@beginTime1,'~',@endTime1) '日期',count(distinct u.user_id) '注册用户数' 
from forum.t_user u 
where u.CRT_TIME>= @beginTime1 and u.CRT_TIME<= @endTime1
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10;

-- 领取人数

select concat(@beginTime,'~',@endTime)  '日期', count(distinct t.user_id) '领取人数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='FREE_RECOM_COUPON' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime;

-- 领取数量
select concat(@beginTime,'~',@endTime)  '日期', count(t.user_id) '领取数量' 
from forum.t_acct_items t 
inner join forum.t_user u on t.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='FREE_RECOM_COUPON' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime  
and t.add_time<= @endTime;

-- 充值钻石
select concat(@beginTime,'~',@endTime)  '时间',count(distinct td.charge_user_id) '充值人数',sum(td.diamonds) '充值钻石数',sum(td.rmb_value) '充值金额'
from report.t_trans_user_recharge_diamond td
inner join forum.t_acct_items ai on ai.USER_ID=td.charge_user_id 
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
and ai.item_event ='FREE_RECOM_COUPON' 
and ai.ACCT_TYPE=100
and ai.ITEM_STATUS=10
and ai.ADD_TIME>= @beginTime and ai.ADD_TIME<= @endTime 
and td.CRT_TIME >= @beginTime and td.CRT_TIME <= @endTime
;

-- 购买推荐人数
select concat(@beginTime,'~',@endTime)  '时间',count(distinct ai.USER_ID) '购买推荐人数',sum(ai.change_value) '使用钻石数'
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join forum.t_acct_items ai2 on ai.USER_ID=ai2.user_id
and ai2.item_event ='FREE_RECOM_COUPON' 
and ai2.ACCT_TYPE=100
and ai2.ITEM_STATUS=10
and ai2.ADD_TIME >= @beginTime and ai2.ADD_TIME <= @endTime
and ai.ITEM_STATUS =10 AND ai.ITEM_EVENT in ('BUY_RECOM')    -- ('BUY_SERVICE','BUY_RECOM')
and ai.ADD_TIME >= @beginTime 
and ai.ADD_TIME <= @endTime;


-- 领取专家体验券用户 留存行为

-- 启动app数
select concat(@beginTime1,'~',@endTime1)  '日期', '继续启动app数',count(ai.user_id) '人数' from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP' and u.`STATUS`=10
inner join report.t_trans_user_attr tu on ai.USER_ID = tu.USER_ID
inner join (select td.user_code from t_device_statistic td
		where      td.stat_type = 1
		and        td.DEVICE_STATUS !=-10
		AND        td.crt_time >= @beginTime1
		AND        td.crt_time <  @endTime1
		group by td.user_code) t  on t.user_code = tu.user_code
where ai.item_event ='FREE_RECOM_COUPON' 
and ai.ACCT_TYPE=100
and ai.ITEM_STATUS=10
and ai.ADD_TIME>= @beginTime and ai.ADD_TIME<= @endTime ;


-- 使用人数
select concat(@beginTime1,'~',@endTime1)  '日期', count(distinct t.user_id) '继续使用人数' ,count(t.user_id) '继续使用次数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join forum.t_acct_items ai on t.USER_ID=ai.user_id
and ai.item_event ='FREE_RECOM_COUPON' 
and ai.ACCT_TYPE=100
and ai.ITEM_STATUS=10
and ai.ADD_TIME>= @beginTime and ai.ADD_TIME<= @endTime 
where t.item_event ='BUY_RECOM ' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime1 
and t.add_time<= @endTime1;


-- 充值钻石
select concat(@beginTime1,'~',@endTime1)  '时间',count(distinct td.charge_user_id) '继续充值人数',sum(td.diamonds) '继续充值钻石数',sum(td.rmb_value) '继续充值金额'
from report.t_trans_user_recharge_diamond td
inner join forum.t_acct_items ai on ai.USER_ID=td.charge_user_id
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10 
and ai.item_event ='FREE_RECOM_COUPON' 
and ai.ACCT_TYPE=100
and ai.ITEM_STATUS=10
and ai.ADD_TIME>= @beginTime and ai.ADD_TIME<= @endTime 
and td.CRT_TIME >= @beginTime1 and td.CRT_TIME <= @endTime1
;

-- 购买推荐人数
select concat(@beginTime1,'~',@endTime1)  '时间',count(distinct ai.USER_ID) '继续购买推荐人数',sum(ai.change_value) '继续使用钻石数'
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
inner join forum.t_acct_items ai2 on ai.USER_ID=ai2.user_id
and ai2.item_event ='FREE_RECOM_COUPON' 
and ai2.ACCT_TYPE=100
and ai2.ITEM_STATUS=10
and ai2.ADD_TIME >= @beginTime and ai2.ADD_TIME <= @endTime
and ai.ITEM_STATUS =10 AND ai.ITEM_EVENT in ('BUY_RECOM')    -- ('BUY_SERVICE','BUY_RECOM')
and ai.ADD_TIME >= @beginTime1 and ai.ADD_TIME <= @endTime1;



select concat(@beginTime1,'~',@endTime1)  '日期', count(distinct t.user_id) '继续使用人数' ,count(t.user_id) '继续使用次数' 
from forum.t_acct_items t 
inner join forum.t_user u on t.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='BUY_RECOM ' 
and t.ACCT_TYPE=100
and t.item_status=10
and t.add_time >= @beginTime1 
and t.add_time<= @endTime1;