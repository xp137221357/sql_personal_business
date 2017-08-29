set @param0='2017-04-02';
set @param1='2017-04-02 23:59:59';

-- acct 账单
select date(ai.PAY_TIME) stat_time,
round(sum(if(ai.CHANGE_TYPE=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,0))) prize_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE))) profit_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>='2017-04-02'
and ai.PAY_TIME<='2017-04-02 23:59:59'
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in 
('TRADE_COIN','PRIZE_COIN','PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY')
and ai.ITEM_STATUS in (10,-10)
group by stat_time;


-- game 订单
select t1.stat_time,t1.bet_coins,t2.prize_coins,t1.bet_coins-t2.prize_coins profit_coins from (
select date(o.PAY_TIME) stat_time,round(sum(o.COIN_BUY_MONEY)) bet_coins from game.t_order_item o 
where o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.channel_code in ('game','jrtt-jingcai')
group by stat_time
) t1
left join (
select date(o.BALANCE_TIME) stat_time,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins 
from game.t_order_item o 
where o.BALANCE_TIME>='2017-04-02'
and o.BALANCE_TIME<='2017-04-02 23:59:59'
and o.channel_code in ('game','jrtt-jingcai')
group by stat_time
)t2 on t1.stat_time=t2.stat_time
;


