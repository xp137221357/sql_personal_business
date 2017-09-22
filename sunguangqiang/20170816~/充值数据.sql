-- 总充值金币（官充+第三方）				第三方充金币				官充金币			
-- 新充人数	新充金额	总充人数	总充金额	新充人数	新充金额	充值人数	充值金额	新充人数	新充金额	充值人数	充值金额

set @param0='2017-09-12 10:00:00';
set @param1='2017-09-13 00:00:00';
select * from(
select
date(tc.crt_time) stat_time,
count(distinct u.user_id) '新充人数',
sum(if(u.user_id is not null,tc.rmb_value,0)) '新充金额',
sum(if(u.user_id is not null,tc.coins,0)) '新充金币数',
count(distinct tc.charge_user_id) '充值人数',
sum(tc.rmb_value) '充值金额',
sum(tc.coins) '充值金币数'
from report.t_trans_user_recharge_coin tc 
left join forum.t_user u on tc.charge_user_id=u.USER_ID and date(tc.crt_time)=date(u.CRT_TIME)
where tc.crt_time>=@param0
and tc.crt_time<@param1
group by stat_time
) t1 
left join (
select
date(tc.crt_time) stat_time,
count(distinct u.user_id) '新第三方充人数',
sum(if(u.user_id is not null,tc.rmb_value,0)) '新第三方充金额',
sum(if(u.user_id is not null,tc.coins,0)) '新第三方充金币数',
count(distinct tc.charge_user_id) '第三方充值人数',
sum(tc.rmb_value) '第三方充值金额',
sum(tc.coins) '第三方充值金币数'
from report.t_trans_user_recharge_coin tc 
left join forum.t_user u on tc.charge_user_id=u.USER_ID and date(tc.crt_time)=date(u.CRT_TIME)
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method!='app'
group by stat_time
) t2 on t1.stat_time=t2.stat_time

left join (
select
date(tc.crt_time) stat_time,
count(distinct u.user_id) '新官充充人数',
sum(if(u.user_id is not null,tc.rmb_value,0)) '新官充金额',
sum(if(u.user_id is not null,tc.coins,0)) '新官充金币数',
count(distinct tc.charge_user_id) '官充充值人数',
sum(tc.rmb_value) '官充充值金额',
sum(tc.coins) '官充充值金币数'
from report.t_trans_user_recharge_coin tc 
left join forum.t_user u on tc.charge_user_id=u.USER_ID and date(tc.crt_time)=date(u.CRT_TIME)
where tc.crt_time>=@param0
and tc.crt_time<@param1
and tc.charge_method='app'
group by stat_time
) t3 on t1.stat_time=t3.stat_time