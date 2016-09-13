set @beginTime='2016-08-08 00:00:00';
set @endTime = '2016-08-08 23:59:59';			  
-- 用户抽奖
select 'P','金币抽奖',concat(@beginTime,'~',@endTime) '时间','all', ifnull(SUM(ai.CHANGE_VALUE),0) '金币'  from forum.t_acct_items ai
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'BUY_ACT_TIMES' and ai.ACCT_TYPE in (1001) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 
 union all
 
 select 'T','体验币抽奖',concat(@beginTime,'~',@endTime) '时间','all',ifnull(SUM(ai.CHANGE_VALUE),0) '体验币'  from forum.t_acct_items ai
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'BUY_ACT_TIMES' and ai.ACCT_TYPE in (1015) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 
  union all
 
 -- 用户返奖
select 'P','金币返奖',concat(@beginTime,'~',@endTime) '时间','all',ifnull(SUM(ai.CHANGE_VALUE),0) '金币'  from forum.t_acct_items ai
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'ACT_PRIZE' and ai.ACCT_TYPE in (1001) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 
  union all
 
select 'T','体验币返奖',concat(@beginTime,'~',@endTime) '时间','all',ifnull(SUM(ai.CHANGE_VALUE),0) '体验币'  from forum.t_acct_items ai
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'ACT_PRIZE' and ai.ACCT_TYPE in (1015) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 
  union all
 
select 'P','用户抽奖实物支出',concat(@beginTime,'~',@endTime) '时间','all', sum(ifnull(a.AWARD_MONEY,0)) `金币`
  from forum.t_activity_apply t 
  inner join forum.t_activity_award a on t.AWARD_ID = a.AWARD_ID
  and a.AWARD_CD != 'JB' and t.apply_time>=@beginTime and t.apply_time<= @endTime ;