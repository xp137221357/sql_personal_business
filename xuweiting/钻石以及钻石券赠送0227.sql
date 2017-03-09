set @param0='2017-01-02';
set @param1='2017-02-26 23:59:59';


select date_format(ai.ADD_TIME,'%x-%v') stat_time,'钻石赠送',count(distinct user_id) '人数',
sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
where ai.item_status = 10
and ((ai.TRADE_NO like 'SIGN_%' and ai.ITEM_EVENT='GET_FREE_COIN') or ai.ITEM_EVENT='DIAMEND_PRESENT')
and ai.ACCT_TYPE=1003
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
group by stat_time;

select date_format(ai.ADD_TIME,'%x-%v') stat_time,'钻石券赠送',
count(distinct if(ai.ACCT_TYPE=104,user_id,null)) '100面额人数' ,
sum(if(ai.ACCT_TYPE=104,100,0)) '100面额金额',
count(distinct if(ai.ACCT_TYPE=108,user_id,null)) '50面额人数',
sum(if(ai.ACCT_TYPE=108,50,0)) '50面额金额'
from forum.t_acct_items ai 
where ai.item_status = 10
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
and ai.ACCT_TYPE in (104,108)
group by stat_time;






