-- 每天成功票金额按时间段分布曲线

SELECT t1.minute_time,
       Decode(t2.success_ticket_money, NULL, 0,
                                       t2.success_ticket_money)
       success_ticket_money
FROM   (SELECT To_char(To_date('2016-09-23', 'yyyy-mm-dd') + ROWNUM / 24 / 60,
                              'yyyy-mm-dd HH24:MI') minute_time
        FROM   dual
        CONNECT BY ROWNUM <= 24 * 60 - 1) t1
       left join (SELECT To_char(t.pd_addtime, 'yyyy-mm-dd hh24:mi') minute_time
                         ,
                         SUM(t.pd_money)
                                                       success_ticket_money
                  FROM   v_ticket t
                  WHERE  t.pd_status = '200'
                         AND t.pd_addtime >= To_date('2016-09-23 00:00:00',
                                             'yyyy-mm-dd hh24:mi:ss')
                         AND t.pd_addtime <= To_date('2016-09-23 23:59:59',
                                             'yyyy-mm-dd hh24:mi:ss')
                  GROUP  BY To_char(t.pd_addtime, 'yyyy-mm-dd hh24:mi'))t2
              ON t1.minute_time = t2.minute_time
ORDER  BY t1.minute_time ASC 

