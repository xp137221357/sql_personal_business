set @beginTime='2017-04-02 00:00:00';
set @endTime = '2017-04-02 23:59:59';

-- 足球
select * from game.t_order_item o 
left join forum.t_acct_items ai1 on o.ORDER_ID=ai1.TRADE_NO
and ai1.PAY_TIME>=@beginTime
and ai1.PAY_TIME<=@endTime
and ai1.ITEM_EVENT='trade_coin'
left join forum.t_acct_items ai2 on o.ITEM_ID=ai2.TRADE_NO
and ai2.PAY_TIME>=@beginTime
and ai2.PAY_TIME<=@endTime
and ai2.ITEM_EVENT='prize_coin'
where o.PAY_TIME>=@beginTime
and o.PAY_TIME<=@endTime
and ai1.TRADE_NO is null
and ai2.TRADE_NO is null;

select * from game.t_order_item o 
left join forum.t_acct_items ai on o.ITEM_ID=ai.TRADE_NO
and ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
and ai.ITEM_EVENT='prize_coin'
where o.PAY_TIME>=@beginTime
and o.PAY_TIME<=@endTime
and ai.TRADE_NO is null;



select * from game.t_order_item o 
left join forum.t_acct_items ai on o.ITEM_ID=ai.TRADE_NO
and ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
where o.BALANCE_TIME>=@beginTime
and o.BALANCE_TIME<=@endTime
and ai.TRADE_NO is null;

-- 篮球
select 
*
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
left join forum.t_acct_items ai on o.ITEM_ID=ai.TRADE_NO
and ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
where t.CRT_TIME>=@beginTime
and t.CRT_TIME<=@endTime
and ai.TRADE_NO is null;

select 
*
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
left join forum.t_acct_items ai on o.ITEM_ID=ai.TRADE_NO
and ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
where t.BALANCE_TIME>=@beginTime
and t.BALANCE_TIME<=@endTime
and ai.TRADE_NO is null;
