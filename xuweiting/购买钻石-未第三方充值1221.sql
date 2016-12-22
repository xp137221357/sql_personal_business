set @param0='2016-6-01 00:00:00';

set @param1='2016-12-31 23:59:59';


select u.NICK_NAME '用户昵称',
u.USER_ID '用户ID',
u.ACCT_NUM '会员号',
if(u.`STATUS`=10,'正常','冻结')'用户状态',
max(te.CRT_TIME) '上次登陆时间',
sum(td.diamonds) '购买钻石数'
from report.t_trans_user_recharge_diamond td 
inner join forum.t_user u on td.charge_user_id=u.USER_ID
inner join forum.t_user_event te on te.USER_ID=u.USER_ID 
left join report.t_trans_user_recharge_coin tc on td.charge_user_id=tc.charge_user_id and tc.crt_time>=@param0 and tc.crt_time<=@param1 and tc.charge_method!='APP'
where td.crt_time>=@param0 and td.crt_time<=@param1
and tc.charge_user_id is null
group by td.charge_user_id