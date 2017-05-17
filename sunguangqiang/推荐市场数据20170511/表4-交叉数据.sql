set @param0='2016-12-19';
set @param1 = '2016-12-25 23:59:59';


select 
	'购买服务人数-金额',
	count(distinct ai.USER_ID) value1, 
	sum(ai.CHANGE_VALUE) value2
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM') 
and ai.ITEM_STATUS = 10 
and ai.ADD_TIME >= @param0 
and ai.ADD_TIME < @param1 

union all


select 
	'充值金币用户数-金额',
	count(distinct rc.charge_user_id) '充值金币用户数', 
	sum(rc.coins) '充值金币金额'
from report.t_trans_user_recharge_coin rc 
where rc.charge_user_id in (
  select ai.USER_ID
	 from forum.t_acct_items ai 
	 where ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM') 
	 and ai.ITEM_STATUS = 10 
	 and ai.ADD_TIME >= @param0 
	 and ai.ADD_TIME < @param1 
)and rc.crt_time >= @param0 and rc.crt_time < @param1

union all

select 
   '购买服务且投注人数-投注金币',
	count(distinct oi.USER_ID) '购买服务且投注人数', 
	sum(if(oi.CRT_TIME<'2016-07-05 17:55:09',oi.ITEM_MONEY,oi.P_COIN_BUY_MONEY)) '购买服务且投注的投注金币' 
from game.t_order_item oi 
inner join forum.t_user u on oi.USER_ID = u.USER_CODE
where 
u.USER_ID in (
	select ai.USER_ID
	 from forum.t_acct_items ai 
	 where ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM') 
	 and ai.ITEM_STATUS = 10 
	 and ai.ADD_TIME >= @param0 
	 and ai.ADD_TIME < @param1 
)
and oi.ITEM_STATUS not in (-5, -10, 210) and oi.CHANNEL_CODE in ( 'GAME','BYAPP')
and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1

union all

select
	 '投注用户数-投注金币数' ,
	 count(distinct oi.USER_ID) '投注用户数', 
	 sum(if(oi.CRT_TIME<'2016-07-05 17:55:09',oi.ITEM_MONEY,oi.P_COIN_BUY_MONEY)) '投注金币'
from game.t_order_item oi 
inner join forum.t_user u on oi.USER_ID = u.USER_CODE
where oi.ITEM_STATUS not in (-5, -10, 210) and oi.CHANNEL_CODE in ( 'GAME','BYAPP')
and oi.PAY_TIME >= @param0 
and oi.PAY_TIME < @param1

union all

select 
   '充值钻石人数-充值钻石金额' ,
	count(distinct rd.charge_user_id) '充值钻石数', 
	sum(rd.diamonds) '充值钻石金额' 
from t_trans_user_recharge_diamond rd where rd.crt_time >= @param0 and rd.crt_time < @param1 and rd.charge_user_id in (
select distinct u.USER_ID from game.t_order_item oi 
inner join forum.t_user u on oi.USER_ID = u.USER_CODE
where oi.ITEM_STATUS not in (-5, -10, 210) and oi.CHANNEL_CODE in ( 'GAME','BYAPP')
and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1
)

union all

select 
'购买服务且投注人数-服务金额' ,
count(distinct ai.USER_ID) '购买服务且投注人数', 
sum(ai.CHANGE_VALUE) '服务金额'
 from forum.t_acct_items ai 
 inner join ( 
	 select distinct u.USER_ID from game.t_order_item oi 
	 inner join forum.t_user u on oi.USER_ID = u.USER_CODE
	 where oi.ITEM_STATUS not in (-5, -10, 210) 
	 and oi.CHANNEL_CODE in ( 'GAME','BYAPP')
	 and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1
 )t on ai.USER_ID = t.USER_ID
 where ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM') 
 and ai.ITEM_STATUS = 10 
 and ai.ADD_TIME >= @param0 
 and ai.ADD_TIME < @param1
 