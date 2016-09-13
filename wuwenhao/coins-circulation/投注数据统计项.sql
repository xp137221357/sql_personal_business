-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59

set @beginTime='2016-08-22 00:00:00';
set @endTime = '2016-08-28 23:59:59';

-- pass_type = 1001 为单关
-- item_type = 0,10 为未结算 或者结算时间 为空
-- inplay =0 为滚球

-- 金币投注返奖盈利
select 'P','金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t2

union all
-- 体验币币投注返奖盈利
select 'T','体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t2

union all
-- 投注汇总查询
select 'A','游戏币投注查询',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注游戏币',round(ifnull(t2.return_coins,0)) '返还游戏币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利游戏币'
from (select 
round(sum(ifnull(oi.ITEM_MONEY,0))) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.PRIZE_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t2
