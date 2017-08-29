-- 提现值
-- 查询时间：2017.5.1-8.15
-- 第三方提现值：第三方与第三方之间的答题不计算入内，只计算第三方与用户之间的答题；
-- 第三方比例：1元=140金币；
set @param0='2017-05-01';
set @param1='2017-08-14';

-- 安周提现值金额
select '安月提现',date_format(tc.crt_time,'%Y-%m') stat_time,count(distinct tc.user_id) '提现值人数',count(1) '提现值次数',round(sum(tc.coins)/139) '提现值金额' 
from report.t_trans_user_withdraw tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by stat_time;

