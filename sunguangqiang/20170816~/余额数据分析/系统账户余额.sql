-- 系统账户余额
set @param1='2017-09-11 00:00:00';

select * from forum.t_user u 
inner join report.t_user_system t on u.USER_ID=t.user_id;


select 
'第三方账号',
u.NICK_NAME,
concat(u.USER_CODE,'_') '用户编码',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额'
from forum.t_user u 
inner join report.t_user_system t on u.USER_ID=t.user_id
inner join report.v_account_item0909 v on t.USER_CODE=v.user_code;