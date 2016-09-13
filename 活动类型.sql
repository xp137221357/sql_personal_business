
set @beginTime = '2016-06-27';
set @endTime = '2016-06-28';
select ai.ITEM_EVENT, count(1), sum(ai.CHANGE_VALUE), sum(ai.COST_VALUE) from forum.t_acct_items ai where ai.ADD_TIME >= @beginTime and ai.ADD_TIME < @endTime and ai.ITEM_STATUS = 10 and ai.ACCT_TYPE = 1001 group by ai.ITEM_EVENT with rollup;
