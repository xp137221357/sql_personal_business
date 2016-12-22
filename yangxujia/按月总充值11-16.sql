
set @param0='2016-10-01';
set @param1='2016-10-31 23:59:59';

select concat(@param0,'~',@param1) '时间','金币充值金额',sum(tc.rmb_value) rmb 
from report.t_trans_user_recharge_coin tc
where tc.crt_time>= @param0
and tc.crt_time<= @param1
union all
select concat(@param0,'~',@param1) '时间','钻石充值金额',sum(td.rmb_value) rmb 
from report.t_trans_user_recharge_diamond td
where td.crt_time>= @param0
and td.crt_time<= @param1