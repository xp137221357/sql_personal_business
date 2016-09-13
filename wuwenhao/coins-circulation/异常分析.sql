set @beginTime='2016-08-12 00:00:00';
set @endTime = '2016-08-12 23:59:59';

-- 异样情况
select oi.PAY_TIME,oi.ITEM_STATUS,
oi.ITEM_MONEY,oi.PRIZE_MONEY,oi.RETURN_MONEY,
oi.COIN_BUY_MONEY,oi.COIN_PRIZE_MONEY,oi.COIN_RETURN_MONEY,
oi.P_COIN_BUY_MONEY,oi.P_COIN_PRIZE_MONEY,oi.P_COIN_RETURN_MONEY 
from game.t_order_item oi where oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.CHANNEL_CODE = 'GAME'
and oi.ITEM_STATUS not in (-5, -10 , 210) and ((ITEM_MONEY !=  COIN_BUY_MONEY + P_COIN_BUY_MONEY)or (PRIZE_MONEY!=COIN_PRIZE_MONEY+P_COIN_PRIZE_MONEY))
