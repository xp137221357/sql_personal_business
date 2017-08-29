

-- 充值
-- 查询时间：2017.5.1-8.15
-- 第三方充值：第三方与第三方之间的答题不计算入内，只计算第三方与用户之间的答题；
-- 第三方比例：1元=140金币；
set @param0='2017-05-01';
set @param1='2017-08-16';

-- 第三方每笔充值金额
select '1-2' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=1
and tc.counts<=2

union all 

select '3-4' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=3
and tc.counts<=4


union all 

select '5-6' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=5
and tc.counts<=6

union all 

select '7-8' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=7
and tc.counts<=8


union all 

select '9-10' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=9
and tc.counts<=10


union all 

select '11-12' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=11
and tc.counts<=12

union all 

select '13-14' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=13
and tc.counts<14


union all 

select '15-16' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=15
and tc.counts<=16


union all 

select '17-18' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=17
and tc.counts<=18


union all 

select '19-20' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=19
and tc.counts<=20

union all 

select '21-22' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=21
and tc.counts<=22


union all 

select '23-24' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=23
and tc.counts<=24

union all 

select '>=25' 区间,count(distinct tc.charge_user_id) '充值人数',sum(tc.counts) '充值次数',sum(tc.rmb_value) '充值金额' 
from (
select tc.charge_user_id,count(1) counts,sum(tc.rmb_value) rmb_value 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.charge_user_id
) tc
where tc.counts>=25;
