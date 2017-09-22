



insert into t_stat_partner_user_info (USER_ID,FORUM_USER_ID,NICK_NAME,ACCT_NUM,USER_MOBILE,CRT_TIME,INVITE_CODE,JOIN_GROUP_TIME)
select u.USER_CODE,u.USER_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_MOBILE,u.CRT_TIME,e.INVITE_CODE,r.CRT_TIME  
from game.t_group_ref r
inner join forum.t_user u on r.user_id = u.USER_CODE
left join game.t_user_ext e on e.USER_ID = u.USER_CODE
on duplicate key UPDATE 
FORUM_USER_ID = VALUES(FORUM_USER_ID),
NICK_NAME = VALUES(NICK_NAME),
select * from t_job t where t.job_name like '%dawn%'
ACCT_NUM = VALUES(ACCT_NUM),
USER_MOBILE = VALUES(USER_MOBILE),
CRT_TIME = VALUES(CRT_TIME),
INVITE_CODE=VALUES(INVITE_CODE),
JOIN_GROUP_TIME = VALUES(JOIN_GROUP_TIME);


select ai.USER_ID from forum.t_acct_items ai
where ai.ITEM_STATUS in (10,-10)
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<concat(@param0,' 23:59:59')
group by ai.USER_ID