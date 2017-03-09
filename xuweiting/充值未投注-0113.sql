set @param0='2016-11-01 00:00:00'; -- 起始时间
set @param1= '2016-11-01 23:59:59'; -- 结束时间
set @param3=0; -- 0：官充，1：第三方充值
-- set param=['2016-11-01 00:00:00','2016-11-30 23:59:59',0]
-- 参数1-起始时间
-- 参数2-结束时间
-- 参数3-0：官充，1：第三方充值
select 
concat(@param0,'~',@param1) '无投注时间段',
u.NICK_NAME'用户名',
u.USER_ID '用户ID',
u.USER_MOBILE '联系方式',
case u.`STATUS`
	when 0 then '待激活'
	when 10 then '有效'
	when 11 then '冻结'
	when 12 then '无效'
end as '用户状态',
sum(if(tc.charge_method='APP',tc.coins,0)) app_coins,
sum(if(tc.charge_method!='APP',tc.coins,0)) third_coins
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID and tc.crt_time<@param0 
left join (
	select
	oi.USER_ID
	from game.t_order_item oi
	where  
	oi.CHANNEL_CODE = 'GAME' 
	and oi.COIN_BUY_MONEY>0
	and oi.PAY_TIME >= @param0 
	and oi.PAY_TIME <= @param1
	group by oi.USER_ID
	
) t1 on u.USER_CODE=t1.user_id
where t1.user_id is null