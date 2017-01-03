-- 新增
-- SERVICE_id 2-竞猜，5-平局，8-亚盘

set @param0='2016-12-19';
set @param1 = '2016-12-25 23:59:59';

select 
	'总新增购买服务人数-金额',
	null value1,
	count(distinct tu.USER_ID) value2,
	sum(tu.MONEY) value3 
from forum.t_user_service tu
inner join forum.t_service ts on ts.SERVICE_id=tu.SERVICE_id and ts.SERVICE_id in (2,5,8)
inner join t_stat_first_buy_srv tf on tf.USER_ID = tu.user_id
and tf.CRT_TIME>=@param0
and tf.CRT_TIME<=@param1
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<=@param1

union all

select '新增购买服务人数-金额',
case tu.SERVICE_id
    when 2 then '竞猜'
    when 5 then '平局'
    when 8 then '亚盘'
end as '类别',
count(distinct tu.USER_ID) '新增购买服务人数',sum(tu.MONEY) '新增购买服务金额' 
from forum.t_user_service tu
inner join forum.t_service ts on ts.SERVICE_id=tu.SERVICE_id and ts.SERVICE_id in (2,5,8)
inner join t_stat_first_buy_srv tf on tf.USER_ID = tu.user_id
and tf.CRT_TIME>=@param0
and tf.CRT_TIME<=@param1
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<=@param1
group by tu.SERVICE_id

union all 

SELECT '购买总人数-金额',
		 null,
       b.payed_user_counts_t1 '购买总人数',
       a.payed_sum_t1 '购买总额'
FROM   (SELECT Date_format(t.add_date, '%x-%v') AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_T1,
               Sum(CASE t.service_cd
                     WHEN 1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_1,
               Sum(CASE t.service_cd
                     WHEN 2 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_2,
               Sum(CASE t.service_cd
                     WHEN 3 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_3
        FROM   t_user_service_stat t
        WHERE  t.date_type = 0 
		  			and Date_format(t.add_date, '%x-%v') >= date_format(@param0,'%x-%v')   
               AND Date_format(t.add_date, '%x-%v') <= date_format(@param1,'%x-%v')   
        ) AS a
       LEFT JOIN (       SELECT t.add_date                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 1
                         and t.add_date >= date_format(@param0,'%x-%v')   
                         and t.add_date <= date_format(@param1,'%x-%v')   
         ) AS b on 1=1

union all 


SELECT '竞猜购买人数-金额',
		 null,
       b.payed_user_counts_1 '竞猜购买总人数',
       a.payed_sum_1 '竞猜购买总额'
FROM   (SELECT Date_format(t.add_date, '%x-%v') AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_T1,
               Sum(CASE t.service_cd
                     WHEN 1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_1,
               Sum(CASE t.service_cd
                     WHEN 2 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_2,
               Sum(CASE t.service_cd
                     WHEN 3 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_3
        FROM   t_user_service_stat t
        WHERE  t.date_type = 0 
		  			and Date_format(t.add_date, '%x-%v') >= date_format(@param0,'%x-%v')   
               AND Date_format(t.add_date, '%x-%v') <= date_format(@param1,'%x-%v')   
        ) AS a
       LEFT JOIN (       SELECT t.add_date                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 1
                         and t.add_date >= date_format(@param0,'%x-%v')   
                         and t.add_date <= date_format(@param1,'%x-%v')   
      ) AS b on 1=1

union all 


SELECT '亚盘购买人数-金额',
		 null,
       b.payed_user_counts_2 '亚盘购买总人数' ,
       a.payed_sum_2 '亚盘购买总额'
FROM   (SELECT Date_format(t.add_date, '%x-%v') AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_T1,
               Sum(CASE t.service_cd
                     WHEN 1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_1,
               Sum(CASE t.service_cd
                     WHEN 2 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_2,
               Sum(CASE t.service_cd
                     WHEN 3 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_3
        FROM   t_user_service_stat t
        WHERE  t.date_type = 0 
		  			and Date_format(t.add_date, '%x-%v') >= date_format(@param0,'%x-%v')   
               AND Date_format(t.add_date, '%x-%v') <= date_format(@param1,'%x-%v')   
        ) AS a
       LEFT JOIN (       SELECT t.add_date                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 1
                         and t.add_date >= date_format(@param0,'%x-%v')   
                         and t.add_date <= date_format(@param1,'%x-%v')   
         ) AS b on 1=1

union all

SELECT '平局购买人数-金额',
		 null,
       b.payed_user_counts_3 '平局购买总人数',
       a.payed_sum_3 '平局购买总额'
FROM   (SELECT Date_format(t.add_date, '%x-%v') AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_T1,
               Sum(CASE t.service_cd
                     WHEN 1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_1,
               Sum(CASE t.service_cd
                     WHEN 2 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_2,
               Sum(CASE t.service_cd
                     WHEN 3 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_3
        FROM   t_user_service_stat t
        WHERE  t.date_type = 0 
		  			and Date_format(t.add_date, '%x-%v') >= date_format(@param0,'%x-%v')   
               AND Date_format(t.add_date, '%x-%v') <= date_format(@param1,'%x-%v')   
       ) AS a
       LEFT JOIN (       SELECT t.add_date                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 1
                         and t.add_date >= date_format(@param0,'%x-%v')   
                         and t.add_date <= date_format(@param1,'%x-%v')   
       ) AS b on 1=1



-- 合计按日合成周
SELECT a.stat_time stat_time,
       b.payed_user_counts_t1 '购买总人数',
       a.payed_sum_t1 '购买总额',
       b.payed_user_counts_1 '竞猜购买总人数',
       a.payed_sum_1 '竞猜购买总额',
       b.payed_user_counts_2 '亚盘购买总人数' ,
       a.payed_sum_2 '亚盘购买总额',
       b.payed_user_counts_3 '平局购买总人数',
       a.payed_sum_3 '平局购买总额'
FROM   (SELECT 1 AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_T1,
               Sum(CASE t.service_cd
                     WHEN 1 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_1,
               Sum(CASE t.service_cd
                     WHEN 2 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_2,
               Sum(CASE t.service_cd
                     WHEN 3 THEN t.payed_sum
                     ELSE 0
                   end)                         AS PAYED_SUM_3
        FROM   t_user_service_stat t
        WHERE  t.date_type = 0 
		         and t.add_date >= @param0 
               AND t.add_date <= @param1
        ) AS a
       LEFT JOIN (       SELECT 1                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 0
                         and t.add_date >= @param0  
                         and t.add_date <= @param1 
                  ) AS b
              ON a.stat_time = b.stat_time
ORDER  BY stat_time ASC 