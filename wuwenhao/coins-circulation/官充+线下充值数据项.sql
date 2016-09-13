-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59

set @beginTime='2016-08-22 00:00:00';
set @endTime = '2016-08-28 23:59:59';

 ## 线下充值金币数
select 'P','线下充值',concat(@beginTime,'~',@endTime) '时间','all',
round(sum(ifnull(ai.CHANGE_VALUE,0))) '金币' from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
and ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%'
and ai.item_status = 10 
 
union all
 
## 从APP入口进行充值获取的金币
select 'P','官充',concat(@beginTime,'~',@endTime) '时间','all',
round( sum(ifnull(ai.change_value,0))) '金币' from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
and ai.ITEM_EVENT in ('COIN_FROM_DIAMEND') 
and ai.ITEM_SRC  in (0)
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 ;



-- 合并
select 'P','线下充值',concat(@beginTime,'~',@endTime) '时间','all',
round(sum(ifnull(ai.CHANGE_VALUE,0))) '金币' from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
and ((ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%') or (ai.ITEM_EVENT='COIN_FROM_DIAMEND'))
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 
