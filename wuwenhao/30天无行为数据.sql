


select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.ACCT_NUM '会员号' 
from forum.t_user u 
left join(
select user_id from forum.t_acct_items ai 
where ai.CHANGE_TYPE=1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=date_add(curdate(),interval -30 day)
and ai.PAY_TIME<curdate()
group by ai.USER_ID
) t on u.USER_ID=t.user_id
where 
t.user_id is null
and u.CLIENT_ID='byapp'
and u.`STATUS`=10
;








