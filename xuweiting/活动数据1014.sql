/*
select count(*) as '微信好友' from t_share_info t where t.SHARE_TYPE = 0 and status = 10;
select count(*) as '微信朋友圈' from t_share_info t where t.SHARE_TYPE = 1 and status = 10;
select count(*) as 'QQ' from t_share_info t where t.SHARE_TYPE = 2 and status = 10;
select count(*) as '新浪微博' from t_share_info t where t.SHARE_TYPE = 3 and status = 10;

select count(*) from t_share_info t group by t.share_type;

http://www.buyinball.com/v1/ny3G/game-byzq/user/login.html

活动编码: ACT_LOTTERY_OCT
*/



-- select * from t_activity limit 100 


set @param0='2016-10-12';
set @param1='2016-10-23 23:59:59';

-- PUUV
select t.PERIOD_NAME '日期',t.CHANNEL_NAME '活动',sum(PV) 活动页面PV,sum(UV) 活动页面UV 
from  report.t_rpt_h5_url_pv_uv t 
where t.PERIOD_TYPE=1 and t.CHANNEL_NAME='APP引流活动'
and t.PERIOD_NAME>=@param0 and t.PERIOD_NAME<=@param1
group by t.PERIOD_NAME;
-- 参与人数
select date_format(ta.APPLY_TIME,'%Y-%m-%d') '日期',count(distinct user_id) '参与人数',count(user_id) '参与人次' from forum.t_activity_apply ta
inner join forum.t_activity tc on ta.ACT_ID=tc.ACT_ID 
and tc.ACT_CODE='ACT_LOTTERY_OCT' 
and ta.APPLY_TIME>=@param0 and ta.APPLY_TIME<=@param1
group by date(ta.APPLY_TIME);

-- 分享次数

-- 分享次数
select date_format(ts.CRT_TIME,'%Y-%m-%d') '日期',
count(distinct if(ts.OBJ_TYPE='order',ts.user_id,null)) '订单分享人数',
count(distinct if(ts.OBJ_TYPE='recom',ts.user_id,null)) '推荐分享人数',
count(if(ts.OBJ_TYPE='order',ts.user_id,null)) '订单分享次数',
count(if(ts.OBJ_TYPE='recom',ts.user_id,null)) '推荐分享次数'
from forum.t_share_info ts 
where 
ts.`STATUS`=10 and
ts.OBJ_TYPE in ('order','recom') and
ts.CRT_TIME>=@param0 and ts.CRT_TIME<=@param1
group by date(ts.CRT_TIME)
;

/*
select date_format(ts.CRT_TIME,'%Y-%m-%d') '日期',
count(if(ts.OBJ_TYPE='order',ts.user_id,null)) '订单分享次数',
count(if(ts.OBJ_TYPE='recom',ts.user_id,null)) '推荐分享次数'
from forum.t_share_info ts 
inner join (
	select ta.user_id from forum.t_activity_apply ta 
	inner join forum.t_activity tc on ta.ACT_ID=tc.ACT_ID 
	and ta.APPLY_TIME>=@param0 and ta.APPLY_TIME<=@param1
	group by ta.user_id 
)tt on ts.user_id=tt.user_id 
where 
ts.`STATUS`=10 and 
ts.CRT_TIME>=@param0 and ts.CRT_TIME<=@param1
group by date(ts.CRT_TIME)
;
*/

-- 分享去处

select date_format(ts.CRT_TIME,'%Y-%m-%d') '日期',
count(if(ts.SHARE_TYPE=0,user_id,null)) '微信好友',
count(if(ts.SHARE_TYPE=1,user_id,null)) '微信朋友圈',
count(if(ts.SHARE_TYPE=2,user_id,null)) 'QQ',
count(if(ts.SHARE_TYPE=3,user_id,null)) '新浪微博'
from forum.t_share_info ts 
where 
ts.`STATUS`=10 and
ts.OBJ_TYPE in ('order','recom') and
ts.CRT_TIME>=@param0 and ts.CRT_TIME<=@param1
group by date(ts.CRT_TIME);



-- 抽奖数量

select date_format(ta.APPLY_TIME,'%Y-%m-%d') '日期',
count(if(taa.AWARD_NAME='谢谢参与',user_id,null)) '谢谢参与',
count(if(taa.AWARD_NAME='100金币',user_id,null)) '100金币',
count(if(taa.AWARD_NAME='300金币',user_id,null)) '300金币',
count(if(taa.AWARD_NAME='500金币',user_id,null)) '500金币',
count(if(taa.AWARD_NAME='10钻石',user_id,null)) '10钻石',
count(if(taa.AWARD_NAME='100京东卡',user_id,null)) '100京东卡',
count(if(taa.AWARD_NAME='500京东卡',user_id,null)) '500京东卡',
count(if(taa.AWARD_NAME='iPhone7',user_id,null)) 'iPhone7'
from forum.t_activity_apply ta 
inner join forum.t_activity tc on ta.ACT_ID=tc.ACT_ID
inner join forum.t_activity_award taa on ta.AWARD_ID = taa.AWARD_ID
where 
tc.ACT_CODE='ACT_LOTTERY_OCT' 
and ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=@param0 
and ta.APPLY_TIME<=@param1
group by date(ta.APPLY_TIME);
