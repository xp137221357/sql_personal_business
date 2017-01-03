set @param0='2016-12-04';
set @param1='2016-12-04 23:59:59';

select ai.ACCT_ID,ai.ACCT_TYPE,ai.CHANGE_VALUE,ai.CHANGE_TYPE,ai.AFTER_VALUE,ai.ADD_TIME,ai.UPDATE_TIME
from FORUM.t_acct_items ai 
where  ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,10)
order by ai.ADD_TIME asc;




-- select * from forum.t_user u where u.USER_CODE='2843567313246132614'

select 
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) 
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,10)
and v.USER_ID is not null
;

select ai.*
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID
where  ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,10)
and v.USER_ID is not null
order by ai.ADD_TIME asc;











