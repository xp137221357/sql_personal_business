-- 每天新增用户按分钟分布
SELECT t1.minute_time,
       Decode(t2.user_counts, NULL, 0,
                              t2.user_counts) user_counts
FROM   (SELECT To_char(To_date('2016-09-23', 'yyyy-mm-dd') + ROWNUM / 24 / 60,
                              'yyyy-mm-dd HH24:MI') minute_time
        FROM   dual
        CONNECT BY ROWNUM <= 24 * 60 - 1) t1
        LEFT JOIN (SELECT To_char(u.u_crttime, 'yyyy-mm-dd hh24:mi') minute_time,
                         Count(u.u_username)                        user_counts
                  FROM   v_user u
                  WHERE  u.u_crttime >= To_date('2016-09-23 00:00:00',
                                        'yyyy-mm-dd hh24:mi:ss')
                         AND u.u_crttime <= To_date('2016-09-23 23:59:59',
                                            'yyyy-mm-dd hh24:mi:ss')
                  GROUP  BY To_char(u.u_crttime, 'yyyy-mm-dd hh24:mi'))t2
              ON t1.minute_time = t2.minute_time
ORDER  BY t1.minute_time ASC 


                             
                             







