


select 
u.NICK_NAME '用户昵称',
u.ACCT_NUM '用户会员号',
t.USER_ID '用户ID',
u.CRT_TIME '用户注册时间',
u.USER_MOBILE '用户联系方式',
ifnull(t.bet_coins,0) '足球投注',
ifnull(t.prize_coins,0) '足球返奖',
ifnull(t.bk_bet_coins,0) '篮球投注',
ifnull(t.bk_prize_coins,0) '篮球返奖',
ifnull(t.yl_bet_coins,0) '娱乐场投注',
ifnull(t.yl_prize_coins,0)+ifnull(t.yl_return_coins,0) '娱乐场返奖'

from t_user_event_20170621 t
inner join forum.t_user u on t.user_id=u.USER_ID

and u.USER_ID not in (


	select 
	 e.user_id
	 from forum.t_user_event e 
	inner join forum.t_user u on e.USER_ID=u.USER_ID
	inner join report.t_stat_inner_ip_address t on e.IP like concat(t.inner_ip,'%')
	left join report.t_user_merchant t1 on u.USER_ID=t1.USER_ID
	where e.DEVICE_CODE in (
	select e.DEVICE_CODE from forum.t_user_event e where e.USER_ID in ('683714','116327')
	group by e.DEVICE_CODE)
	and t1.USER_ID is null
	group by e.USER_ID

);


