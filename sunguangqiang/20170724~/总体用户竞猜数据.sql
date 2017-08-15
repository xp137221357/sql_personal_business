set @param0='2017-06-01 00:00:00';
set @param1='2017-08-01 00:00:00';

set @param2=concat(@param0,'~',@param1);

select 
@param2 '时间',
'所有用户',
sum(o.COIN_BUY_MONEY) '投注', 
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) '返奖',
sum(
    if(o.pass_type = '1001' 
	 and o.item_status not in (0,10,-5,-10,120,210) 
	 and o.MATCH_ODDS >= 1.5,
	 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
	 0 )) '有效流水'
from (
	select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
	left join game.t_item_content c on c.ITEM_ID = o.item_id
	where o.CHANNEL_CODE = 'game'
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	group by o.ITEM_ID
) o;
   
   
select  @param2 '时间','所有用户投注任务赠送',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID =u.USER_ID
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE>=2500
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';