

SELECT * FROM forum.t_user u where u.NICK_NAME='梅州客家';

-- 1118261


select u.NICK_NAME '用户昵称',u.USER_ID 'user_id',u.ACCT_NUM '会员号',e.DEVICE_CODE '设备号',e.IP 'ip' 
from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID
where e.DEVICE_CODE in (
	select e.DEVICE_CODE from forum.t_user_event e 
	where e.DEVICE_CODE in (
	 select e.DEVICE_CODE from forum.t_user_event e 
	 where e.USER_ID='1118261'
	 group by e.DEVICE_CODE
	)
	group by e.DEVICE_CODE
)
group by e.USER_ID,e.DEVICE_CODE,e.IP
;



select u.NICK_NAME '用户昵称',u.USER_ID 'user_id',u.ACCT_NUM '会员号',e.DEVICE_CODE '设备号',e.IP 'ip' 
from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID
where e.ip in (
	select e.ip from forum.t_user_event e 
	where e.ip in (
	 select e.ip from forum.t_user_event e 
	 where e.USER_ID='1118261'
	 group by e.ip
	)
	group by e.ip
)
group by e.USER_ID,e.DEVICE_CODE,e.IP
;
-- 每个子用户5.1-5.25 的充值 投注 返奖 数据

set @param0='2017-05-01';
set @param1='2017-05-25 23:59:59';

select concat(@param0,'~',@param1),t1.*,t2.value '投注金币',t3.value '返奖金币',t4.value '充值金币' from (
	select u.USER_CODE,u.NICK_NAME '昵称',u.ACCT_NUM '会员号'
		from game.t_group_ref t 
		inner join forum.t_user u on t.USER_ID=u.user_code
		where t.REF_ID in (424542,424632,424812,424815,424818,424821,424824)
) t1 left join (

	select o.USER_ID,sum(o.COIN_BUY_MONEY) value from game.t_order_item o 
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.USER_ID in (
		select t.USER_ID 
		from game.t_group_ref t 
		where t.REF_ID in (424542,424632,424812,424815,424818,424821,424824)
	)
	group by o.USER_ID
) t2 on t1.user_code=t2.user_id

left join (

select o.USER_ID,ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) value 
from game.t_order_item o 
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.USER_ID in (
		select t.USER_ID 
		from game.t_group_ref t 
		where t.REF_ID in (424542,424632,424812,424815,424818,424821,424824)
	)
	group by o.USER_ID
) t3 on t1.user_code=t3.user_id

left join (
	
	select u.USER_CODE,sum(tc.coins) value from report.t_trans_user_recharge_coin tc 
	inner join forum.t_user u on tc.charge_user_id=u.USER_ID
	and u.USER_CODE in (
		select t.USER_ID 
		from game.t_group_ref t 
		where t.REF_ID in (424542,424632,424812,424815,424818,424821,424824)
	)
	where tc.crt_time>=@param0
	and  tc.crt_time<=@param1
	group by u.USER_ID
) t4 on t1.user_code=t4.USER_CODE;





 
 
 
 