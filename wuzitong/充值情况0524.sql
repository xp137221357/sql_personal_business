set @param0='2017-05-12';
set @param1='2017-05-22 23:59:59';

select concat(@param0,'~',@param1),count(distinct u.USER_ID),
sum(t.rmb_value) from (
select tc.charge_user_id,tc.charge_method,tc.rmb_value,tc.crt_time,0 is_b from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0
and tc.crt_time<=@param1

union all

select tc.charge_user_id,tc.charge_method,tc.rmb_value,tc.crt_time,1 is_b from report.t_trans_user_recharge_diamond tc 
where tc.crt_time>=@param0
and tc.crt_time<=@param1
) t 
inner join report.t_trans_user_attr u on t.charge_user_id=u.USER_ID and u.CHANNEL_NO='apple'
and u.crt_time>=@param0
and u.crt_time<=@param1;
