

-- 提现
-- 查询时间：2017.5.1-8.15
-- 第三方提现：第三方与第三方之间的答题不计算入内，只计算第三方与用户之间的答题；
-- 第三方比例：1元=140金币；
set @param0='2017-05-01';
set @param1='2017-08-16';

-- 第三方每笔提现金额
select '0-100' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=0
and tc.coins<100

union all 

select '100-300' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=100
and tc.coins<300


union all 

select '300-500' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=300
and tc.coins<500

union all 

select '500-800' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=500
and tc.coins<800


union all 

select '800-1000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=800
and tc.coins<1000


union all 

select '1000-2000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=1000
and tc.coins<2000

union all 

select '2000-3000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=2000
and tc.coins<3000


union all 

select '3000-4000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=3000
and tc.coins<4000


union all 

select '4000-5000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=4000
and tc.coins<5000


union all 

select '5000-6000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=5000
and tc.coins<6000

union all 

select '6000-7000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=6000
and tc.coins<7000


union all 

select '7000-8000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=7000
and tc.coins<8000

union all 

select '8000-9000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=8000
and tc.coins<9000


union all 

select '9000-10000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=9000
and tc.coins<10000


union all 

select '10000-20000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=10000
and tc.coins<20000


union all 

select '20000-30000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=20000
and tc.coins<30000


union all 

select '30000-40000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=30000
and tc.coins<40000


union all 

select '40000-50000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=40000
and tc.coins<50000


union all 

select '>=50000' 区间,count(distinct tc.user_id) '提现人数',sum(tc.counts) '提现次数',sum(tc.coins) '提现金额' 
from (
select tc.user_id,count(1) counts,round(sum(tc.coins)/139) coins 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by tc.user_id
) tc
where tc.coins>=50000;
