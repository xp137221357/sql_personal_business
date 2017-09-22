set @param1='2017-09-11 00:00:00';



select 
'已冻结账户',
u.NICK_NAME,
concat(u.USER_CODE,'_') '用户编码',
u.ACCT_NUM '会员号',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额'
from forum.t_user u 
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
where u.`STATUS`!=10 and u.CLIENT_ID='BYAPP'
and u.CRT_TIME<@param1
and u.USER_ID not in (
select user_id from report.t_user_system
union all
select user_id from report.t_user_merchant
);