-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59

set @beginTime='2016-11-13 00:00:00';
set @endTime = '2016-11-13 23:59:59';

## 任务赠送
select 'P','金币任务赠送',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
				where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
				  and ai.ADD_TIME >= @beginTime and ai.ADD_TIME <= @endTime
				  and ai.USER_ID not in (select user_id from report.v_user_system)
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
					  
					  union all
					  
select 'T','体验币任务赠送',concat(@beginTime,'~',@endTime) '时间','all', round( sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
				where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
				  and ai.ADD_TIME >= @beginTime and ai.ADD_TIME <= @endTime
				  and ai.USER_ID not in (select user_id from report.v_user_system)
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
					  
					  union all
					  
					  
## 邀请赠送
select 'P','金币邀请赠送',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			  
			  union all
			  
select 'T','体验币邀请赠送',concat(@beginTime,'~',@endTime) '时间','all', round( sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			  
			
			union all
					

## 活动赠送
select 'P','金币活动赠送',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where  ai.item_status = 10 and ai.ACCT_TYPE in (1001) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.USER_ID not in (select user_id from report.v_user_system)
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			
			union all
			
			
select 'T','体验币活动赠送',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where  ai.item_status = 10 and ai.ACCT_TYPE in (1015) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
		 	and ai.USER_ID not in (select user_id from report.v_user_system)
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			
			union all

			
## 天天活动
select 'P','金币天天活动',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '金币'   from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
			  
			  union all
			  
			  
select 'T','体验币天天活动',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '体验币'   from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
			  
			  union all
			
			  
## 代理返点(体验币没有代理返点，若有则为错误的)
select 'P','金币用户反水',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10
			  
			  union all
			  
			  
select 'T','体验币用户反水',concat(@beginTime,'~',@endTime) '时间','all', round(sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10;
			  

select 'P','系统账号派发',concat(@beginTime,'~',@endTime) '时间',round(t1.MONEY + t3.OFFER_GRATUITY) '派发金币' from (
SELECT ifnull(Sum(p.money),0) MONEY
        FROM   forum.t_user_present p
        inner join report.v_user_system vs on p.USER_ID = vs.USER_ID
               AND p.`status` = 10
               AND p.crt_time >= @begintime
               AND p.crt_time <= @endtime
			   )t1, (
select @beginTime,'系统用户赏金答题赠送', ifnull(sum(gift_sum),0) OFFER_GRATUITY from (
## 三个系统大账号主动给用户派送金币
select oa.USER_ID receiver, o.OFFER_GRATUITY - o.OFFER_PRIZE gift_sum, o.USER_ID sender 
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join report.v_user_system vus on o.USER_ID = vus.USER_CODE and oa.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME >= @begintime and oa.OFFER_APPLY_TIME <= @endtime

union all 

select o.USER_ID, o.OFFER_PRIZE - o.OFFER_GRATUITY gift_sum, oa.USER_ID from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join report.v_user_system vus on oa.USER_ID = vus.USER_CODE and o.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME >= @begintime and oa.OFFER_APPLY_TIME <= @endtime
)t2
) t3 

union all

select 'P','任务领取',concat(@beginTime,'~',@endTime),sum(ai.change_VALUE) from forum.t_acct_items ai 
where ai.item_event='USER_TASK' 
and ai.item_status = 10 
and ai.USER_ID not in (select user_id from report.v_user_system)
and ai.ACCT_TYPE in (1001)
and ai.ADD_TIME >= @begintime  and ai.ADD_TIME <= @endtime
			  

union all

select 'T','任务领取',concat(@beginTime,'~',@endTime),sum(ai.change_VALUE) from forum.t_acct_items ai 
where ai.item_event='USER_TASK' 
and ai.item_status = 10 
and ai.USER_ID not in (select user_id from report.v_user_system)
and ai.ACCT_TYPE in (1015)
and ai.ADD_TIME >= @begintime  and ai.ADD_TIME <= @endtime
	
	
