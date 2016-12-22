set @param0='2016-11-01 00:00:00';
set @param1='2016-11-30 23:59:59';


select concat(@param0,'~',@param1)'时间','未加状态',t.a '投注',t.b '返奖',round(t.b-t.a) '盈利' from (
select * from (
select sum(oi.ITEM_MONEY) a from game.t_order_item oi 
where oi.CHANNEL_CODE='YH' and oi.CRT_TIME>=@param0 and oi.CRT_TIME<=@param1) t1 
left join (
select sum(oi.PRIZE_MONEY) b from game.t_order_item oi 
where oi.CHANNEL_CODE='YH' and oi.BALANCE_TIME>=@param0 and oi.BALANCE_TIME<=@param1) t2 on 1=1
) t

union all

select concat(@param0,'~',@param1)'时间','加状态',t.a '投注',t.b '返奖',round(t.b-t.a) '盈利' from (
select * from (
select sum(oi.ITEM_MONEY) a from game.t_order_item oi 
where oi.CHANNEL_CODE='YH' and oi.CRT_TIME>=@param0 and oi.CRT_TIME<=@param1
and oi.ITEM_STATUS not in (-5, -10 ,210)) t1 
left join (
select sum(oi.PRIZE_MONEY) b from game.t_order_item oi 
where oi.CHANNEL_CODE='YH' and oi.BALANCE_TIME>=@param0 and oi.BALANCE_TIME<=@param1
and oi.ITEM_STATUS not in (-5, -10 ,210)) t2 on 1=1
) t
