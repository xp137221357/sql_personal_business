-- 足球数据
set @param0 = '2017-06-01'; 
set @param2 = '6月份';

select * from (
	select @param2 '时间','百盈竞猜',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
) t2 on 1=1;





