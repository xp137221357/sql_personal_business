-- 表五 竞猜，亚盘，平局
set @beginTime='2016-07-18';
set @endTime = '2016-07-24 23:59:59';

SELECT a.stat_time stat_time,
       b.payed_user_counts_t1 '购买总人数',
       a.payed_sum_t1 '购买总额',
       b.payed_user_counts_1 '竞猜购买总人数',
       a.payed_sum_1 '竞猜购买总额',
       b.payed_user_counts_2 '亚盘购买总人数' ,
       a.payed_sum_2 '亚盘购买总额',
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
        WHERE  Date_format(t.add_date, '%x-%v') >= date_format(@beginTime,'%x-%v')   
               AND Date_format(t.add_date, '%x-%v') <= date_format(@endTime,'%x-%v')   
        GROUP  BY stat_time) AS a
       LEFT JOIN (       SELECT t.add_date                    AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1,
                         Sum(t.new_jiepan_buy_user)    AS PAYED_USER_COUNTS_1,
                         Sum(t.new_yapan_buy_user)     AS PAYED_USER_COUNTS_2,
                         Sum(t.new_pinju_buy_user)     AS PAYED_USER_COUNTS_3
                  FROM   t_special_data_stat t
                  WHERE  t.date_type = 1
                         and t.add_date >= date_format(@beginTime,'%x-%v')   
                         and t.add_date <= date_format(@endTime,'%x-%v')   
                  GROUP  BY stat_time) AS b
              ON a.stat_time = b.stat_time
ORDER  BY stat_time ASC 


