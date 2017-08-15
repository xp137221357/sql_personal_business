set @param0 = '2017-05-01'; 
set  @param1 = '5月份';


-- 注册人数

select '注册用户-基础数据', @param1 '时间',count(1) '注册人数','-' 金额 from forum.t_user u 
where u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month)
and u.CLIENT_ID='byapp'

union all

select '当月新增官充', @param1 '时间',count(distinct t.charge_user_id) '人数',sum(t.rmb_value) '金额' from (
select tc.charge_user_id,tc.rmb_value from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=@param0
and tc.crt_time<date_add(@param0,interval 1 month)
and tc.charge_method='app'
union all
select tc.charge_user_id,tc.rmb_value from report.t_trans_user_recharge_diamond tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=@param0
and tc.crt_time<date_add(@param0,interval 1 month)
and tc.charge_method='app'
) t

union all

select '次月新增官充', @param1 '时间',count(distinct t.charge_user_id) '人数',sum(t.rmb_value) '金额' from (
select tc.charge_user_id,tc.rmb_value from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=date_add(@param0,interval 1 month)
and tc.crt_time<date_add(@param0,interval 2 month)
and tc.charge_method='app'
union all
select tc.charge_user_id,tc.rmb_value from report.t_trans_user_recharge_diamond tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=date_add(@param0,interval 1 month)
and tc.crt_time<date_add(@param0,interval 2 month)
and tc.charge_method='app'
) t

union all

select '当月新增第三方充值', @param1 '时间',count(distinct tc.charge_user_id) '人数',sum(tc.rmb_value) '金额' 
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=@param0
and tc.crt_time<date_add(@param0,interval 1 month)
and tc.charge_method!='app'

union all


select '次月新增第三方充值', @param1 '时间',count(distinct tc.charge_user_id) '人数',sum(tc.rmb_value) '金额' 
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and u.CRT_TIME>=@param0 and u.CRT_TIME<date_add(@param0,interval 1 month) and u.CLIENT_ID='byapp'
where tc.crt_time>=date_add(@param0,interval 1 month)
and tc.crt_time<date_add(@param0,interval 2 month)
and tc.charge_method!='app';


