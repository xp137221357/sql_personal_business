
-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59

set @beginTime='2016-08-15 00:00:00';
set @endTime = '2016-08-21 23:59:59';
-- 免费用户-新增：查询时间段内注册且未充值的投注用户数
-- 免费用户-留存：查询时间段之前注册且未充值的投注用户数
-- 充值用户-留存：查询时间段之前注册且有充值历史的投注用户数
-- 充值用户-新增：查询时间段内注册并充值的投注用户数

-- 首次充值只统计了官方的
-- 新增
/*
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
*/

-- *选择无的时候，应该增加家条件 ，去掉and tt.value_type 并且增加 where  U.USER_ID is null
-- *选择全部的时候，应该整个过滤条件去掉

-- 这部分只针对BYAPP注册且投注的用户

-- 免费用户-留存
select '免费用户-留存',count(distinct U.user_id) '留存投注总数',count(distinct tt.charge_user_id) '留存投注且充值人数' from forum.t_user u 
inner join game.t_order_item tf on U.user_CODE = tf.user_ID  and u.CRT_TIME<@beginTime  AND u.CLIENT_ID = 'BYAPP' 
AND TF.CHANNEL_CODE = 'GAME' and TF.ITEM_STATUS not in (-5, -10 , 210)
and tf.CRT_TIME>=@beginTime and tf.CRT_TIME<=@endTime
left join(
SELECT t.charge_user_id,
       t.crt_time,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 1000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 1000
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 4
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 5
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 6
     end                             AS value_type,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID -- and tt.value_type = 5

union all

-- 充值用户-新增
select '充值用户-新增',count(distinct U.user_id) '新增投注总数',count(distinct tfc.charge_user_id) '新增投注且充值人数' from forum.t_user u 
inner join game.t_order_item tf on U.user_CODE = tf.user_ID and u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime  and u.CLIENT_ID = 'BYAPP' 
AND TF.CHANNEL_CODE = 'GAME' and TF.ITEM_STATUS not in (-5, -10 , 210)
and tf.CRT_TIME>=@beginTime and tf.CRT_TIME<=@endTime
left join(
SELECT t.charge_user_id,
       t.crt_time,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 1000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 1000
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 4
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 5
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 6
     end                             AS value_type,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID  -- and tt.value_type = 5
left join 
(select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id) tfc on tt.charge_user_id = tfc.charge_user_id
and tfc.CRT_TIME>=@beginTime and tfc.CRT_TIME<=@endTime;



