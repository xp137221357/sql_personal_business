set @param0 = '2017-03-20'; 
set @param1 = '2017-03-26 23:59:59';

-- 总充值
select count(distinct tc.charge_user_id),sum(tc.rmb_value) from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1;

-- 官方总充值
select count(distinct tc.charge_user_id),sum(tc.rmb_value) from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app';

-- 第三方
select count(distinct tc.charge_user_id),sum(tc.rmb_value) from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method!='app';




--  新增充值钻石
select count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_diamond td
inner join report.t_stat_first_recharge_dmd tdd on td.charge_user_id=tdd.USER_ID
where td.crt_time>=@param0
and td.crt_time<@param1
and tdd.crt_time>=@param0
and tdd.crt_time<=@param1;


--  新增官充金币

select count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_coin td
inner join report.t_stat_first_recharge_coin tdd on td.charge_user_id=tdd.USER_ID
where td.crt_time>=@param0
and td.crt_time<=@param1
and tdd.crt_time>=@param0
and tdd.crt_time<=@param1
and td.charge_method='app';


--  新增第三方

select count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_coin td

where td.crt_time>=@param0
and td.crt_time<=@param1
and tdd.crt_time>=@param0
and tdd.crt_time<=@param1and
and td.charge_method!='app';


--  新金币

select count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_coin td
inner join report.t_stat_first_recharge_coin tdd on td.charge_user_id=tdd.USER_ID
where td.crt_time>=@param0
and td.crt_time<=@param1
and tdd.crt_time>=@param0
and tdd.crt_time<=@param1;

-- 首次官方充值

select count(distinct tc.charge_user_id),sum(tc.rmb_value) 
from report.t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time from (
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t  where t.charge_method ='APP'
group by t.charge_user_id
)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 
group by tt.charge_user_id
) t on tc.charge_user_id=t.charge_user_id
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app'
and tc.charge_user_id not in (select user_id from report.t_user_merchant);

-- 首次第三方充值
select count(distinct tc.charge_user_id),sum(tc.rmb_value) 
from report.t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time from (
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t  where t.charge_method !='APP'
group by t.charge_user_id
)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 
group by tt.charge_user_id
) t on tc.charge_user_id=t.charge_user_id
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method!='app'
and tc.charge_user_id not in (select user_id from report.t_user_merchant);









