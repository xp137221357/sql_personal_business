SELECT w.stat_time,round(ww.return_money),round(w.item_money),round(ww.return_money)-round(w.item_money)
       
FROM   (SELECT Date_format(w.pay_time, '%Y-%m-%d')       stat_time,
       sum(w.item_money) item_money
FROM   game.t_order_item w
INNER JOIN forum.t_user tu
  ON w.user_id = tu.user_code
     AND w.pay_time >= '2016-07-01'
     AND w.pay_time < '2016-08-01'
--     AND item_status NOT IN( -5, -10, 210 )
     AND w.channel_code = 'KD'
GROUP  BY stat_time) w
LEFT JOIN (SELECT Date_format(w.balance_time, '%Y-%m-%d')     stat_time,
    Sum(w.prize_money) return_money
FROM   game.t_order_item w
INNER JOIN forum.t_user tu
ON w.user_id = tu.user_code
AND w.balance_time >= '2016-07-01'
AND w.balance_time < '2016-08-01'
-- AND item_status NOT IN( -5, -10, 210 )
AND w.channel_code = 'KD'
GROUP  BY stat_time) ww
ON w.stat_time = ww.stat_time
GROUP  BY stat_time 
