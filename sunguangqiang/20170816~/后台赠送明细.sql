-- 再查一下 8.1-8.31 赠送明细~ 
-- 后台帐号  赠送接收用户  时间  备注

-- 
set @param0='2017-08-01';
set @param1='2017-09-01';

select u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',ai.PAY_TIME '时间',ti.EVENT_NAME '事件',ai.CHANGE_VALUE '金额',ai.COMMENTS 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID
inner join forum.t_acct_items_events ti on ai.ITEM_EVENT=ti.ITEM_EVENT
where ai.ITEM_EVENT like 'ADMIN_OPT_%'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1;