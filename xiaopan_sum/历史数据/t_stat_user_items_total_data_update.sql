BEGIN

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE)
select ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_ID,ifnull(sum(ai.CHANGE_VALUE),0)+ifnull(t.CHANGE_VALUE,0) 
from forum.t_acct_items ai
left join t_stat_user_items_total_data t on ai.USER_ID=t.USER_ID and ai.ITEM_EVENT=t.ITEM_EVENT and ai.ACCT_TYPE=t.ACCT_TYPE 
where ai.PAY_TIME>=date_add(curdate(),interval -1 day)
and ai.PAY_TIME<curdate()
group by ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_TYPE
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE);

END