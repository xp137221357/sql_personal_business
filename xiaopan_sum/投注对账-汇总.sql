set @day_time='2017-06-16';

-- 足球
select '足球',date(ai.PAY_TIME) stat_time,
round(sum(if(ai.CHANGE_TYPE=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,0))) prize_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in 
('TRADE_COIN','PRIZE_COIN')
and ai.ITEM_STATUS in (10,-10)
group by stat_time

union all

-- 篮球
select '篮球',date(ai.PAY_TIME) stat_time,
round(sum(if(ai.CHANGE_TYPE=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,0))) prize_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in 
('BK_TRADE_COIN','BK_PRIZE_COIN')
and ai.ITEM_STATUS in (10,-10)
group by stat_time


union all

-- PK场
select 'PK场',date(ai.PAY_TIME) stat_time,
round(sum(if(ai.CHANGE_TYPE=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,0))) prize_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in 
('PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY')
and ai.ITEM_STATUS in (10,-10)
group by stat_time

union all

-- 异常
select '异常',date(ai.PAY_TIME) stat_time,
round(sum(if(ai.CHANGE_TYPE=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,0))) prize_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in 
('EX_PRIZE_COIN','BK_EX_PRIZE_COIN')
and ai.ITEM_STATUS in (10,-10)
group by stat_time;


-- game 订单
-- 足球

select '足球',t1.stat_time,t1.bet_coins,t2.prize_coins from (
select date(o.PAY_TIME) stat_time,round(sum(o.COIN_BUY_MONEY)) bet_coins from game.t_order_item o 
where o.PAY_TIME>=@day_time
and o.PAY_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
group by stat_time
) t1
left join (
select date(o.BALANCE_TIME) stat_time,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins 
from game.t_order_item o 
where o.BALANCE_TIME>=@day_time
and o.BALANCE_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
group by stat_time
)t2 on t1.stat_time=t2.stat_time


union all


-- 篮球
select '篮球',t1.stat_time,t1.bet_coins,t2.prize_coins from (
select date(o.PAY_TIME) stat_time,round(sum(o.COIN_BUY_MONEY)) bet_coins from game.t_order_item o 
where o.PAY_TIME>=@day_time
and o.PAY_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
group by stat_time
) t1
left join (
select date(o.BALANCE_TIME) stat_time,round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins 
from game.t_order_item o 
where o.BALANCE_TIME>=@day_time
and o.BALANCE_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
group by stat_time
)t2 on t1.stat_time=t2.stat_time;


-- ---------------------------------------------------------------------------------------------------------------
-- 投注明细对账
-- ---------------------------------------------------------------------------------------------------------------

-- game与forum用户投注对账
-- game
select * from (
select concat(o.USER_ID,'_'),round(sum(o.COIN_BUY_MONEY)) bet_coins 
from game.t_order_item o 
where o.PAY_TIME>=@day_time
and o.PAY_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
group by o.USER_ID asc
) t ;

select * from (
select concat(o.USER_ID,'_'),round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) prize_coins 
from game.t_order_item o 
where o.BALANCE_TIME>=@day_time
and o.BALANCE_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
group by o.USER_ID asc
) t where t.prize_coins>0;

-- forum
select * from (
select 
concat(ai.ACCT_ID,'_'),
round(sum(ai.CHANGE_VALUE)) bet_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=1 -- 0返奖，1投注
and ai.ITEM_EVENT in 
-- ('TRADE_COIN','PRIZE_COIN','PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY')
('TRADE_COIN','PRIZE_COIN')
and ai.ITEM_STATUS in (10,-10)
group by ai.ACCT_ID asc
) t where t.bet_coins>0;

select * from (
select 
concat(ai.ACCT_ID,'_'),
round(sum(ai.CHANGE_VALUE)) prize_coins
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0 -- 0返奖，1投注
and ai.ITEM_EVENT in 
-- ('TRADE_COIN','PRIZE_COIN','PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY')
('TRADE_COIN','PRIZE_COIN')
and ai.ITEM_STATUS in (10,-10)
group by ai.ACCT_ID asc
) t where t.prize_coins>0;


-- 明细对比
set @day_time='2017-07-09';
-- 投注
-- game
select * from (
select concat(o.USER_ID,'_'),o.COIN_BUY_MONEY,o.ITEM_ID,o.ORDER_ID
from game.t_order_item o 
where o.PAY_TIME>=@day_time
and o.PAY_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.user_id='4826319022900086991'
and o.COIN_BUY_MONEY>0
) t ;

-- forum
select * from forum.t_acct_items ai 
where ai.ACCT_ID='4826319022900086991'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ITEM_EVENT='TRADE_COIN'
;


-- 返奖
-- game
select * from (
select concat(o.USER_ID,'_'),o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,o.ITEM_ID,o.ORDER_ID
from game.t_order_item o 
where o.BALANCE_TIME>=@day_time
and o.BALANCE_TIME<=concat(@day_time,' 23:59:59')
and o.channel_code in ('game','jrtt-jingcai')
and o.user_id='4826319022900086991'
) t where t.COIN_PRIZE_MONEY>0 or t.COIN_RETURN_MONEY >0;

-- forum
select * from forum.t_acct_items ai 
where ai.ACCT_ID='4826319022900086991'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>=@day_time
and ai.PAY_TIME<=concat(@day_time,' 23:59:59')
and ai.ITEM_EVENT='prize_COIN'
;

-- 订单差异查询
-- select * from  game.t_order_item o where o.ITEM_ID='7c582dada6a740afa4dcb975164f081c' or o.ORDER_ID='7c582dada6a740afa4dcb975164f081c';
-- select * from  forum.t_acct_items ai where ai.TRADE_NO like '%7c582dada6a740afa4dcb975164f081c%';
