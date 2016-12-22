set @param0='2016-11-21';
set @param1='2016-11-23 23:59:59';

set @param2='2016-11-21';
set @param3='2016-11-29 23:59:59';

-- 激活-第三方
select u.NICK_NAME,u.USER_ID,sum(ttc.rmb_value) rmb_value from forum.t_device_info t
inner join forum.t_user u on u.USER_CODE=t.USER_CODE
AND t.ADD_TIME>=@param0
and t.ADD_TIME<=@param1
and t.REG_CHANNEL='qq'
inner join (
  select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc
 -- where tc.charge_method!='APP'
  group by tc.charge_user_id
) tc on u.user_id=tc.charge_user_id 
INNER JOIN report.t_trans_user_recharge_coin ttc on ttc.charge_user_id=tc.charge_user_id 
and ttc.crt_time>= @param2 and ttc.crt_time<= @param3 -- and ttc.charge_method!='APP'
group by u.USER_ID;


-- 注册-第三方
select u.NICK_NAME,u.USER_ID,sum(ttc.rmb_value) rmb_value from forum.t_user_event te 
inner join forum.t_user u on u.USER_ID=te.USER_ID
and te.CRT_TIME>=@param0
and te.CRT_TIME<=@param1
and te.EVENT_CODE='REG'
and t.REG_CHANNEL='qq'
and te.CHANNEL_NO='qq'
inner join (
  select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc
  where tc.charge_method!='APP'
  group by tc.charge_user_id
) tc on u.user_id=tc.charge_user_id 
INNER JOIN report.t_trans_user_recharge_coin ttc on ttc.charge_user_id=tc.charge_user_id 
and ttc.crt_time>= @param2 and ttc.crt_time<= @param3 and ttc.charge_method!='APP'
group by u.USER_ID





