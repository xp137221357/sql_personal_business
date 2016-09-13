SELECT t1.add_date                                                           AS
       stat_time,
       t1.first_activation_counts,
       a.retentionnumd1,
       Concat(Round(retentionnumd1 / first_activation_counts * 100, 2), '%') AS
       RetentionD1,
       a.retentionnumd2,
       Concat(Round(retentionnumd2 / first_activation_counts * 100, 2), '%') AS
       RetentionD2,
       a.retentionnumd3,
       Concat(Round(retentionnumd3 / first_activation_counts * 100, 2), '%') AS
       RetentionD3,
       a.retentionnumd4,
       Concat(Round(retentionnumd4 / first_activation_counts * 100, 2), '%') AS
       RetentionD4,
       a.retentionnumd5,
       Concat(Round(retentionnumd5 / first_activation_counts * 100, 2), '%') AS
       RetentionD5,
       a.retentionnumd6,
       Concat(Round(retentionnumd6 / first_activation_counts * 100, 2), '%') AS
       RetentionD6,
       a.retentionnumd7,
       Concat(Round(retentionnumd7 / first_activation_counts * 100, 2), '%') AS
       RetentionD7,
       a.retentionnumw2,
       Concat(Round(retentionnumw2 / first_activation_counts * 100, 2), '%') AS
       RetentionW2,
       a.retentionnumm1,
       Concat(Round(retentionnumm1 / first_activation_counts * 100, 2), '%') AS
       RetentionM1,
       a.retentionnumm2,
       Concat(Round(retentionnumm2 / first_activation_counts * 100, 2), '%') AS
       RetentionM2
FROM   (SELECT Date_format(Date_add(t.add_date, INTERVAL 0 - t.interval_days day
                           ),
                      '%Y-%m-%d')
                        AS stat_time,
               Sum(CASE t.interval_days
                     WHEN 1 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD1,
               Sum(CASE t.interval_days
                     WHEN 2 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD2,
               Sum(CASE t.interval_days
                     WHEN 3 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD3,
               Sum(CASE t.interval_days
                     WHEN 4 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD4,
               Sum(CASE t.interval_days
                     WHEN 5 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD5,
               Sum(CASE t.interval_days
                     WHEN 6 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD6,
               Sum(CASE t.interval_days
                     WHEN 7 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumD7,
               Sum(CASE t.interval_days
                     WHEN 14 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumW2,
               Sum(CASE t.interval_days
                     WHEN 30 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumM1,
               Sum(CASE t.interval_days
                     WHEN 60 THEN t.retention_counts
                     ELSE 0
                   end) AS RetentionNumM2
        FROM   t_device_stat_retention t
        WHERE  Date_add(t.add_date, INTERVAL 0 - t.interval_days day) >=
               '2016-08-03'
               AND Date_add(t.add_date, INTERVAL 0 - t.interval_days day) <=
                   '2016-08-10'
        GROUP  BY stat_time
        ORDER  BY stat_time DESC) a
       RIGHT JOIN (SELECT Date_format(b.add_date, '%Y-%m-%d') AS add_date,
                          Sum(b.first_activation_counts)
                          FIRST_ACTIVATION_COUNTS
                   FROM   t_device_stat_basic b
                   WHERE  Date(b.add_date) >= '2016-08-03'
                          AND Date(b.add_date) <= '2016-08-10'
                          AND first_activation_counts IS NOT NULL
                   GROUP  BY Date_format(b.add_date, '%Y-%m-%d')) t1
               ON a.stat_time = t1.add_date
ORDER  BY t1.add_date 
