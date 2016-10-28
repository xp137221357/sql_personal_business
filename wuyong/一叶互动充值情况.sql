set @beginTime='2016-08-21';
set @endTime='2016-09-26 23:59:59';


select sum(tc.rmb_value),sum(tc.coins) from report.t_trans_user_recharge_coin tc 
inner join forum.t_user_event te on tc.charge_user_id = te.USER_ID and te.CHANNEL_NO = 'baiyin_gd' 
where TC.CRT_TIME>=@beginTime and TC.CRT_TIME<=@endTime




 