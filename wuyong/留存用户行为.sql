set @beginTime = '2016-06-10';
set @endTime = '2016-07-06';

/*--------------------------------------------- 
  留存用户
*/

## 留存用户 -- 投注留存用户投注行为

select concat(@beginTime,'~',@endTime) '时间','留存用户-继续投注行为', DATE(o.CRT_TIME), COUNT(DISTINCT x.USER_ID)
FROM t_stat_user_first_bet_time x
INNER JOIN game.t_order_item o ON (o.USER_ID = x.USER_CODE and o.CHANNEL_CODE = 'GAME')
WHERE
  o.CRT_TIME >= @beginTime and o.CRT_TIME < @endTime
 AND x.CRT_TIME < @beginTime
GROUP BY DATE(o.CRT_TIME)
;

## 留存用户 -- 投注留存用户充值行为

select concat(@beginTime,'~',@endTime) '时间','留存用户-继续充值行为','日期', COUNT(DISTINCT x.USER_ID)
FROM t_stat_user_first_bet_time x
INNER JOIN forum.t_acct_items i ON x.USER_ID = i.USER_ID AND i.ITEM_STATUS = 10 AND i.ITEM_EVENT = 'BUY_DIAMEND' 
WHERE
	 i.ADD_TIME < @beginTime 
	AND x.CRT_TIME < @beginTime

;

## 留存用户 - 投注留存用户无投注行为
select concat(@beginTime,'~',@endTime) '时间','留存用户-无投注行为', COUNT(DISTINCT x.USER_ID)
FROM t_stat_user_first_bet_time x
WHERE
  x.USER_CODE not in (select user_id from game.t_order_item o where o.CHANNEL_CODE = 'GAME' 
  and o.CRT_TIME >= @beginTime and o.CRT_TIME < @endTime) 
  AND x.CRT_TIME < @beginTime;


## 留存用户 - 投注留存用户无投注行为,继续启动app 
select concat(@beginTime,'~',@endTime) '时间','留存用户-无投注行为-继续启动app ', COUNT(DISTINCT x.USER_ID)
FROM t_stat_user_first_bet_time x
inner join forum.t_device_statistic td on x.USER_CODE = td.USER_CODE and td.STAT_TYPE = 1
and td.CRT_TIME >= @beginTime and td.CRT_TIME < @endTime
WHERE
  x.USER_CODE not in (select user_id from game.t_order_item o where o.CHANNEL_CODE = 'GAME' 
  and o.CRT_TIME >= @beginTime and o.CRT_TIME < @endTime) 
  AND x.CRT_TIME < @beginTime;

  
  
  
