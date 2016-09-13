-- 新增购买
-- 充值钻石以及新增充值钻石
SELECT '充值钻石以及新增充值钻石',dw.period_name_d '日期',dw.buy_sv_user_cnt '购买服务人数',dw.buy_sv_sum '购买服务金额',
        df.new_buy_sv_cnt '新增购买服务人数',df.first_buy_sv_sum '新增购买服务金额'
FROM   (SELECT date_format(@beginTime,'%x%v')      period_name_d,
                         Count(DISTINCT ai.user_id)
                         buy_sv_user_cnt,
                         Round(Ifnull(Sum(ai.change_value), 0), 2)
                         buy_sv_sum
                  FROM   forum.t_acct_items ai
                         WHERE ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
                         AND ai.item_status = 10
                         and ai.add_time >= @beginTime    
                         and ai.add_time<= @endTime
                  GROUP  BY date_format(ai.add_time,'%x%v')) dw
       LEFT JOIN (SELECT date_format(ai.add_time,'%x%v')  stat_time_f,
						       Count(DISTINCT ai.user_id)
						               new_buy_sv_cnt,
                         Ifnull(Sum(ai.change_value), 0) first_buy_sv_sum
                  FROM   forum.t_acct_items ai
                  INNER JOIN test.t_stat_first_buy_srv ts
                        ON ai.user_id = ts.user_id
                           AND ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
                           and ts.crt_time >= @beginTime    
						         and ts.crt_time<= @endTime
						         and ai.add_time >= @beginTime    
						         and ai.add_time<= @endTime
                           and ai.item_status=10
                  GROUP  BY date_format(ai.add_time,'%x%v')) df
ON df.stat_time_f = dw.period_name_d;


-- select * from forum.t_acct_items ai where ai.COMMENTS like '%buy_coin%' limit 100
   
SELECT date(ai.add_time)  stat_time_f,
       Count(DISTINCT ai.user_id)
               new_buy_sv_cnt,
       Ifnull(Sum(ai.change_value), 0) first_buy_sv_sum
FROM   forum.t_acct_items ai
INNER JOIN test.t_stat_first_buy_srv ts
      ON ai.user_id = ts.user_id
         AND ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
         and ts.crt_time >= @beginTime    
         and ts.crt_time<= @endTime
         and ai.add_time >= @beginTime    
         and ai.add_time<= @endTime
         -- AND date(ai.add_time) = date(ts.crt_time)
         and ai.item_status=10
GROUP  BY date(ai.add_time) ;             