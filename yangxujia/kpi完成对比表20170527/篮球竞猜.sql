set @param0 = '2017-05-01'; 
set @param1 = '2017-06-01';
set @param2 = '5月份';

select * from (
	select '新用户',@param2 '时间','篮球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	inner join forum.t_user u on o.user_id=u.USER_CODE and u.CRT_TIME>= @param0 and u.CRT_TIME< @param1
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.SPORT_TYPE='BB' 
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	inner join forum.t_user u on o.user_id=u.USER_CODE and u.CRT_TIME>= @param0 and u.CRT_TIME< @param1
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.SPORT_TYPE='BB' 
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
) t2 on 1=1;



select * from (
	select '老用户',@param2 '时间','篮球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	left join forum.t_user u on o.user_id=u.USER_CODE and u.CRT_TIME>= @param0 and u.CRT_TIME< @param1
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.SPORT_TYPE='BB' 
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and u.USER_ID is null
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	left join forum.t_user u on o.user_id=u.USER_CODE and u.CRT_TIME>= @param0 and u.CRT_TIME< @param1
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.SPORT_TYPE='BB' 
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and u.USER_ID is null
) t2 on 1=1;


