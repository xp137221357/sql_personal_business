-- 总领取币

select t.NICK_NAME '代理用户昵称',round(sum(CHANGE_VALUE)/140) '任务领取金币' from(
select t1.NICK_NAME ,sum(ai.CHANGE_VALUE) CHANGE_VALUE from forum.t_acct_items ai 
inner join (
		SELECT 
		       distinct u.user_id,u2.NICK_NAME,u2.USER_CODE
		FROM   forum.t_user u
		       INNER JOIN game.t_group_ref r1
		               ON u.user_code = r1.user_id
		       INNER JOIN game.t_group_ref r2
		               ON r1.root_id = r2.ref_id
		       INNER JOIN forum.t_user u2
		               ON r2.user_id = u2.user_code
		       AND u2.USER_CODE in ('3376891259540608627','7718091376719030707','1349154694028488837',
														'8390286705788425526','8320488347014610078','2785464073502998941',
														'6781200958683944878','3468790449673358420','4438966596506454331'
														)
		WHERE  u.client_id = 'BYAPP'
) t1 on ai.USER_ID=t1.user_id
where ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
and ai.CHANGE_TYPE=0
and ai.ITEM_STATUS=10
and ai.ADD_TIME<'2017-03-06 12:00:00'
group by t1.NICK_NAME


union all

select u.NICK_NAME,sum(ai.CHANGE_VALUE) CHANGE_VALUE
from forum.t_acct_items ai 
INNER JOIN forum.t_user u ON ai.user_id = u.user_id
AND u.USER_CODE in ('3376891259540608627','7718091376719030707','1349154694028488837',
														'8390286705788425526','8320488347014610078','2785464073502998941',
														'6781200958683944878','3468790449673358420','4438966596506454331'
														)
where ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.ITEM_EVENT='user_task'
and ai.ITEM_STATUS=10
and ai.ADD_TIME<'2017-03-06 12:00:00'
group by u.NICK_NAME
) t group by t.NICK_NAME;



-- 投注奖励，领取币

select tt.NICK_NAME,round(sum(tt.coins)/140) from(
select t1.NICK_NAME,sum(ta.award_value) coins
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	inner join (
		SELECT 
			       distinct u.user_code,u2.NICK_NAME
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN forum.t_user u2
			               ON r2.user_id = u2.user_code
			       AND u2.USER_CODE in ('3376891259540608627','7718091376719030707','1349154694028488837',
															'8390286705788425526','8320488347014610078','2785464073502998941',
															'6781200958683944878','3468790449673358420','4438966596506454331'
															)
			WHERE  u.client_id = 'BYAPP'
	)t1 on ut.USER_ID=t1.user_code
	WHERE   ut.PRIZE_TIME<'2017-03-06 12:00:00'
	group by NICK_NAME
	
	union all
	
	select t1.NICK_NAME,sum(ta.award_value) coins
	FROM   
	game.t_user_task ut
	INNER JOIN game.t_task t ON t.id = ut.task_id AND t.`status` = 1 AND t.task_type = 2 and ut.IS_PRIZE=1
	inner join game.t_task_award_ref tr on t.ID=tr.TASK_ID
	inner join game.t_activity_award ta on tr.AWARD_ID=ta.AWARD_ID and ta.AWARD_ATTR=1001
	inner join (
		SELECT 
			       distinct u.user_code,u.NICK_NAME
			FROM   forum.t_user u
			       where u.USER_CODE in ('3376891259540608627','7718091376719030707','1349154694028488837',
															'8390286705788425526','8320488347014610078','2785464073502998941',
															'6781200958683944878','3468790449673358420','4438966596506454331'
															)
			and  u.client_id = 'BYAPP'
	)t1 on ut.USER_ID=t1.user_code
	WHERE   ut.PRIZE_TIME<'2017-03-06 12:00:00'
	group by NICK_NAME
	
	) tt group by tt.NICK_NAME




