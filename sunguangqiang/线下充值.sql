set @beginTime = '2016-08-01';
set @endTime = '2016-08-31 23:59:59';

select 
'线下充值',
concat(@beginTime,'~',@endTime) '时间',
round(ifnull(sum(ai.COST_VALUE),0)) '充值金币',
round(ifnull(sum(ai.COST_VALUE),0)) '充值金额' 
from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
and ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%'
and ai.item_status = 10 ;