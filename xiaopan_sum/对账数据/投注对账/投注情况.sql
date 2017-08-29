set @beginTime='2017-03-01 00:00:00';
set @endTime = '2017-04-10 23:59:59';

-- 足球
select 
t1.stat_time,
t1.bet_coins,
t1.bet_p_coins,
t2.return_coins,
t2.return_p_coins
from (
select date(oi.CRT_TIME) stat_time,
round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins
  from game.t_order_item oi
where  
oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime
group by stat_time
) t1
left join (
select date(oi.BALANCE_TIME) stat_time,
round(ifnull(sum(oi.COIN_PRIZE_MONEY),0)+ifnull(sum(oi.COIN_RETURN_MONEY),0)) return_coins,
round(ifnull(sum(oi.P_COIN_PRIZE_MONEY),0)+ifnull(sum(oi.P_COIN_RETURN_MONEY),0)) return_p_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
and oi.BALANCE_STATUS=20
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
group by stat_time
)t2 
on t1.stat_time=t2.stat_time
;



-- 篮球
-- t.item_status not in (-5,-10,210)

select 
t1.stat_time '时间',
t1.bet_coin_counts '金币投注人数',
t1.bet_free_counts '体验币投注人数',
t1.bet_coins '投注金币',
t1.bet_p_coins '投注体验币',
t2.return_coins '金币返奖',
t2.return_p_coins '体验币返奖'
from(
	select 
	date(o.CRT_TIME) stat_time,
	count(distinct if(t.COST_TYPE='1001',o.USER_ID,null)) bet_coin_counts,
	count(distinct if(t.COST_TYPE='1015',o.USER_ID,null)) bet_free_counts,
	round(ifnull(sum(if(t.COST_TYPE='1001',t.ITEM_MONEY,0)),0)) bet_coins,
	round(ifnull(sum(if(t.COST_TYPE='1015',t.ITEM_MONEY,0)),0)) bet_p_coins
	from wwgame_bk.t_ww_order_item o 
	inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
	inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
	where t.CRT_TIME>=@beginTime
	and t.CRT_TIME<=@endTime
	group by stat_time
)t1 
left join (
	select 
	date(o.BALANCE_TIME) stat_time,
	round(ifnull(sum(if(t.COST_TYPE='1001',t.PRIZE_MONEY,0)),0)+ifnull(sum(if(t.COST_TYPE='1001',t.RETURN_MONEY,0)),0)) return_coins,
	round(ifnull(sum(if(t.COST_TYPE='1015',t.PRIZE_MONEY,0)),0)+ifnull(sum(if(t.COST_TYPE='1015',t.RETURN_MONEY,0)),0)) return_p_coins
	from wwgame_bk.t_ww_order_item o 
	inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
	inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
	where t.BALANCE_TIME>=@beginTime
	and t.BALANCE_TIME<=@endTime
	and t.BALANCE_STATUS=20
	group by stat_time
) t2 on t1.stat_time=t2.stat_time
