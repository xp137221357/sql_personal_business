set @param0='2016-12-04';
set @param1='2016-12-04 23:59:59';

select tx.ACCT_ID,tx.ACCT_TYPE,tx.CHANGE_VALUE,tx.AFTER_VALUE,tx.ADD_TIME,tx.UPDATE_TIME
from FORUM.t_acct_items tx 
where  tx.ADD_TIME>=@param0
and tx.ADD_TIME<=@param1
-- and tx.CHANGE_VALUE=9000
and tx.ACCT_ID='8780943156219273635'
and tx.ACCT_TYPE in (1001) 
and tx.ITEM_STATUS=10
order by tx.ADD_TIME asc




-- select * from forum.t_user u where u.USER_CODE='2843567313246132614'

