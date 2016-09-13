set @beginTime='2016-08-08 00:00:00';
set @endTime = '2016-08-14 23:59:59';

## 任务赠送
select '任务赠送',concat(@beginTime,'~',@endTime) '时间','boss', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
				inner join forum.v_user_boss uo on ai.user_id = uo.user_id
				and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
				  and ai.ADD_TIME >= @beginTime and ai.ADD_TIME <= @endTime
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
					  union all
				select '任务赠送',concat(@beginTime,'~',@endTime) '时间','new', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
				inner join forum.v_user_new uo on ai.user_id = uo.user_id 
				and crt_time >=@beginTime and crt_time <=  @endTime
				and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
				  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
				union all
				select  '任务赠送',concat(@beginTime,'~',@endTime) '时间','old', round( ifnull(sum(ai.change_value),0)) '金币'   from forum.t_acct_items ai
				inner join forum.v_user_old uo on ai.user_id = uo.user_id and uo.crt_time <@endTime
				and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
				  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000');
					  
					  
## 邀请赠送
select '邀请赠送',concat(@beginTime,'~',@endTime) '时间','boss', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in (select USER_ID from forum.v_user_boss)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			union all
			select '邀请赠送',concat(@beginTime,'~',@endTime) '时间','new', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in ( select user_id from forum.v_user_new where crt_time >= @beginTime and crt_time <= @endTime)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			union all
			select '邀请赠送',concat(@beginTime,'~',@endTime) '时间','old', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in (select user_id from forum.v_user_old where crt_time <= @beginTime)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%';
## 代理返点
select '代理返点',concat(@beginTime,'~',@endTime) '时间','boss',round(ifnull(sum(PRIZE_MONEY),0)) '金币' 
			from game.t_group_prize p
			inner join forum.t_user u on p.PRIZE_USER = u.USER_CODE
			inner join forum.v_user_boss ub on u.USER_ID = ub.USER_ID
			and p.CRT_TIME >=@beginTime  and p.CRT_TIME <=  @endTime
			##group by DATE(p.CRT_TIME)
			union all
			select '代理返点',concat(@beginTime,'~',@endTime) '时间','new',round(ifnull(sum(PRIZE_MONEY),0)) '金币' 
			from game.t_group_prize p
			inner join forum.t_user u on p.PRIZE_USER = u.USER_CODE
			inner join forum.v_user_new un on u.USER_ID = un.USER_ID
			and un.crt_time >= @beginTime and un.crt_time <=  @endTime
			and p.CRT_TIME >= @beginTime  and p.CRT_TIME <=  @endTime
			##group by DATE(p.CRT_TIME)
			union all
			select '代理返点',concat(@beginTime,'~',@endTime) '时间','old',round(ifnull(sum(PRIZE_MONEY),0)) '金币' 
			from game.t_group_prize p
			inner join forum.t_user u on p.PRIZE_USER = u.USER_CODE
			inner join forum.v_user_old uo on u.USER_ID = uo.USER_ID
			and uo.crt_time < @beginTime
			and p.CRT_TIME >= @beginTime  and p.CRT_TIME <=  @endTime;
			##group by DATE(p.CRT_TIME);
			
			
## 活动赠送
select '活动赠送',concat(@beginTime,'~',@endTime) '时间','boss', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.USER_ID not in (select user_id from forum.v_user_system)
			and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			and ai.user_id in (select USER_ID from forum.v_user_boss)
			union all
			select '活动赠送',concat(@beginTime,'~',@endTime) '时间','new',round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.USER_ID not in (select user_id from forum.v_user_system)
			and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT', 'ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			and ai.user_id in (select user_id from forum.v_user_new where crt_time >= @beginTime and crt_time <= @endTime)
			union all
			select '活动赠送',concat(@beginTime,'~',@endTime) '时间','old', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.USER_ID not in (select user_id from forum.v_user_system)
			and ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT', 'ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			and ai.user_id in (select user_id from forum.v_user_old where crt_time <= @beginTime);
			
## 天天活动
select '天天活动',concat(@beginTime,'~',@endTime) '时间','boss', round( ifnull(sum(ai.change_value),0)) '金币'   from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in (select USER_ID from forum.v_user_boss)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10

			union all
			select '天天活动',concat(@beginTime,'~',@endTime) '时间','new', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in ( select user_id from forum.v_user_new where crt_time >= @beginTime and crt_time <= @endTime)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
			union all
			select '天天活动',concat(@beginTime,'~',@endTime) '时间','old', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in (select user_id from forum.v_user_old where crt_time <= @beginTime)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10;
			  
## 用户反水
select '用户反水',concat(@beginTime,'~',@endTime) '时间','boss', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
			  and ai.user_id in (select USER_ID from forum.v_user_boss)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10
			union all
			select '用户反水',concat(@beginTime,'~',@endTime) '时间','new', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in ( select user_id from forum.v_user_new where crt_time >= @beginTime and crt_time <= @endTime)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10
			union all
			select '用户反水',concat(@beginTime,'~',@endTime) '时间','old', round( ifnull(sum(ai.change_value),0)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.user_id in (select user_id from forum.v_user_old where crt_time <= @beginTime)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10;
			  

	