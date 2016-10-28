SELECT 
       w.stat_time,
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
FROM   (
			 SELECT date(w.PAY_TIME) stat_time,w.* from game.t_order_item w        
	       INNER JOIN t_trans_user_attr tu
	               ON w.user_id = tu.user_code and  w.PAY_TIME >= '2016-10-10 10:00:00'
	                  AND w.PAY_TIME < '2016-10-13 10:00:00'
	                  AND w.item_status NOT IN( -5, -10, 210 )
	                  AND w.channel_code = 'GAME' 
	       INNER JOIN v_user_old vo
	               ON vo.user_id = tu.user_id
	                  AND vo.crt_time <= '2016-10-13 10:00:00'
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
	              ON tt.user_id = tu.user_id
	        WHERE  tt.user_id IS NULL
	        group by stat_time
   ) w
   left join (
			 SELECT date(w.BALANCE_TIME) stat_time,w.* from game.t_order_item w           
	       INNER JOIN t_trans_user_attr tu
	               ON w.user_id = tu.user_code and  w.BALANCE_TIME >= '2016-10-10 10:00:00'
	                  AND w.BALANCE_TIME < '2016-10-13 10:00:00'
	                  AND w.item_status NOT IN( -5, -10, 210 )
	                  AND w.channel_code = 'GAME' 
	       INNER JOIN v_user_old vo
	               ON vo.user_id = tu.user_id
	                  AND vo.crt_time <= '2016-10-13 10:00:00'
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
	              ON tt.user_id = tu.user_id
	        WHERE  tt.user_id IS NULL
	        group by stat_time
   ) ww on w.stat_time=ww.stat_time
	GROUP  BY stat_time
-- LIMIT  0, 100 
