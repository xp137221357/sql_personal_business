set @beginTime = '2016-06-10';
set @endTime = '2016-06-17';

-- 系统赠送

select @beginTime,'大户常规赠送',date(ai.ADD_TIME) as _date, cast( ifnull(sum(ai.change_value),0)  as decimal(10,0) ) `常规赠送金币数` from forum.t_acct_items ai 
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
  and ai.user_id in (select USER_ID from forum.v_user_boss)
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or 
      ai.TRADE_NO like '%FOLLOW_CIRCLE%' or ai.TRADE_NO like 'USER_GJ-%' or 
      ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND' 
      or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
group by _date

union all

select @beginTime,'新户常规赠送',date(ai.ADD_TIME) as _date, cast( ifnull(sum(ai.change_value),0)  as decimal(10,0) ) `常规赠送金币数` from forum.t_acct_items ai 
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
  and ai.user_id in ( select user_id from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime) 
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or 
      ai.TRADE_NO like '%FOLLOW_CIRCLE%' or ai.TRADE_NO like 'USER_GJ-%' or 
      ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND' 
      or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
group by _date

union all

select @beginTime,'留存户常规赠送',date(ai.ADD_TIME) as _date, cast( ifnull(sum(ai.change_value),0)  as decimal(10,0) ) `常规赠送金币数` from forum.t_acct_items ai 
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
  and ai.user_id in (select user_id from forum.v_user_old where crt_time <@beginTime) 
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or 
      ai.TRADE_NO like '%FOLLOW_CIRCLE%' or ai.TRADE_NO like 'USER_GJ-%' or 
      ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND' 
      or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
group by _date

union all
-- 活动赠送
select  @beginTime,'大户活动赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `大户活动赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID not in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_M_HOT_FREE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select USER_ID from forum.v_user_boss)
  group by date(ai.ADD_TIME)
union all
select  @beginTime,'新用户活动赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `新用户活动赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID not in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_M_HOT_FREE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select user_id from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime)
  group by date(ai.ADD_TIME)
union all
select  @beginTime,'留存用户活动赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `留存用户活动赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID not in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_M_HOT_FREE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select user_id from forum.v_user_old where crt_time <@beginTime)
  group by date(ai.ADD_TIME)
union all


select  @beginTime,'大户来自系统赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `大户来自系统赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('PRESENT_FROM_USER','CP_PRIZE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select USER_ID from forum.v_user_boss)
  group by date(ai.ADD_TIME)
union all
select  @beginTime,'新用户来自系统赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `新用户来自系统赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('PRESENT_FROM_USER','CP_PRIZE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select user_id from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime)
  group by date(ai.ADD_TIME)
union all
select  @beginTime,'留存用户来自系统赠送',date(ai.ADD_TIME), ifnull(SUM(ai.CHANGE_VALUE),0) `留存用户来自系统赠送` from forum.t_acct_items ai
 join forum.t_user_present p on ( ai.USER_ID = p.TUSER_ID and p.USER_ID in (select user_id from forum.v_user_system))
where ai.item_status = 10 and ai.ACCT_TYPE = 1001 and ai.ITEM_EVENT in ('PRESENT_FROM_USER','CP_PRIZE') 
  and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime 
  and ai.user_id in (select user_id from forum.v_user_old where crt_time <@beginTime)
  group by date(ai.ADD_TIME)
;