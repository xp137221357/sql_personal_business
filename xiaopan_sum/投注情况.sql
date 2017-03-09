set @beginTime='2017-01-10 00:00:00';
set @endTime = '2017-01-10 23:59:59';

select 
t1.stat_time,
t1.bet_coins,
t1.bet_p_coins,
t1.bet_all_coins,
t2.return_coins,
t2.return_p_coins,
t2.return_all_coins
from (
select date(oi.CRT_TIME) stat_time,
round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins,
 round(sum(ifnull(oi.COIN_BUY_MONEY,0))+sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_all_coins
  from game.t_order_item oi
where  
oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS -- not in (-5, -10 , 210)
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime
group by stat_time
) t1
left join (
select date(oi.BALANCE_TIME) stat_time,
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins,
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_p_coins,
 round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))+sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_all_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' -- and oi.ITEM_STATUS not in (-5, -10 , 210) 
and oi.BALANCE_STATUS=20
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
group by stat_time
)t2 
on t1.stat_time=t2.stat_time
;