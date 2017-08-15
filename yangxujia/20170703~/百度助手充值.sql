set @param0 = '2017-06-26'; 
set @param1 = '2017-07-03';


select e.USER_ID '用户ID',e.DEVICE_CODE '设备号',e.IP 'ip地址',e.EVENT_PARAM '参数',sum(tc.rmb_value) '充值金额' 
from forum.t_user_event e
inner join report.t_trans_user_recharge_coin tc on e.USER_ID=tc.charge_user_id and e.CHANNEL_NO='baidu'
where e.CRT_TIME>=@param0
and e.CRT_TIME<@param1
and e.EVENT_CODE='reg'
group by e.USER_ID;