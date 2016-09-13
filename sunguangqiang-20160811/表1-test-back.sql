-- 表一
-- 新增充值
set @beginTime='2016-08-29';
set @endTime = '2016-09-04 23:59:59';


-- 余额
-- 暂时无


-- select date_format(@beginTime,'%x%v')
-- 充值钻石以及新增充值钻石
SELECT '充值钻石以及新增充值钻石',dw.period_name_d '日期',dw.diamond_user_cnt '充值钻石人数',dw.diamond_recharge_sum '充值钻石金额',
        df.new_recharge_person '新增充值钻石人数',df.first_buy_diamond_sum '新增充值钻石金额'
FROM   (SELECT date(@beginTime)      period_name_d,
                         Count(DISTINCT ai.user_id)
                         diamond_user_cnt,
                         Round(Ifnull(Sum(ai.change_value), 0), 2)
                         diamond_recharge_sum
                  FROM   forum.t_acct_items ai
                  where ai.item_event = 'BUY_DIAMEND'
		                  AND ai.item_status = 10
		                  AND ( ai.comments NOT LIKE '%buy_coin%'
		                        AND ai.comments NOT LIKE '%underline%'
		                      )
                        and  ai.add_time >= @beginTime    
                        and ai.add_time<= @endTime
                  ) dw
       LEFT JOIN (SELECT date(ai.add_time)             stat_time_f,
						       Count(DISTINCT ai.user_id)
						                         new_recharge_person,
                         Ifnull(Sum(ai.change_value), 0) first_buy_diamond_sum
                  FROM   forum.t_acct_items ai
                         INNER JOIN test.t_stat_first_recharge_dmd ts
                                 ON ai.user_id = ts.user_id
                                    AND ai.item_event = 'BUY_DIAMEND'
                                    AND ai.comments NOT LIKE '%buy_coin%'
                                    AND ai.comments NOT LIKE '%underline%'
                                    and ts.crt_time >= @beginTime    
									         and ts.crt_time<= @endTime
									         and ai.add_time >= @beginTime    
									         and ai.add_time<= @endTime
                                    and ai.item_status=10
                  ) df
ON df.stat_time_f = dw.period_name_d;
              
              
-- 新增购买
-- 充值钻石以及新增充值钻石
SELECT '充值钻石以及新增充值钻石',dw.period_name_d '日期',dw.buy_sv_user_cnt '购买服务人数',dw.buy_sv_sum '购买服务金额',
        df.new_buy_sv_cnt '新增购买服务人数',df.first_buy_sv_sum '新增购买服务金额'
FROM   (SELECT date(@beginTime)      period_name_d,
                         Count(DISTINCT ai.user_id)
                         buy_sv_user_cnt,
                         Round(Ifnull(Sum(ai.change_value), 0), 2)
                         buy_sv_sum
                  FROM   forum.t_acct_items ai
                         WHERE ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
                         AND ai.item_status = 10
                         and ai.add_time >= @beginTime    
                         and ai.add_time<= @endTime
                  ) dw
       LEFT JOIN (SELECT date(ai.add_time)  stat_time_f,
						       Count(DISTINCT ai.user_id)
						               new_buy_sv_cnt,
                         Ifnull(Sum(ai.change_value), 0) first_buy_sv_sum
                  FROM   forum.t_acct_items ai
                  INNER JOIN t_stat_first_buy_srv ts
                        ON ai.user_id = ts.user_id
                           AND ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
                           and ts.crt_time >= @beginTime    
						         and ts.crt_time<= @endTime
						         and ai.add_time >= @beginTime    
						         and ai.add_time<= @endTime
                           and ai.item_status=10
                  ) df
ON df.stat_time_f = dw.period_name_d;
              
-- 数据分析购买服务
   

SELECT '竞猜-平局-亚盘',
       a.stat_time,
       b.payed_user_counts_t1 '数据分析购买人数',
       a.payed_sum_t1 '数据分析购买金额'
FROM   (SELECT Date_format(t.add_date, '%x-%v') AS STAT_TIME,
               Sum(CASE t.service_cd
                     WHEN -1 THEN t.payed_sum
                     ELSE 0
                   end)                            AS PAYED_SUM_T1
        FROM   FORUM.t_user_service_stat t
        WHERE  date_format(t.add_date,'%x%v')  >= date_format(@beginTime,'%x%v') 
               AND date_format(t.add_date,'%x%v')  <= date_format(@endTime,'%x%v') 
        GROUP  BY stat_time) AS a
       LEFT JOIN (SELECT t.add_date                   AS STAT_TIME,
                         Sum(t.new_buy_service_user)   AS PAYED_USER_COUNTS_T1
                  FROM   FORUM.t_special_data_stat t
                  WHERE  t.date_type = 1
                         AND t.add_date >= date_format(@beginTime,'%x-%v')   
                         AND t.add_date <= date_format(@endTime,'%x-%v') 
                  GROUP  BY stat_time) AS b
   ON a.stat_time = b.stat_time;

-- 专家推荐数据

SELECT '专家推荐数据',
Count(DISTINCT t.user_id) AS '购买人数',
sum(ifnull(t.MONEY,0)) AS '购买金额'
        FROM   t_user_match_recom t
               INNER JOIN t_user o
                       ON t.user_id = o.user_id
                          AND o.group_type IN( 0, 2 )
                          AND o.client_id = 'BYAPP'
WHERE  
      t.pay_status = 10
               AND t.money > 0
and t.crt_time >= @beginTime
AND t.crt_time<= @endTime


