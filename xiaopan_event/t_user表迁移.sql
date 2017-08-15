
select u.USER_ID,u.USER_CODE,u.ACCT_NUM,u.USER_MOBILE,u.STATUS,tu.CHANNEL_NO,tu.ROOT_USER_CODE 
from forum.t_user u 
left join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID 
where u.CLIENT_ID='BYAPP'
and u.crt_time>=#{begin_time}
and u.crt_time<date_add(#{begin_time},interval 1 day);