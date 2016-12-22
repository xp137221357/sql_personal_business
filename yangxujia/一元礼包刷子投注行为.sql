set @param0='2016-09-14';
set @param1='2016-10-30 23:59:59';


select 
date_format(u.crt_time,'%x-%v') '注册时间',
u.crt_time '周开始日期',
count(distinct t.user_id) '用户数',
COUNT(distinct o.USER_ID)'投注用户数',
sum(o.COIN_BUY_MONEY) '投注金币',
sum(o.P_COIN_BUY_MONEY)'投注体验币' from 
( 
	select user_id from forum.t_user_freeze_log t 
	where t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys' 
	group by user_id
)t 
inner join forum.t_user u on u.USER_ID = t.user_id and u.crt_time>=@param0 and u.crt_time<=@param1
left join game.t_order_item o on o.USER_ID=u.USER_CODE
group by date_format(u.crt_time,'%x-%v') 



select date_add(date('2016-09-18 19:36:19'), interval 2-dayofweek(date('2016-09-18 19:36:19')) day)



select date_add(date_add(@param0, interval 2-dayofweek(@param0) day),interval -1 week)


select 3-dayofweek('2016-11-13')