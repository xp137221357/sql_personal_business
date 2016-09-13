-- 官充以及第三方充值数据


-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59



set @beginTime = '2016-08-28 00:00:00';
set @endTime = '2016-08-28 23:59:59';

select 'P','官充及第三方新增充值',concat(@beginTime,'~',@endTime) '时间','all',
count(DISTINCT tc.charge_user_id) '充值人数',
sum(ifnull(coins,0)) '充值金币数'
from t_trans_user_recharge_coin tc 
inner join (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
and tfc.crt_time>=@beginTime and tfc.crt_time<=@endTime
and tc.crt_time>=@beginTime and tc.crt_time<=@endTime 

union all

select 'P','官充及第三方充值',concat(@beginTime,'~',@endTime) '时间','all',
count(DISTINCT charge_user_id) '充值人数',
sum(ifnull(coins,0)) '充值金币数'
from t_trans_user_recharge_coin tc 
where tc.crt_time>=@beginTime and tc.crt_time<=@endTime
;


/*
-- 合并代码
select 'P','官充及第三方新增充值',concat(@beginTime,'~',@endTime) '时间','all',
count(DISTINCT tc.charge_user_id) '充值人数',
count(DISTINCT tfc.charge_user_id) '新增充值人数'
from t_trans_user_recharge_coin tc 
left join (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
and tfc.crt_time>=@beginTime and tfc.crt_time<=@endTime
where tc.crt_time>=@beginTime and tc.crt_time<=@endTime 
*/




-- select * from t_trans_user_recharge_coin tc  limit 100




