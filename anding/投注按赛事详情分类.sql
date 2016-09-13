set @beginTime='2016-08-20 00:00:00';
set @endTime = '2016-08-23 23:59:59';
set @passType = 1001;
set @itemType = (0,10);
set @inPlay=0;
set @channel = 'GAME';

-- pass_type = 1001 为单关
-- ITEM_STATUS = 0,10 为未结算 或者结算时间 为空
-- inplay =0 为滚球

-- 区间内投注(比赛时间在区间内) (game.t_order_item与fb_main.t_match  ON oi.balance_match_id=m.MATCH_ID)
-- 区间外投注(比赛时间在区间外)
.
-- 一花*0.004，口袋*0.006，百赢
-- 需要通过比赛时间来定

-- 按比赛的时间，结算推迟两小时

-- 已金币为例子(*)
-- ----------------------------------------------------------------------------------------------------------------
        

-- 赛事节点

select 
date(m.MATCH_TIME) stat_time,
-- round(sum(oi.COIN_BUY_MONEY)) bet_coins,
-- round(sum(oi.P_COIN_BUY_MONEY)) bet_coins,
-- round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
-- round(sum(oi.P_COIN_PRIZE_MONEY)) return_coins,
round(sum(oi.COIN_BUY_MONEY)+sum(oi.P_COIN_BUY_MONEY)) bet_coins,
round(sum(oi.COIN_PRIZE_MONEY)+sum(oi.P_COIN_PRIZE_MONEY)) return_coins
from game.t_order_item oi
 inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PASS_TYPE=1001 -- 单关
and m.MATCH_TIME >= date_add(@beginTime, interval -2 hour)
and m.MATCH_TIME <= date_add(@endTime, interval -2 hour)
group by stat_time;

-- 时间节点

select 
t1.stat_time,
t1.bet_coins,
t2.return_coins
from (select date(oi.CRT_TIME) stat_time,
-- round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
-- round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins,
 round(sum(ifnull(oi.COIN_BUY_MONEY,0))+sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
  from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PASS_TYPE=1001 -- 单关
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME <= @endTime
group by stat_time) t1
left join (select date(oi.CRT_TIME) stat_time,
-- round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins,
-- round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_coins,
 round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))+sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PASS_TYPE=1001
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
group by stat_time)t2 
on t1.stat_time=t2.stat_time
;

-- --------------------------------------------------------------------------------------------------------------

-- 区间内投注

select date('')


select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PASS_TYPE=1001 -- 单关
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime
and m.MATCH_TIME>= @beginTime and m.MATCH_TIME <= @endTime;

-- 区间外投注
select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PASS_TYPE=1001 -- 单关
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime
and m.MATCH_TIME > @endTime;

-- 已结算
select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (0,10,-5, -10 , 210) and oi.PASS_TYPE=1001 -- 单关
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime;

-- 未结算
select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PASS_TYPE=1001 -- 单关
and oi.ITEM_STATUS in (0,10)
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime;



