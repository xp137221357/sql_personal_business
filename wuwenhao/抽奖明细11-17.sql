set @beginTime='2016-11-07 00:00:00';
set @endTime = '2016-11-13 23:59:59';

select '金币抽奖',u.NICK_NAME,ai.USER_ID,ai.ADD_TIME '时间', ai.CHANGE_VALUE '抽奖金币'  
from forum.t_acct_items ai
inner join forum.t_user u on u.USER_ID=ai.user_id
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'BUY_ACT_TIMES' and ai.ACCT_TYPE in (1001) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 order by ai.ADD_TIME asc
 
 union all
 
 
 -- 用户返奖
select '金币返奖',u.NICK_NAME,ai.USER_ID,ai.ADD_TIME '时间', ai.CHANGE_VALUE '抽奖金币'  
from forum.t_acct_items ai
inner join forum.t_user u on u.USER_ID=ai.user_id
 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT = 'ACT_PRIZE' and ai.ACCT_TYPE in (1001) 
 and ai.ADD_TIME >= @beginTime AND ai.ADD_TIME <= @endTime
 order by ai.ADD_TIME asc
