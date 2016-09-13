set @beginTime = '2016-06-10';
set @tempTime1 = '2016-06-11';
set @tempTime2 = '2016-06-12';
set @tempTime3 = '2016-06-13';
set @tempTime4 = '2016-06-14';
set @tempTime5 = '2016-06-15';
set @tempTime6 = '2016-06-16';
set @tempTime7 = '2016-06-17';
set @tempTime8 = '2016-06-18';

SELECT 
 @beginTime,'留存用户-投注留存用户投注行为', DATE(o.CRT_TIME), COUNT(DISTINCT x.USER_ID)
FROM t_stat_user_first_bet_time x
INNER JOIN game.t_order_item o ON (o.USER_ID = x.USER_CODE and o.CHANNEL_CODE = 'GAME' and o.CRT_TIME >= @beginTime and o.CRT_TIME < @tempTime1)
INNER JOIN game.t_order_item o1 ON (o1.USER_ID = x.USER_CODE and o1.CHANNEL_CODE = 'GAME' and o1.CRT_TIME >= @tempTime1 and o1.CRT_TIME < @tempTime2)
INNER JOIN game.t_order_item o2 ON (o2.USER_ID = x.USER_CODE and o2.CHANNEL_CODE = 'GAME' and o2.CRT_TIME >= @tempTime2 and o2.CRT_TIME < @tempTime3)
-- INNER JOIN game.t_order_item o3 ON (o3.USER_ID = x.USER_CODE and o3.CHANNEL_CODE = 'GAME' and o3.CRT_TIME >= @tempTime3 and o3.CRT_TIME < @tempTime4)
-- INNER JOIN game.t_order_item o4 ON (o4.USER_ID = x.USER_CODE and o4.CHANNEL_CODE = 'GAME' and o4.CRT_TIME >= @tempTime4 and o4.CRT_TIME < @tempTime5)
-- INNER JOIN game.t_order_item o5 ON (o5.USER_ID = x.USER_CODE and o5.CHANNEL_CODE = 'GAME' and o5.CRT_TIME >= @tempTime5 and o5.CRT_TIME < @tempTime6)
WHERE
 x.CRT_TIME < @beginTime

GROUP BY DATE(o.CRT_TIME)