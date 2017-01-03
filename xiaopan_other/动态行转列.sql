
-- 逆天动态行转列
-- 要用到 GROUP_CONCAT
SHOW VARIABLES LIKE "group_concat_max_len";  
SET GLOBAL group_concat_max_len=102400;
SET SESSION group_concat_max_len=102400; 

SET @sql = NULL;
SET @stuid = '1003';
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'MAX(IF(c.coursenm = ''',
   c.coursenm,
   ''', s.scores, 0)) AS ''',
   c.coursenm, ''''
  )
 ) INTO @sql
FROM courses c;
 
SET @sql = CONCAT('Select st.stuid, st.stunm, ', @sql, 
            ' From Student st 
            Left Join score s On st.stuid = s.stuid
            Left Join courses c On c.courseno = s.courseno
            Where st.stuid = ''', @stuid, '''
            Group by st.stuid');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'MAX(IF(c.AWARD_NAME = ''',
   c.AWARD_NAME,
   ''', c.ORIGNAL_MONEY, 0)) AS ''',
   c.AWARD_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_activity_award c;
 
SET @sql = CONCAT('Select c.ORIGNAL_MONEY, ', @sql, 
            ' From forum.t_activity_award c');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


