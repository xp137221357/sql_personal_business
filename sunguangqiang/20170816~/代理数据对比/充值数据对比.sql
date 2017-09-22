

select t.USER_ID,t.OFFICIAL_PAY_MONEY,t.OTHER_PAY_MONEY from t_partner_order_info t 
where t.STAT_TIME='2017-08-29' and (t.OFFICIAL_PAY_MONEY>0 OR t.OTHER_PAY_MONEY>0)
group by t.USER_ID

) t1

left join (


select t.USER_ID,t.OFFICIAL_PAY_NUMBER,t.OFFICIAL_PAY_MONEY,t.OTHER_PAY_NUMBER,t.OTHER_PAY_MONEY from game.t_partner_order_info t 
where t.EXPECT='20170829' and t.`TYPE`=1 and (t.OFFICIAL_PAY_NUMBER>0 OR t.OTHER_PAY_NUMBER>0)
group by t.USER_ID

)t2 on t1.user_id =t2.user_id
where t2.user_id is null;


select t.*
from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID 
where t.crt_time>='2017-08-29 12:00:00'
and t.crt_time<'2017-08-30 12:00:00'
and u.USER_CODE='1257197888682598474';


select
date_add('2017-08-30',interval -1 day) STAT_TIME,
if(tc.charge_user_id is not null,tf.user_id,null) user_id,
sum(if(tc.charge_method='app',tc.coins,0)) OFFICIAL_PAY_MONEY,
sum(if(tc.charge_method!='app',tc.coins,0)) OTHER_PAY_MONEY
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
inner join game.t_group_ref tf on tf.USER_ID=u.USER_CODE and u.USER_CODE='1257197888682598474'
and tc.crt_time>=date_add('2017-08-30',interval -12 hour)
and tc.crt_time< date_add('2017-08-30',interval 12 hour);

