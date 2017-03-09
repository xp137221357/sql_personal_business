
set @param0='2017-02-09';
set @param1='2017-02-09 23:59:59';

select '官充金币',u.NICK_NAME '昵称',tc.coins '充值金币',tc.rmb_value '充值金额',tc.crt_time '充值时间' 
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on u.user_id =tc.charge_user_id
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app'

union all


select '官充金币',u.NICK_NAME '昵称',tc.diamonds '充值金币',tc.rmb_value '充值金额',tc.crt_time '充值时间'
from report.t_trans_user_recharge_diamond tc 
inner join forum.t_user u on u.user_id =tc.charge_user_id
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app';