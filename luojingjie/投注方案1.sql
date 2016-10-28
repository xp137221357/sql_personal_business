SELECT 
       Date_format(w.PAY_TIME, '%Y-%m-%d')
       PAY_TIMES,
       Round(Sum(w.item_money))
       item_money,
       Round(Sum(w.prize_money))
       prize_money,
       Concat(Round(Sum(w.prize_money) / Sum(w.item_money) * 100, 2), '%')
       prize_count,
       Count(DISTINCT w.user_id)
       item_people,
       Count(1)
       item_count,
       Round(Count(1) / Count(DISTINCT w.user_id), 2)
       avg_item,
       Round(Sum(w.item_money) / Count(1))
       avg_item_money,
       Round(Sum(w.item_money) - Sum(w.prize_money))
       profit_count,
       Round(( Sum(w.item_money) - Sum(w.prize_money) ) / 100)
       profit_money
FROM       
       (select vo.user_id from v_user_old vo 
       LEFT JOIN (SELECT t.user_id
                  FROM   (SELECT user_id
                          FROM   (SELECT t.charge_user_id user_id,
                                         Sum(t.rmb_value) rmb_value
                                  FROM   (SELECT tc.charge_user_id,
                                                 tc.rmb_value
                                          FROM   t_trans_user_recharge_coin tc
                                          UNION ALL
                                          SELECT td.charge_user_id,
                                                 td.rmb_value
                                          FROM   t_trans_user_recharge_diamond
                                                 td) t
                                  GROUP  BY t.charge_user_id) tt
                          WHERE  tt.rmb_value >= 2000)t
                  UNION
                  (SELECT user_id
                   FROM   v_user_boss)) tt
              ON tt.user_id = vo.user_id
         WHERE  vo.crt_time <= '2016-10-12 10:00:00' and tt.user_id IS NULL) tt
         INNER JOIN t_trans_user_attr tu on tt.user_id = tu.user_id
         left join game.t_order_item w           
                  ON w.user_id = tu.user_code and  w.PAY_TIME >= '2016-10-10 10:00:00'
                  AND w.PAY_TIME < '2016-10-13 10:00:00'
                  AND w.item_status NOT IN( -5, -10, 210 )
                  AND w.channel_code = 'GAME' 
         left join game.t_order_item ww           
                  ON ww.user_id = tu.user_code and  ww.BALANCE_TIME >= '2016-10-10 10:00:00'
                  AND ww.BALANCE_TIME < '2016-10-13 10:00:00'
                  and date(ww.BALANCE_TIME)= date(w.PAY_TIME)
                  AND ww.item_status NOT IN( -5, -10, 210 )
                  AND ww.channel_code = 'GAME' 
         where w.user_id is not null or ww.USER_ID is not null
GROUP  BY PAY_TIMES
-- LIMIT  0, 10 