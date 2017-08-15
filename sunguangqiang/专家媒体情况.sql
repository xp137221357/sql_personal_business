-- 媒体名家
select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7;

select '专家媒体名家', u.NICK_NAME '用户昵称',u.ACCT_NUM'会员号',u.USER_ID'用户ID',u.USER_MOBILE '联系方式' 
from forum.t_user u 
inner join forum.t_expert_type_ref tf on u.USER_ID=tf.USER_ID and tf.TYPE_CD=7;



select '专家', u.NICK_NAME '用户昵称',u.ACCT_NUM'会员号',u.USER_ID'用户ID',u.USER_MOBILE '联系方式',ai.AFTER_VALUE '余额' from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID
inner join forum.t_expert tf on u.USER_ID=tf.USER_ID and tf.IS_EXPERT=1
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10
and ai.AFTER_VALUE>=12
order by ai.ITEM_ID desc
group by ai.USER_ID;