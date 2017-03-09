

-- 第23周的第一天

SELECT concat(Date_add(Date_add('2016-01-01', INTERVAL 23 week),
              INTERVAL 0 - Weekday(Date_add('2016-01-01', INTERVAL 23 week) )day
       ), ' 00:00:00') 
       
       
-- 第23周的最后一天

SELECT concat(Date_add(Date_add('2016-01-01', INTERVAL 23 week),
              INTERVAL 6 - Weekday(Date_add('2016-01-01', INTERVAL 23 week) )day
       ),' 23:59:59')
       
-- 第2月的第一天     
SELECT concat(Date_add('2016-01-01', INTERVAL 1 month), ' 00:00:00')


-- 第2月的最后一天     
SELECT concat(Date_add(Date_add('2016-01-01', INTERVAL 02 month),
     INTERVAL 0 - dayofmonth('2016-01-01' )day
) ,' 23:59:59')







