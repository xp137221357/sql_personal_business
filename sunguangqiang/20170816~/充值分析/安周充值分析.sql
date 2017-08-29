-- 充值
-- 查询时间：2017.5.1-8.15
-- 第三方充值：第三方与第三方之间的答题不计算入内，只计算第三方与用户之间的答题；
-- 第三方比例：1元=140金币；
set @param0='2017-05-01';
set @param1='2017-08-14';

-- 安周充值金额
select '官充',date_format(tc.crt_time,'%x%v') stat_time,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
group by stat_time

union all 

select '第三方充',date_format(tc.crt_time,'%x%v') stat_time,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method!='app'
group by stat_time

union all 


select '同时官充及第三方充值',t1.stat_time,count(distinct t1.charge_user_id) '充值人数',sum(t1.counts)+sum(t2.counts) '充值次数',sum(t1.rmb_value)+sum(t2.rmb_value) '充值金额' from (
select tc.charge_user_id,date_format(tc.crt_time,'%x%v') stat_time,count(1) counts,sum(tc.rmb_value) rmb_value
from report.t_trans_user_recharge_coin tc   
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
group by stat_time,tc.charge_user_id
) t1
inner join ( 
select tc.charge_user_id,date_format(tc.crt_time,'%x%v') stat_time,count(1) counts,sum(tc.rmb_value) rmb_value
from report.t_trans_user_recharge_coin tc   
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method!='app'
group by stat_time,tc.charge_user_id
) t2 on t1.charge_user_id=t2.charge_user_id and t1.stat_time=t2.stat_time
group by t1.stat_time


union all 

select '仅官充',date_format(tc.crt_time,'%x%v') stat_time,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
left join report.t_trans_user_recharge_coin tc2 on tc.charge_user_id=tc2.charge_user_id and tc2.charge_method!='app' and date_format(tc.crt_time,'%x%v')=date_format(tc2.crt_time,'%x%v')
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
and tc2.charge_user_id is null
group by stat_time

union all 

select '仅第三方充',date_format(tc.crt_time,'%x%v') stat_time,count(distinct tc.charge_user_id) '充值人数',count(1) '充值次数',sum(tc.rmb_value) '充值金额' 
from report.t_trans_user_recharge_coin tc 
left join report.t_trans_user_recharge_coin tc2 on tc.charge_user_id=tc2.charge_user_id and tc2.charge_method='app' and date_format(tc.crt_time,'%x%v')=date_format(tc2.crt_time,'%x%v')
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method!='app'
and tc2.charge_user_id is null
group by stat_time;
