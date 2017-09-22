-- 竞猜消耗

set @param0 = '2017-08-01'; 
set @param2 = '8月份';

select * from (
	select '新增百盈用户',@param2 '时间','百盈足球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	inner join report.t_stat_user_first_bet_time t on o.user_id=t.USER_CODE and t.CRT_TIME>=@param0 and t.CRT_TIME<date_add(@param0,interval 1 month)
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	inner join report.t_stat_user_first_bet_time t on o.user_id=t.USER_CODE and t.CRT_TIME>=@param0 and t.CRT_TIME<date_add(@param0,interval 1 month)
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game')
) t2 on 1=1;

select * from (
	select '新增代理用户',@param2 '时间','百盈足球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	inner join report.t_stat_user_first_bet_time t on o.user_id=t.USER_CODE and t.CRT_TIME>=@param0 and t.CRT_TIME<date_add(@param0,interval 1 month)
	inner join game.t_group_ref tf on o.user_id=tf.USER_ID and o.PAY_TIME>tf.add_time
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	inner join report.t_stat_user_first_bet_time t on o.user_id=t.USER_CODE and t.CRT_TIME>=@param0 and t.CRT_TIME<date_add(@param0,interval 1 month)
	inner join game.t_group_ref tf on o.user_id=tf.USER_ID and o.PAY_TIME>tf.add_time
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game')
) t2 on 1=1;












