在不在  帮我导出下；
范围： 百盈用户（包括今日头条竞猜） 
时间： 7月1~21号
筛选条件：累计充值金额达到3000以上（官方+第三方）
附带信息： 手机号码  用户ID  充值记录  登陆方式（H5 还是APP） 机型


select '充值金币',u.USER_ID '用户ID',u.NICK_NAME '用户昵称', u.ACCT_NUM '会员号',u.USER_MOBILE '手机号码',
u.CRT_TIME '注册时间',tc.rmb_value '充值金额',tc.crt_time '充值时间',tc.charge_method '充值方式',tu.CHANNEL_NO '渠道编码' from (
select * from (
	select charge_user_id,sum(tc.rmb_value) rmb_value from report.t_trans_user_recharge_coin tc 
	where tc.crt_time>='2017-07-01'
	and tc.crt_time<'2017-07-21'
	group by tc.charge_user_id
) t where t.rmb_value>3000
) tt
inner join forum.t_user u on tt.charge_user_id=u.USER_ID
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID 
inner join report.t_trans_user_recharge_coin tc on tt.charge_user_id=tc.charge_user_id 
and tc.crt_time>='2017-07-01'
and tc.crt_time<'2017-07-21'
order by u.USER_ID asc;



select '充值钻石',u.USER_ID '用户ID',u.NICK_NAME '用户昵称', u.ACCT_NUM '会员号',u.USER_MOBILE '手机号码',
u.CRT_TIME '注册时间',tc.rmb_value '充值金额',tc.crt_time '充值时间',tc.charge_method '充值方式',tu.CHANNEL_NO '渠道编码' from (
select * from (
	select charge_user_id,sum(tc.rmb_value) rmb_value from report.t_trans_user_recharge_diamond tc 
	where tc.crt_time>='2017-07-01'
	and tc.crt_time<'2017-07-21'
	group by tc.charge_user_id
) t where t.rmb_value>3000
) tt
inner join forum.t_user u on tt.charge_user_id=u.USER_ID
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID 
inner join report.t_trans_user_recharge_coin tc on tt.charge_user_id=tc.charge_user_id 
and tc.crt_time>='2017-07-01'
and tc.crt_time<'2017-07-21'
order by u.USER_ID asc;