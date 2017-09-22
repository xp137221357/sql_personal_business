yangxj(杨旭佳) 09-18 10:11:11
能把15~17号3天的充值记录给我导出一下吗
yangxj(杨旭佳) 09-18 10:12:28
 用户ID  渠道 注册时间  充值时间  充值金额 IDFA/IMEI IP 设备号 
 
set @param0='2017-09-15';
set @param1='2017-09-18';

select 
ai.USER_ID '用户ID',
e.CHANNEL_NO '渠道',
e.CRT_TIME '注册时间',
ai.PAY_TIME '充值时间',
ai.CHANGE_VALUE '充值金额',
tf.IDFA,
tf.IMEI,
tf.IP,
e.DEVICE_CODE '设备号'

 from forum.t_acct_items ai
left join forum.t_user_event e on ai.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
left join forum.t_device_info tf on e.DEVICE_CODE=tf.DEVICE_CODE

where ai.ITEM_STATUS=10
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='buy_diamend'
and ai.ACCT_TYPE=1003
and ai.ITEM_SRC!=10;