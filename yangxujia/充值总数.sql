
set @beginTime = '2016-09-01';
set @endTime = '2016-09-30 23:59:59';

select sum(tc.rmb_value) from t_trans_user_recharge_coin tc
where 
-- tc.charge_user_id not in (select user_id from v_user_boss) and 
tc.crt_time>=@beginTime and tc.crt_time<=@endTime;


select sum(tc.rmb_value) from t_trans_user_recharge_diamond tc

where tc.crt_time>=@beginTime and tc.crt_time<=@endTime;

