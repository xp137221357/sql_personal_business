



-- 充值
-- 查询时间：2017.5.1-8.15
-- 第三方充值：第三方与第三方之间的答题不计算入内，只计算第三方与用户之间的答题；
-- 第三方比例：1元=140金币；
set @param0='2017-05-01';
set @param1='2017-08-16';

-- 官充每笔充值金额
select '12' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=12

union all 

select '30' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=30


union all 

select '68' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=68

union all 

select '128' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=128


union all 

select '328' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=328


union all 

select '648' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=648

union all 

select '1000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=1000


union all 

select '3000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=3000


union all 

select '5000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=5000


union all 

select '10000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=10000

union all 

select '20000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=20000


union all 

select '30000' 区间,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc.rmb_value=30000;
