set @param0='2017-01-08 00:00:00';
set @param1='2017-01-08 23:59:59';

select  
u.NICK_NAME '昵称',ai.CHANGE_VALUE'金币',ai.ITEM_EVENT'事件',ai.COMMENTS'详情'  
from forum.t_acct_items ai
inner join forum.t_user u on ai.user_id=u.user_id
where ai.item_status = 10
  and ai.ADD_TIME >= @param0
  and ai.ADD_TIME <= @param1
  and ai.USER_ID not in (select user_id from report.v_user_system)
  and ai.ACCT_TYPE=1001
  
  and ((ai.ITEM_EVENT='GET_FREE_COIN'
	     and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
		  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
		  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
		  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'  or ai.trade_no like '%EVENT_SHARE%' ))
		or (
		  	ai.ITEM_EVENT='GET_FREE_COIN'
         and ai.TRADE_NO like 'USER_GJ-%' )
		
		or (
		  	(ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
         (ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
		  )
		  
		
		or (
		  	ai.ITEM_EVENT='FREE_COIN_TTACT'
		  )
		  
	   or (
	  	   ai.ITEM_EVENT='USER_GROUP_PRIZE'
	   )
	   
	   or (
	  	   ai.ITEM_EVENT='USER_TASK'
	   )
	   
	   or (
	  	   ai.ITEM_EVENT='ADMIN_USER_OPT'
	   )
	   
	   or (
	  	   ai.ITEM_EVENT='COUPON_TO_PCOIN'
	      and ai.COMMENTS LIKE '%使用复活券%'
	   )
	   
	   or (
	  	   ai.ITEM_EVENT in ('PACKET_RECIVE','PCKET_EXPIRE','ROOM_PACKET_TRADE')
	   )
	  
	  )

