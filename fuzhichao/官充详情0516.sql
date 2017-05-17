
set @param0='2017-05-15';
set @param1='2017-05-16';

select u.NICK_NAME '昵称',u.ACCT_NUM '会员号',u.USER_ID '用户ID',date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%S') '注册时间',
tc.coins '充值金币',tc.rmb_value '充值人民币',date_format(tc.CRT_TIME,'%Y-%m-%d %H:%i:%S') '充值时间',
tu.CHANNEL_NAME '所属渠道' 
from (
	select tc.charge_user_id,tc.coins,tc.rmb_value,tc.crt_time 
	from report.t_trans_user_recharge_coin tc
	where tc.crt_time>=@param0
	and tc.crt_time<=@param1
	and tc.charge_method='app'
	
	union all
	
	select tc.charge_user_id,tc.coins,tc.rmb_value,tc.crt_time 
	from report.t_trans_merchant_recharge_coin tc
	where tc.crt_time>=@param0
	and tc.crt_time<=@param1
	and tc.charge_method='app'
) tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
left join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
order by tc.rmb_value desc;


