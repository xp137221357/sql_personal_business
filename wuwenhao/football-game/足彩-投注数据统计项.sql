
-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59
-- 足球竞猜
set @beginTime='2016-06-11 00:00:00';
set @endTime = '2016-07-11 23:59:59';

-- SELECT oi.CHANNEL_CODE from game.t_order_item oi GROUP BY oi.CHANNEL_CODE

-- (非BYAPP的渠道计算规则)
-- GAME(BYAPP),KD(KD),YH(YH) 3个渠道（选所有时就这几个渠道，另外需要计算规则）

-- 金币投注返奖盈利
select 'P','其他渠道金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('YH','KD') 
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.PRIZE_MONEY,0)+ifnull(oi.RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('YH','KD') 
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2


UNION ALL

-- 金币投注返奖盈利
select 'P','金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('GAME') 
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('GAME')
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('GAME')
 and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('GAME')
 and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2;

-- 投注订单
select 'A','投注订单',concat(@beginTime,'~',@endTime) '时间','all',
count(distinct oi.USER_ID) `投注人数`, count(1) `投注单数量`, round(sum(oi.ITEM_MONEY)) `投注金币`,round(sum(oi.ITEM_MONEY) / count(1)) `平均单订单金币`,
cast(count(1)  / count(distinct oi.USER_ID) as decimal(10,2)) `人均订单数`
from game.t_order_item oi
where oi.CHANNEL_CODE in ('GAME')
and oi.ITEM_STATUS not in (-5, -10, 210) and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
