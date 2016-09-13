set @beginTime = '2016-09-01';
set @endTime = '2016-09-04 23:59:59';

SELECT ttt.value_type                                       stat_type,
       Count(DISTINCT ttt.charge_user_id)                   total_person,
       Count(DISTINCT IF (ttt.charge_method != 'APP', ttt.third_user_id, NULL))
       third_recharge_coin_person,
       Count(DISTINCT IF (ttt.charge_method = 'APP', ttt.third_user_id, NULL))
       app_recharge_coin_person,
       Count(DISTINCT IF (ttt.diamond_value > 0, ttt.charge_user_id, NULL))
       recharge_diamond_person,
       Ifnull(Sum(rmb_value), 0)                            recharge_total_money
       ,
       Ifnull(Sum(diamonds), 0)
       recharge_diamonds,
       Ifnull(Sum(diamond_value), 0)
       recharge_diamond_money,
       Ifnull(Sum(app_coin_rmb), 0)
       app_recharge_coin_money,
       Ifnull(Sum(app_coin), 0)                             app_recharge_coins,
       Ifnull(Sum(third_coin_rmb), 0)
       third_recharge_coin_money,
       Ifnull(Sum(third_coin), 0)                           third_recharge_coins
       ,
       ifnull(count(distinct user_id),0) bet_counts,
       Ifnull(Round(Sum(bet_coins)), 0)                     bet_coins,
       Ifnull(Round(Sum(return_coins)), 0)                  return_coins,
       Ifnull(Round(Sum(bet_coins) - Sum(return_coins)), 0) profit_coins,
       Ifnull(Concat(Round(Sum(return_coins) * 100 / Sum(bet_coins)), '%'), 0
       )
                                                            return_rate
FROM   (SELECT tt.value_type,
               tt.rmb_value,
               tt.diamond_value,
               tt.diamonds,
               tt.charge_user_id,
               tt1.app_coin_rmb,
               tt1.app_coin,
               tt1.third_coin_rmb,
               tt1.third_coin,
               tt1.charge_method,
               tt1.charge_user_id third_user_id,
               tt2.user_id,
               tt2.bet_coins,
               tt2.return_coins
        FROM ( select * from (
		         SELECT t.charge_user_id,
                       CASE
                         WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
                              AND Ifnull(Sum(t.rmb_value), 0) < 3000 THEN 1
                         WHEN Ifnull(Sum(t.rmb_value), 0) >= 3000
                              AND Ifnull(Sum(t.rmb_value), 0) < 4000 THEN 2
                         WHEN Ifnull(Sum(t.rmb_value), 0) >= 4000
                              AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 3
                         WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 THEN 4
                       end                             AS value_type,
                       Ifnull(Sum(t.rmb_value), 0)     rmb_value,
                       Ifnull(Sum(t.diamonds), 0)      diamonds,
                       Ifnull(Sum(t.diamond_value), 0) diamond_value
                FROM   (SELECT tc.charge_method,
                               tc.charge_user_id,
                               tc.rmb_value,
                               0 diamond_value,
                               0 diamonds
                        FROM   t_trans_user_recharge_coin tc                                           
                        UNION ALL
                        SELECT td.charge_method,
                               td.charge_user_id,
                               td.rmb_value,
                               td.rmb_value diamond_value,
                               diamonds
                        FROM   t_trans_user_recharge_diamond td
                                                  ) t
                GROUP  BY t.charge_user_id) tt WHERE tt.value_type is not null ) tt
               LEFT JOIN (SELECT t.charge_user_id,
                                 t.charge_method,
                                 Ifnull(Sum(app_coin_rmb), 0)   app_coin_rmb,
                                 Ifnull(Sum(app_coin), 0)       app_coin,
                                 Ifnull(Sum(third_coin_rmb), 0) third_coin_rmb,
                                 Ifnull(Sum(third_coin), 0)     third_coin
                          FROM   (SELECT tr.charge_user_id,
                                         tr.charge_method,
									       Sum(IF(tr.charge_method = 'APP', tr.rmb_value, 0))
									       app_coin_rmb
									       ,
									       Sum(IF(tr.charge_method = 'APP', tr.coins, 0))
									       app_coin,
									       Sum(IF(tr.charge_method != 'APP', tr.rmb_value, 0))
									       third_coin_rmb,
									       Sum(IF(tr.charge_method != 'APP', tr.coins, 0))
									       third_coin
									       FROM   t_trans_user_recharge_coin tr
									       WHERE  tr.crt_time >= '2016-08-30 10:00:00'
									       AND tr.crt_time <= '2016-09-06 10:00:00'                     
									       GROUP  BY tr.charge_user_id,
									          tr.charge_method) t
                         GROUP  BY t.charge_user_id) tt1 ON tt.charge_user_id = tt1.charge_user_id
					INNER JOIN report.t_trans_user_attr tu
						       	ON tu.user_id = tt.charge_user_id
					LEFT JOIN ( SELECT oi.user_id,
							      Ifnull(Sum(oi.item_money), 0)  bet_coins,
							      Ifnull(Sum(oi.prize_money), 0) return_coins
							      FROM   game.t_order_item oi
							      WHERE  oi.channel_code = 'game'
							      AND oi.item_status NOT IN ( -5, -10, 210 )
							      AND oi.crt_time >= '2016-08-30 10:00:00'
							      AND oi.crt_time <= '2016-09-06 10:00:00'
							      GROUP  BY oi.user_id) tt2
                           ON tt2.user_id = u.user_code
									
	    ) ttt
GROUP  BY ttt.value_type 
