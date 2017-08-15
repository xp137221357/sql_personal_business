-- 足球数据
set @param0 = '2017-07-01'; 
set @param2 = '7月份';



select * from (
	select @param2 '时间','KD,YH百盈竞猜',count(distinct o.user_id) '投注人数',
	round(sum(if(o.CHANNEL_CODE='KD',o.ITEM_MONEY*0.006,o.ITEM_MONEY*0.006))) '金币投注',
	round(ifnull(sum(if(o.CHANNEL_CODE='KD',o.PRIZE_MONEY*0.006,o.PRIZE_MONEY*0.006)),0)
	+ifnull(sum(if(o.CHANNEL_CODE='KD',o.RETURN_MONEY*0.006,o.RETURN_MONEY*0.004)),0)) '返奖金币'
	from game.t_order_item o 
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('KD','YH')
)t1;





