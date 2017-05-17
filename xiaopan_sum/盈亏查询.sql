

set @param0 = '2017-04-01'; 
set @param1 = '2017-04-16';
-- 足球盈亏
select (t1.bet_coins-t2.prize_coins)/139 from (
select round(sum(o.COIN_BUY_MONEY)) bet_coins 
from game.t_order_item o 
where o.PAY_TIME>=@param0
and o.PAY_TIME<@param1)t1,
(select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coins 
from game.t_order_item o 
where o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<@param1) t2

-- 篮球盈亏
select (t1.bet_coins-t2.prize_coins)/139 from (
select round(sum(t.ITEM_MONEY)) bet_coins
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
where t.CRT_TIME>=@param0
and t.CRT_TIME<@param1
and t.COST_TYPE=1001)t1,
(select round(ifnull(sum(t.PRIZE_MONEY),0)+ifnull(sum(t.RETURN_MONEY),0)) prize_coins
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
where t.BALANCE_TIME>=@param0
and t.BALANCE_TIME<@param1
and t.COST_TYPE=1001)t2;




select * from t_rpt_overview t where t.CHANNEL_NO='apple_cl' and t.PERIOD_TYPE=1 order by t.PERIOD_NAME desc limit 100;


select * from t_device_channel t where t.CHANNEL_NAME like '%创联%';