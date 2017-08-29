

select t2.NICK_NAME '用户昵称',t2.USER_ID '用户ID',t2.ACCT_NUM '会员号',t2.CRT_TIME '注册时间',t1.crt_time '充值时间',
t1.rmb_value '充值金额',t1.types '充值类型',t3.ip 'ip',t3.device_code '设备号' from (
select tc.charge_user_id user_id,tc.crt_time,tc.rmb_value,'coins' types from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
where tc.crt_time>='2016-08-01'
and tc.crt_time<'2016-09-01'
and tc.charge_method='app'

union all 

select tc.charge_user_id user_id,tc.crt_time,tc.rmb_value,'diamonds' types from report.t_trans_user_recharge_diamond tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
where tc.crt_time>='2016-08-01'
and tc.crt_time<'2016-09-01'
and tc.charge_method='app'


union all


select tc.charge_user_id user_id,tc.crt_time,tc.rmb_value,'coins' types from report.t_trans_merchant_recharge_coin tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
where tc.crt_time>='2016-08-01'
and tc.crt_time<'2016-09-01'
and tc.charge_method='app'

union all


select tc.charge_user_id user_id,tc.crt_time,tc.rmb_value,'diamonds' types from report.t_trans_merchant_recharge_diamond tc
inner join forum.t_user u on tc.charge_user_id=u.USER_ID 
where tc.crt_time>='2016-08-01'
and tc.crt_time<'2016-09-01'
and tc.charge_method='app'

) t1
inner join forum.t_user t2 on t1.user_id =t2.USER_ID
inner join forum.t_user_event t3 on t1.user_id=t3.USER_ID and t3.EVENT_CODE='reg'


