set @beginTime='2016-06-19 00:00:00';
set @endTime = '2016-06-20 00:00:00';


/*新投注详情*/

select concat(@beginTime,'~',@endTime) '时间','大户投注详情',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_boss)) t1,(select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_boss)) t2

union all

select concat(@beginTime,'~',@endTime) '时间','新户投注详情',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime)) t1,(select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime)) t2

union all

select concat(@beginTime,'~',@endTime) '时间','留存用户投注详情',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_old where crt_time <@beginTime)) t1,(select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_old where crt_time <@beginTime)) t2;

/*新投注订单详情*/
select concat(@beginTime,'~',@endTime) '时间',
'大用户投注订单详情',
count(distinct oi.USER_ID) `投注人数`, count(1) `投注单数量`, round(sum(oi.ITEM_MONEY)) `投注金币`,round(sum(oi.ITEM_MONEY) / count(1)) `平均单订单金额`,
cast(count(1)  / count(distinct oi.USER_ID) as decimal(10,2)) `人均订单数`
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_boss)

union all

select concat(@beginTime,'~',@endTime) '时间',
'新用户投注订单详情',
count(distinct oi.USER_ID) `投注人数`, count(1) `投注单数量`, round(sum(oi.ITEM_MONEY)) `投注金币`,round(sum(oi.ITEM_MONEY) / count(1)) `平均单订单金额`,
cast(count(1)  / count(distinct oi.USER_ID) as decimal(10,2)) `人均订单数`
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime)

union all

select concat(@beginTime,'~',@endTime) '时间',
'留存用户投注订单详情',
count(distinct oi.USER_ID) `投注人数`, count(1) `投注单数量`, round(sum(oi.ITEM_MONEY)) `投注金币`,round(sum(oi.ITEM_MONEY) / count(1)) `平均单订单金额`,
cast(count(1)  / count(distinct oi.USER_ID) as decimal(10,2)) `人均订单数`
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_old where crt_time <@beginTime);



