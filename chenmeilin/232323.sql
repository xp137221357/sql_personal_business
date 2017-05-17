

set @param0='2017-04-24 12:00:00';
set @param1='2017-05-01 11:59:59';


select sum(o.COIN_BUY_MONEY) bet_coins from game.t_order_item o 
where o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.CHANNEL_CODE in ('game')
;


select ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) return_coins bet_coins from game.t_order_item o 
where o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<=@param1
and o.CHANNEL_CODE in ('game')
;