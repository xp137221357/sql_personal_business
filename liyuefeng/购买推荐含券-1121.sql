

set @param0='2016-11-10';
set @param1='2016-11-16 23:59:59';

select concat(@param0,'~',@param1) '日期',sum(if(c.CHILD_CODE_VALUE is null,
ai.CHANGE_VALUE,ai.CHANGE_VALUE*convert(c.CHILD_CODE_VALUE,signed))) '购买推荐(包含专家券)' 
from forum.t_acct_items ai 
left join forum.t_code c on ai.ACCT_TYPE = convert(c.CHILD_CODE,signed) and convert(c.CHILD_CODE_VALUE,signed)>0 
where ai.ITEM_STATUS=10 and ai.item_event in ('BUY_RECOM','BUY_SERVICE') 
and ai.ADD_TIME>=@param0 and ai.ADD_TIME<=@param1 

