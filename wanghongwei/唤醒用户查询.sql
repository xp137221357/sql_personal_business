

select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.USER_MOBILE '手机号',u.ACCT_NUM '会员号',
if(e.charge_method='APP','官充','非官充') '充值方式',e.coins '充值金币',e.rmb_value'充值金额',e.CRT_TIME '充值时间' from forum.t_user u 
inner join t_user_mobile20170524 t on u.USER_MOBILE=t.user_mobile
inner join report.t_trans_user_recharge_coin e on u.USER_ID =e.charge_user_id 
and e.CRT_TIME>='2017-05-18';


-- 13003093353


update report.t_user_mobile20170524 t 
set t.user_mobile=replace(t.user_mobile,'\n',''),
t.user_mobile=replace(t.user_mobile,'\r','') 
where t.user_mobile like '%\n%'
or t.user_mobile like '%\r%';