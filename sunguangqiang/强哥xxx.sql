set @beginTime:='2016-05-09 00:00:00';
set @endTime:='2016-07-17 23:59:59';


-- 当天
SELECT     date(bt.crt_time),
date(td.crt_time),
           Count(DISTINCT bt.user_id) RETAINTION_COUNT
FROM       forum.t_user bt
inner join t_trans_user_attr ta on bt.USER_ID = ta.USER_ID and bt.CLIENT_ID = 'BYAPP' and bt.status = '10'
INNER JOIN forum.t_device_statistic td
ON         bt.user_code = td.user_code
AND        td.stat_type = 1
AND        td.crt_time >= @beginTime
AND        td.crt_time <= @endTime
and        bt.crt_time>=@beginTime
AND        bt.crt_time<=@endTime
and date(td.crt_time) = date(bt.crt_time)
group by date(bt.crt_time),date(td.crt_time);

-- 次日
SELECT     date(bt.crt_time),
date(td.crt_time),
           Count(DISTINCT bt.user_id) RETAINTION_COUNT
FROM       forum.t_user bt
inner join t_trans_user_attr ta on bt.USER_ID = ta.USER_ID and bt.CLIENT_ID = 'BYAPP' and bt.status = '10'
INNER JOIN forum.t_device_statistic td
ON         bt.user_code = td.user_code
AND        td.stat_type = 1
AND        td.crt_time >= @beginTime
AND        td.crt_time <= @endTime
and        bt.crt_time>=@beginTime
AND        bt.crt_time<=@endTime
and date(td.crt_time) = date_add(date(bt.crt_time),interval 1 day)
group by date(bt.crt_time),date(td.crt_time);

-- 一周后
SELECT     date(bt.crt_time),
date(td.crt_time),
           Count(DISTINCT bt.user_id) RETAINTION_COUNT
FROM       forum.t_user bt
inner join t_trans_user_attr ta on bt.USER_ID = ta.USER_ID and bt.CLIENT_ID = 'BYAPP' and bt.status = '10'
INNER JOIN forum.t_device_statistic td
ON         bt.user_code = td.user_code
AND        td.stat_type = 1
AND        td.crt_time >= @beginTime
AND        td.crt_time <= @endTime
and        bt.crt_time>=@beginTime
AND        bt.crt_time<=@endTime
and date(td.crt_time) = date_add(date(bt.crt_time),interval 7 day)
group by date(bt.crt_time),date(td.crt_time);

-- 一月后
SELECT     date(bt.crt_time),
date(td.crt_time),
           Count(DISTINCT bt.user_id) RETAINTION_COUNT
FROM       forum.t_user bt
inner join t_trans_user_attr ta on bt.USER_ID = ta.USER_ID and bt.CLIENT_ID = 'BYAPP' and bt.status = '10'
INNER JOIN forum.t_device_statistic td
ON         bt.user_code = td.user_code
AND        td.stat_type = 1
AND        td.crt_time >= @beginTime
AND        td.crt_time <= @endTime
and        bt.crt_time>=@beginTime
AND        bt.crt_time<=@endTime
and date(td.crt_time) = date_add(date(bt.crt_time),interval 30 day)
group by date(bt.crt_time),date(td.crt_time);