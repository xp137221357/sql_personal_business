
set @param0='2017-02-27';
set @param1='2017-03-05 23:59:59';


-- 数据
select concat(date_format(ut.PRIZE_TIME,'%x-%v'),'周') stat_time,t.desc,count(ut.USER_ID) '人数',count(ut.USER_ID)*ta.award_value '金币'
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1 
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id and tu.SYSTEM_MODEL='ios'
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	WHERE  ut.PRIZE_TIME >= @param0
	  and  ut.PRIZE_TIME <= @param1
	group by stat_time,t.ID;
	
	
	
-- 方案一
select tt.desc,sum(tt.t1) '2017-02-26',sum(tt.t2) '2017-02-27',sum(tt.t3) '2017-02-28' from (
select
t.desc, 
t.id,
if (t.stat_time='2017-02-26',1,0) t1,
if (t.stat_time='2017-02-27',1,0) t2,
if (t.stat_time='2017-02-28',1,0) t3
 from (
	select t.id,t.desc,date_format(ut.crt_time,'%Y-%m-%d') stat_time 
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID
	WHERE  ut.crt_time >= @param0
	  and  ut.crt_time <= @param1
	group by stat_time,t.ID
) t group by t.id,t.stat_time
) tt group by tt.id ;  
       
       
-- 方案二
select t.`DESC`,ta.day_all,t0.day0,t1.day1,t2.day2 
from 
(
	select t.`DESC`,ta.AWARD_VALUE from t_task t 
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID
	where t.`status` = 1 AND t.task_type = 2
) t

left join (
	select t.desc,count(ut.USER_ID) day_all
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id and tu.SYSTEM_MODEL='android'
	WHERE ut.crt_time < now()
	group by t.ID
) ta on t.DESC=ta.DESC

left join (
	select t.desc,count(ut.USER_ID) day0
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id and tu.SYSTEM_MODEL='android'
	WHERE  ut.crt_time >= date_add(@param0,interval 0 day)
	  and  ut.crt_time < date_add(@param0,interval 1 day)
	group by t.ID
) t0 on t0.DESC=t.DESC
left join (
	select t.desc,count(ut.USER_ID) day1
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id and tu.SYSTEM_MODEL='android'
	WHERE  ut.crt_time >= date_add(@param0,interval 1 day)
	  and  ut.crt_time < date_add(@param0,interval 2 day)
	group by t.ID
) t1 on t1.DESC=t.DESC
left join(
	select t.desc,count(ut.USER_ID) day2
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id and tu.SYSTEM_MODEL='android'
	WHERE  ut.crt_time >= date_add(@param0,interval 2 day)
	  and  ut.crt_time < date_add(@param0,interval 3 day)
	group by t.ID
) t2 on t2.DESC=t.DESC;



