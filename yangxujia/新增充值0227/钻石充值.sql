set @param0='2017-02-20';
set @param1='2017-02-26 23:59:59';
-- set @param2='';

-- 按渠道首次购买钻石金额
select count(distinct td.charge_user_id),ifnull(sum(td.rmb_value),0) 
from report.t_trans_user_recharge_diamond td 
inner join forum.t_user_event ue on ue.event_code='reg' and ue.USER_ID = td.charge_user_id
inner join t_stat_first_recharge_dmd ts on ts.USER_ID = td.charge_user_id
and td.crt_time>=@param0
and td.crt_time<=@param1
and ts.crt_time >=@param0 
and ts.crt_time <=@param1;