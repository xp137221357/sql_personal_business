set @beginTime='2016-08-20 00:00:00';
set @endTime = '2016-08-23 23:59:59';
-- 赛事节点


-- 赛前主客队投注情况

-- 必发指数

select 
date(m.MATCH_TIME) stat_time,
m.MATCH_ID,
te.HOME_GOAL_NUM,
te.AWAY_GOAL_NUM,
round(sum(oi.COIN_BUY_MONEY)) bet_coins,
round(sum(oi.P_COIN_BUY_MONEY)) bet_p_coins,
round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
round(sum(oi.P_COIN_PRIZE_MONEY)) return_P_coins,
round(sum(oi.COIN_BUY_MONEY)+sum(oi.P_COIN_BUY_MONEY)) bet_all_coins,
round(sum(oi.COIN_PRIZE_MONEY)+sum(oi.P_COIN_PRIZE_MONEY)) return_all_coins
from game.t_order_item oi
inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
inner join fb_main.t_match_ext te on m.MATCH_ID=te.MATCH_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and BALANCE_STATUS=20 and  oi.PASS_TYPE=1001 and inplay =1
and m.MATCH_TIME >= @beginTime
and m.MATCH_TIME <= @endTime
group by m.MATCH_ID;