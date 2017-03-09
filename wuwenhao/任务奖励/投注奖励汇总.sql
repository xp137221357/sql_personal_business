set @param0='2017-01-02';
set @param1='2017-03-05 23:59:59';

	
-- 按周汇总数据
select concat(date_format(ut.PRIZE_TIME,'%x-%v'),'周') stat_time,count(distinct ut.USER_ID) '人数',sum(ta.award_value) '金币'
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1 
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id 
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	WHERE  ut.PRIZE_TIME >= @param0
	  and  ut.PRIZE_TIME <= @param1
	group by stat_time;
	


-- 最高关卡数据
select concat(date_format(ut.PRIZE_TIME,'%x-%v'),'周') stat_time,max(t.`ORDER`) '最高关卡'
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1 
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id 
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID 
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	WHERE  ut.PRIZE_TIME >= @param0
	  and  ut.PRIZE_TIME <= @param1
	group by stat_time;
	

set @param0='2017-02-27';
set @param1='2017-03-05 23:59:59';
-- 详细数据
select concat(date_format(ut.PRIZE_TIME,'%x-%v'),'周') stat_time,t.desc,count(ut.USER_ID) '人数',count(ut.USER_ID)*ta.award_value '金币'
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1 
	inner join report.t_trans_user_attr tu on tu.USER_CODE=ut.user_id
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	WHERE  ut.PRIZE_TIME >= @param0
	  and  ut.PRIZE_TIME <= @param1
	group by stat_time,t.ID;
	