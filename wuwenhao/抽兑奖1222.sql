set @param0='2016-12-19';
set @param1='2016-12-25 23:30:00';
-- set @param3=24; -- 24


-- --------------------------------------------
-- 抽奖
SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'count(IF(td.AWARD_ID = ''',
   td.AWARD_ID,
   ''', 1, null)) AS ''',
   td.AWARD_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_activity_award td
inner join forum.t_act_award_ref r on r.AWARD_ID=td.AWARD_ID
inner join forum.t_activity taa on r.ACT_ID=taa.ACT_ID
where taa.ACT_ID=21;

SET @sql =CONCAT('
select 
date_format(ta.APPLY_TIME,''','%Y-%m-%d',''') stat_time,
taa.ACT_TITLE 期号,
count(distinct ta.USER_ID) 参与人数,
count(1) 参与次数,
sum(ta.COIN) 金币,
sum(ta.PCOIN) 体验币,'
, @sql,'
 from forum.t_activity_apply ta 
inner join forum.t_activity taa on ta.ACT_ID=taa.ACT_ID and ta.ACT_ID=21
inner join forum.t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join forum.t_user u on ta.USER_ID = u.user_id 
where ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=''',@param0,
''' and ta.APPLY_TIME<=''',@param1,
''' group by stat_time,taa.ACT_TITLE');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- --------------------------------------------
-- 兑奖
SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'count(IF(td.AWARD_ID = ''',
   td.AWARD_ID,
   ''', 1, null)) AS ''',
   td.AWARD_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_activity_award td
inner join forum.t_act_award_ref r on r.AWARD_ID=td.AWARD_ID
inner join forum.t_activity taa on r.ACT_ID=taa.ACT_ID
where taa.ACT_ID=24;

SET @sql =CONCAT('
select 
date_format(ta.APPLY_TIME,''','%Y-%m-%d',''') stat_time,
taa.ACT_TITLE 期号,
count(distinct ta.USER_ID) 参与人数,
count(1) 参与次数,
sum(ta.COIN) 金币,
sum(ta.PCOIN) 体验币,'
, @sql,'
 from forum.t_activity_apply ta 
inner join forum.t_activity taa on ta.ACT_ID=taa.ACT_ID and ta.ACT_ID=24
inner join forum.t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join forum.t_user u on ta.USER_ID = u.user_id 
where ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=''',@param0,
''' and ta.APPLY_TIME<=''',@param1,
''' group by stat_time,taa.ACT_TITLE');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;





