-- ll
-- '2016-06-12 00:00:00'~'2016-07-12 23:59:59'
-- '2016-07-13 00:00:00'~'2016-08-28 23:59:59'
-- '2016-08-29 00:00:00'~'2016-09-02 12:00:00'
set @beginTime = '2016-06-10 00:00:00';
set @endTime = '2016-07-12 23:59:59';

-- 投注人数
select concat(@beginTime,'~',@endTime) '时间',
'APP-投注人数',
count(distinct oi.USER_ID) `投注人数`
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime;

-- 其中充值人数

select concat(@beginTime,'~',@endTime) '时间',
'投注中的充值人数',
count(distinct oi.USER_ID) `充值人数`
from game.t_order_item oi
inner join report.t_trans_user_attr tu on oi.USER_ID=tu.USER_CODE
inner join (
  select * from (
  select tc.charge_user_id from report.t_trans_user_recharge_coin tc
  where tc.crt_time >= @beginTime and tc.crt_time <= @endTime
  )tt
  group by tt.charge_user_id
) t on tu.USER_ID = t.charge_user_id 
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime


-- 留存
set @beginTime0 = '2016-06-10 00:00:00';
set @endTime0 = '2016-07-12 23:59:59';
set @beginTime1 = '2016-07-13 00:00:00';
set @endTime1 = '2016-08-28 23:59:59';
set @beginTime2 = '2016-08-29 00:00:00';
set @endTime2 = '2016-09-01 23:59:59';
-- 投注人数

SELECT     Concat(@begintime0,'~',@endtime0) '时间',
           'APP-投注人数',
           count(DISTINCT t1.user_id) `投注人数`
FROM       (
                    SELECT   oi.user_id
                    FROM     game.t_order_item oi
                    WHERE    oi.channel_code = 'GAME'
                    AND      oi.item_status NOT IN (-5,
                                                    -10,
                                                    210)
                    AND      oi.crt_time >= @beginTime0
                    AND      oi.crt_time < @endTime0
                    GROUP BY oi.user_id) t1
INNER JOIN
           (
                    SELECT   oi.user_id
                    FROM     game.t_order_item oi
                    WHERE    oi.channel_code = 'GAME'
                    AND      oi.item_status NOT IN (-5,
                                                    -10,
                                                    210)
                    AND      oi.crt_time >= @beginTime1
                    AND      oi.crt_time < @endTime1
                    GROUP BY oi.user_id) t2
ON         t1.user_id = t2.user_id;



SELECT     Concat(@begintime,'~',@endtime) '时间',
           '投注中的充值人数',
           count(DISTINCT tu.user_id) `充值人数`
FROM       (
                    SELECT   oi.user_id
                    FROM     game.t_order_item oi
                    WHERE    oi.channel_code = 'GAME'
                    AND      oi.item_status NOT IN (-5,
                                                    -10,
                                                    210)
                    AND      oi.crt_time >= @beginTime
                    AND      oi.crt_time < @endTime
                    GROUP BY oi.user_id) t
INNER JOIN report.t_trans_user_attr tu
ON         t.user_id=tu.user_code
INNER JOIN
           (
                    SELECT   tc.charge_user_id
                    FROM     report.t_trans_user_recharge_coin tc
                    WHERE    tc.crt_time >= @beginTime0
                    AND      tc.crt_time <= @endTime0
                    GROUP BY tc.charge_user_id) t2
ON         tu.user_id = t2.charge_user_id
INNER JOIN
           (
                    SELECT   tc.charge_user_id
                    FROM     report.t_trans_user_recharge_coin tc
                    WHERE    tc.crt_time >= @beginTime1
                    AND      tc.crt_time <= @endTime1
                    GROUP BY tc.charge_user_id) t3
ON         tu.user_id = t3.charge_user_id

