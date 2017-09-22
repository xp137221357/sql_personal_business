
select t1.*,t2.value '充值' from(
select t.USER_ID,tu.ROOT_USER_NAME '总代理名称',e.CRT_TIME '注册时间',t.CRT_TIME '充值时间',e.IP,e.DEVICE_CODE,tf.IMEI,tf.IDFA,sum(ai.CHANGE_VALUE) '投注' from report.t_stat_first_recharge t 
inner join report.t_trans_user_attr tu on t.USER_ID=tu.USER_ID and tu.CHANNEL_NO='baidu'
inner join forum.t_user_event e on e.USER_ID=t.USER_ID and e.EVENT_CODE='reg' 
left join forum.t_device_info tf on e.DEVICE_CODE=tf.DEVICE_CODE 
left join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin') and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and ai.pay_TIME>=curdate()
where t.CRT_TIME>=curdate()
group by t.USER_ID
) t1 

left join (

select t.USER_ID,e.CRT_TIME '注册时间',t.CRT_TIME '充值时间',e.IP,e.DEVICE_CODE,tf.IMEI,tf.IDFA,sum(ai.CHANGE_VALUE) value from report.t_stat_first_recharge t 
inner join report.t_trans_user_attr tu on t.USER_ID=tu.USER_ID and tu.CHANNEL_NO='baidu'
inner join forum.t_user_event e on e.USER_ID=t.USER_ID and e.EVENT_CODE='reg' 
left join forum.t_device_info tf on e.DEVICE_CODE=tf.DEVICE_CODE 
left join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_EVENT = 'buy_diamend' and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1003 and ai.pay_TIME>=curdate()
where t.CRT_TIME>=curdate()
group by t.USER_ID
) t2 on t1.user_id=t2.user_id;


select * from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.USER_ID='11559096';


select * from report.t_trans_user_recharge_coin tc where tc.charge_user_id='11559096';