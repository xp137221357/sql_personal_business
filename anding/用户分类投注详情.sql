set @beginTime='2016-08-01 00:00:00';
set @endTime = '2016-08-07 23:59:59';
-- --------------------------------新用户
select 'P','新增注册用户金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME>=@beginTime and tu.CRT_TIME<=@endTime
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME>=@beginTime and tu.CRT_TIME<=@endTime
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','新增注册用户体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME>=@beginTime and tu.CRT_TIME<=@endTime
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME>=@beginTime and tu.CRT_TIME<=@endTime
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all

-- ----------------------------------------留存用户
select 'P','留存金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME<=@beginTime and tu.USER_ID not in (select user_id from test.new_user_boss)
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME<=@beginTime and tu.USER_ID not in (select user_id from test.new_user_boss)
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','留存体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME<=@beginTime and tu.USER_ID not in (select user_id from test.new_user_boss)
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join forum.t_user tu on tu.USER_CODE=oi.USER_ID and tu.CLIENT_ID= 'BYAPP' AND tu.CRT_TIME<=@beginTime and tu.USER_ID not in (select user_id from test.new_user_boss)
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- -------------------------------------vip用户
select 'P','vip金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join test.new_user_boss tb on tb.USER_CODE=oi.USER_ID 
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join test.new_user_boss tb on tb.USER_CODE=oi.USER_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','vip体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 inner join test.new_user_boss tb on tb.USER_CODE=oi.USER_ID 
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join test.new_user_boss tb on tb.USER_CODE=oi.USER_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all

-- -------------------------------------- 大户
select 'P','大户金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins>280000
 and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins>280000
 and 
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','大户体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins>280000
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins>280000
 and ti.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2


-- -------------------------------------- 普通用户
select 'P','普通用户金币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins<280000
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins<280000
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

union all
-- 体验币币投注返奖盈利
select 'T','普通用户体验币投注详情',concat(@beginTime,'~',@endTime) '时间','all',round(ifnull(t1.bet_coins,0)) '投注体验币',round(ifnull(t2.return_coins,0)) '返还体验币',
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利体验币'
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins<280000
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
 inner join (select user_id,sum(oi.bet_coins) bet_coins from game.t_order_item oi ) ti on ti.user_id = oi.USER_ID and ti.bet_coins<280000
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
) t2

-- 大户
select tt.charge_user_id,sum(tt.rmb_value) rmb_value from (
SELECT tc.charge_method,
       tc.charge_user_id,
       tc.rmb_value
FROM   t_trans_user_recharge_coin tc
UNION ALL
SELECT td.charge_method,
       td.charge_user_id,
       td.rmb_value
FROM   t_trans_user_recharge_diamond td
) tt where rmb_value>2000
group by tt.charge_user_id limit 100