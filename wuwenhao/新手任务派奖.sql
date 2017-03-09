


-- set param=['2016-11-03 00:00:00','2016-11-05 23:59:59','新手任务']
set @param0='2016-11-03 00:00:00';
set @param1='2017-11-05 23:59:59';
set @param2='新手任务';

select t1.rwlx AS'项目类型',
t1.`ORDER` '项目关卡',
t1.nick_name '用户昵称',
t1.AWARD_NAME '奖励',
t1.update_time '达成时间',
t1.lqcj '领取时间',
t1.zcsj '注册时间',
t1.wcts '完成时间(天)',
t1.ACCT_NUM '会员号',
t1.rmb_value_sum '总充值金额',
t1.crt_time '最近一次充值时间',
t1.USER_MOBILE '用户手机',
ts.ADDRESS '用户地址',
ifnull(t2.fhq_cnt,0) '复活券使用数', ifnull(t3.yhq_cnt,0) '优惠券使用数' from (
select IF(t.TASK_TYPE = 1,'新手任务',IF(t.TASK_TYPE = 2,'投注奖励','中奖成就'))rwlx,
t.`ORDER`,u.nick_name,
aa.AWARD_NAME,
date_format(ut.update_time,'%Y-%m-%d')update_time,
date_format(ut.PRIZE_TIME,'%Y-%m-%d')lqcj,
date_format(u.CRT_TIME,'%Y-%m-%d')zcsj,
DATEDIFF(date(ut.update_time),if(date(u.CRT_TIME)<='2016-11-03','2016-11-03',date(u.CRT_TIME)))wcts,
u.ACCT_NUM,u.user_id,
urc.rmb_value_sum,
date_format(urc.crt_time,'%Y-%m-%d')crt_time,
u.USER_MOBILE
from  forum.t_user u 
inner join game.t_user_task ut on u.user_code = ut.user_id and ut.is_prize ='1'
inner join game.t_task t on ut.task_id = t.id 
inner join game.t_task_award_ref tar on tar.task_id = ut.task_id and tar.version = ut.version and tar.`status`='1'
inner join game.t_activity_award aa on tar.award_id = aa.award_id
inner join (
	select urc.charge_user_id,sum(urc.rmb_value) rmb_value_sum,max(urc.crt_time)crt_time from t_trans_user_recharge_coin urc 
	group by urc.charge_user_id
)urc on urc.charge_user_id = u.USER_ID
where ut.update_time >= @param0 and ut.update_time <=@param1 and u.NICK_NAME  not in ('aaa168','byzq2288766','byzq2315967','依心而行','好彩','全身隐','江湖人','wei001','飞虎','杰少001','林大侠001','百发百中001','飞马7号','百盈广东总代','狠狠滴刮','绿灯行','红绿灯','大刮','赢8')
)t1 left join (

select ai.USER_ID, '复活券'award_name,  count(1) fhq_cnt from forum.t_acct_items ai where ai.ITEM_STATUS = 10 
and ai.ITEM_EVENT in ('COUPON_TO_PCOIN')
group by ai.USER_ID
)t2
 on t1.user_id = t2.user_id and t1.AWARD_NAME = t2.award_name
 left join (

select ai.USER_ID, if(ai.CHANGE_VALUE = 100, '400元充值优惠券', if(ai.CHANGE_VALUE = 50, '100元充值优惠券', ai.CHANGE_VALUE)) award_name,
 count(1) yhq_cnt
from forum.t_acct_items ai 
where ai.ITEM_STATUS = 10 
and ai.ITEM_EVENT in ('RECHARE_COUPON_GIVE_DIAMOND')
group by ai.USER_ID, ai.CHANGE_VALUE)t3
on t1.user_id = t3.user_id and t1.AWARD_NAME = t3.award_name
left join forum.t_user_address ts on t1.USER_ID=ts.user_id and ts.IS_DEFAULT=1
where t1.rwlx = @param2 and t1.update_time >= @param0 and t1.update_time <=@param1;