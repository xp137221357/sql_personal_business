
set @param0='2017-01-01';
set @param1='2017-01-31 23:59:59';


select * from (
select sum(tc.rmb_value) '金币金额' from report.t_trans_user_recharge_coin tc
inner join report.v_user_boss v on tc.charge_user_id=v.USER_ID 
where tc.crt_time>=@param0
and tc.crt_time<=@param1) t1,
(select sum(td.rmb_value) '钻石金额' from report.t_trans_user_recharge_diamond td
inner join report.v_user_boss v on td.charge_user_id=v.USER_ID 
where td.crt_time>=@param0
and td.crt_time<=@param1
) t2;



