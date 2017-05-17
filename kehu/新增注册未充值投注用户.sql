set @param0 = '2017-03-01'; 
set @param1 = '2017-03-23 23:59:59';

select td.CHANNEL_NAME '渠道名',e.CHANNEL_NO '渠道编码',
u.NICK_NAME '用户昵称',u.USER_ID'用户ID',u.USER_MOBILE '联系方式',u.LAST_ONLINE_TIME'最后在线时间',
date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%S') '注册时间',
e.DEVICE_CODE'设备号',e.IP'ip地址',
round(sum(o.COIN_BUY_MONEY)) '投注金币',
round(sum(o.P_COIN_BUY_MONEY)) '投注体验币',
count(1) '投注次数'
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE 
inner join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg' 
left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO and td.SYSTEM_MODEL=e.SYSTEM_MODEL
left join report.t_trans_user_recharge_coin tc on u.USER_ID=tc.charge_user_id 
where tc.charge_user_id is null 
and u.CRT_TIME>=@param0
and u.CRT_TIME<=@param1
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.CHANNEL_CODE='game'
group by o.USER_ID