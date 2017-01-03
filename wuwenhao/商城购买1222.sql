set @param0='2016-12-01';
set @param1='2016-12-22 23:30:00';
-- set @param3='VIP';

-- t_code

-- CONFIG_DIAMEND
-- CONFIG_COIN
-- VIP

-- CHILD_CODE_VALUE  
-- CHILD_CODE_NAME
-- VIP

SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'count(IF(tc.CHILD_CODE_VALUE = ''',
   tc.CHILD_CODE_VALUE,
   ''', 1, null)) AS ''',
   tc.CHILD_CODE_VALUE, ''''
  )
 ) INTO @sql
FROM forum.t_code tc where tc.CODE='VIP';


SET @sql =CONCAT('
select 
date_format(ai.ADD_TIME,''','%Y-%m-%d',''') stat_time,
count(distinct ai.USER_ID) 参与人数,
count(1) 参与次数,'
, @sql,'
 from forum.t_acct_items ai
inner join forum.t_code tc on ai.CHANGE_VALUE=tc.CHILD_CODE_VALUE and tc.CODE=''','VIP','''
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT=''','BUY_VIP','''
and ai.ADD_TIME>=''',@param0,
''' and ai.ADD_TIME<=''',@param1,
''' group by stat_time');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ------------------------------------------------------------------
-- 钻石


SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'count(IF(tc.CHILD_CODE_VALUE = ''',
   tc.CHILD_CODE_VALUE,
   ''', 1, null)) AS ''',
   tc.CHILD_CODE_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_code tc where tc.CODE='CONFIG_DIAMEND';


SET @sql =CONCAT('
select 
date_format(ai.ADD_TIME,''','%Y-%m-%d',''') stat_time,
count(distinct ai.USER_ID) 参与人数,
count(1) 参与次数,'
, @sql,'
 from forum.t_acct_items ai
inner join forum.t_code tc on ai.CHANGE_VALUE=tc.CHILD_CODE_VALUE and tc.CODE=''','CONFIG_DIAMEND','''
and ai.ITEM_STATUS=10
and ((ai.COMMENTS not like ''','%underline%','''
and ai.COMMENTS not like ''','%buy_coin%',''') or ai.COMMENTS is null)
and ai.ITEM_EVENT=''','BUY_DIAMEND','''
and ai.ADD_TIME>=''',@param0,
''' and ai.ADD_TIME<=''',@param1,
''' group by stat_time');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- ----------------------------------------------------------------------------------------


-- ------------------------------------------------------------------
-- 道具


SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'count(IF(tc.CHILD_CODE_VALUE = ''',
   tc.CHILD_CODE_VALUE,
   ''', 1, null)) AS ''',
   tc.CHILD_CODE_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_code tc where tc.CODE='CONFIG_COIN';


SET @sql =CONCAT('
select 
date_format(ai.ADD_TIME,''','%Y-%m-%d',''') stat_time,
count(distinct ai.USER_ID) 参与人数,
count(1) 参与次数,'
, @sql,'
 from forum.t_acct_items ai
inner join forum.t_code tc on ai.CHANGE_VALUE=tc.CHILD_CODE_VALUE and tc.CODE=''','CONFIG_COIN','''
and ai.ITEM_STATUS=10
and ai.COMMENTS like ''','%buy_coin%','''
and ai.ITEM_EVENT=''','BUY_DIAMEND','''
and ai.ADD_TIME>=''',@param0,
''' and ai.ADD_TIME<=''',@param1,
''' group by stat_time');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


