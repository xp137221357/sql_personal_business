-- 系统账户余额
set @param1='2017-09-11 00:00:00';


select 
concat(v.USER_CODE,'_') '用户编码',
v.coin_balance '非冻结余额',
v.coin_freeze '冻结金额'
from v_account_item0909 v
left join forum.t_user u on v.user_code=u.USER_CODE
where u.USER_CODE is null; 