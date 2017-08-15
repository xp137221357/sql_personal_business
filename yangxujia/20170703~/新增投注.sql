set @param0 = '2017-07-01'; 
set @param1 = '7月份';

select * from (
	select @param1 '时间',
	count(distinct o.USER_ID) first_bet_counts,
	round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
	and tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
) t1
left join (
	
	select 
	round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) first_prize_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
	and tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
)t2 on 1=1