set @begin_time='2017-02-01';
set @end_time='2017-02-10';
set @channel_no='360';

SELECT *
FROM   (SELECT c.*,
               Ifnull(v.device_pv, 0) + Ifnull(vh5.device_pv, 0) device_pv,
               Ifnull(v.device_uv, 0) + Ifnull(vh5.device_uv, 0) device_uv,
               t1.device_num,
               t2.active_dnum,
               t3.srv_unum,
               t4.buy_unum,
               t5.diamond_user_cnt,
               t5.diamond_recharge_sum,
               t6.buycoin_unum
        FROM   (SELECT  '合计'             AS stat_time,
                       Sum(first_dnum)         AS first_dnum,
                       Sum(second_dnum)        AS second_dnum,
                       Sum(reg_unum)           AS reg_unum,
                       Sum(first_buy_unum)     AS first_buy_unum,
                       Sum(first_buy_amount)   AS first_buy_amount,
                       Sum(buy_amount)         AS buy_amount,
                       Sum(first_srv_unum)     AS first_srv_unum,
                       Sum(first_srv_amount)   AS first_srv_amount,
                       Sum(srv_amount)         AS srv_amount,
                       Sum(first_bcoin_unum)   AS first_bcoin_unum,
                       Sum(first_bcoin_amount) AS first_bcoin_amount,
                       Sum(buycoin_amount)     AS buycoin_amount
                FROM   t_rpt_overview
                WHERE  period_type = '1'
                       AND period_name >= @begin_time
                       AND period_name < @end_time
                       AND channel_no IN( @channel_no )
               ) c
               LEFT JOIN (SELECT  '合计'        AS stat_time,
                                 Ifnull(Sum(pv), 0) AS device_pv,
                                 Ifnull(Sum(uv), 0) AS device_uv
                          FROM   t_rpt_channel_pv_uv
                          WHERE  period_type = '1'
                                 AND period_name >= @begin_time
                                 AND period_name < @end_time
                                 AND channel_no IN( @channel_no)
               ) v ON v.stat_time = c.stat_time
               LEFT JOIN (SELECT '合计'        AS stat_time,
                                 Ifnull(Sum(pv), 0) AS device_pv,
                                 Ifnull(Sum(uv), 0) AS device_uv
                          FROM   t_rpt_h5_url_pv_uv
                          WHERE  period_type = '1'
                                 AND period_name >= @begin_time
                                 AND period_name < @end_time
                                 AND channel_no LIKE 'mbyzq%'
                                 AND channel_no IN( @channel_no )
               ) vh5 ON vh5.stat_time = c.stat_time
               LEFT JOIN
					(
					       SELECT '合计'                    AS stat_time,
					              count(DISTINCT device_code)    device_num
					       FROM   t_device_statistic
					       WHERE  device_status != -10
					       AND    reg_channel IN (@channel_no)
					       AND    act_date >= @begin_time
					       AND    act_date <= @end_time
					       AND    stat_type=1
					) t1 ON t1.stat_time = c.stat_time
					LEFT JOIN
					(
					       SELECT '合计'                    AS stat_time,
					              count(DISTINCT device_code)    active_dnum
					       FROM   t_device_statistic
					       WHERE  device_status != -10
					       AND    reg_channel IN (@channel_no)
					       AND    act_date >= @begin_time
					       AND    act_date <= @end_time
					       AND    stat_type=4 
					) t2 ON t2.stat_time = c.stat_time
					LEFT JOIN
					(
					           SELECT     '合计'                   AS stat_time,
					                      count(DISTINCT ai.user_id)    srv_unum
					           FROM       forum.t_acct_items ai
					           INNER JOIN t_trans_user_attr ua
					           ON         ua.user_id = ai.user_id
					           WHERE      ai.item_status = 10
					           AND        ai.item_event IN ('BUY_SERVICE',
					                                        'BUY_RECOM')
					           AND        ua.channel_no IN (@channel_no)
					           AND        ai.add_time >= @begin_time
					           AND        ai.add_time <= @end_time
					) t3 ON t3.stat_time = c.stat_time
					LEFT JOIN
					(
					           SELECT     '合计'                   AS stat_time,
					                      count(DISTINCT ai.user_id)    buy_unum
					           FROM       forum.t_acct_items ai
					           INNER JOIN t_trans_user_attr ua
					           ON         ua.user_id = ai.user_id
					           WHERE      ai.item_status = 10
					           AND        ai.item_event IN ('buy_diamend')
					           AND        ua.channel_no IN (@channel_no)
					           AND        ai.add_time >= @begin_time
					           AND        ai.add_time <= @end_time
					) t4 ON t4.stat_time = c.stat_time
					LEFT JOIN
					(
					           SELECT     '合计'                  AS stat_time,
					                      count(sfrd.charge_user_id)          diamond_user_cnt,
					                      round(sum(sfrd.rmb_value))    diamond_recharge_sum
					           FROM       report.t_trans_user_recharge_diamond sfrd
					           INNER JOIN t_trans_user_attr ua
					           ON         ua.user_id = sfrd.charge_user_id
					           WHERE      1 = 1
					           AND        ua.channel_no IN (@channel_no)
					           AND        sfrd.crt_time >= @begin_time
					           AND        sfrd.crt_time <= @end_time
					) t5 ON t5.stat_time = c.stat_time
					LEFT JOIN
					(
					           SELECT     '合计'                          AS stat_time,
					                      count(DISTINCT ur.charge_user_id)    buycoin_unum
					           FROM       t_trans_user_recharge_coin ur
					           INNER JOIN t_trans_user_attr ua
					           ON         ua.user_id = ur.charge_user_id
					           WHERE      ur.charge_method = 'APP'
					           AND        ua.channel_no IN (@channel_no)
					           AND        ur.crt_time >= @begin_time
					           AND        ur.crt_time <= @end_time
					) t6 ON t6.stat_time = c.stat_time 
			)g
	      LEFT JOIN (SELECT '合计' stat_time_type,
	                         w.item_people,
	                         w.item_count,
	                         w.match_count,
	                         w.bet_coins item_money,
	                         ww.return_coins prize_money,
	                         Concat(Round(ww.return_coins * 100 / w.bet_coins, 2), '%') return_rate,
	                         Round(w.item_count / w.item_people, 2) avg_item,
	                         Round(w.bet_coins / w.item_count, 2) avg_item_money,
	                         Round(ww.return_coins - w.bet_coins) profit_count
	                  FROM   (SELECT  '合计'
	                                 stat_time_type,
	                                 Count(DISTINCT w.user_id)
	                                 item_people,
	                                 Count(1)
	                                 item_count,
	                                 Count(DISTINCT w.balance_match_id)
	                                 match_count,
	                                 Round(Ifnull(Sum(IF(w.channel_code='GAME', w.coin_buy_money, 0)), 0)+ Ifnull(Sum(IF(w.channel_code='YH', w.item_money, 0))*0.004, 0)+ Ifnull(Sum(IF(w.channel_code='KD', w.item_money, 0))*0.006, 0))bet_coins,
	                                 Ifnull(Round(Sum(w.p_coin_buy_money)), 0) bet_free_currency
				                 FROM   game.t_order_item w
				                        INNER JOIN t_trans_user_attr tu
				                              ON w.user_id = tu.user_code
				                                 AND w.pay_time >= @begin_time
				                                 AND w.pay_time < @end_time
				                                 AND channel_no IN( @channel_no )
				                                 AND item_status NOT IN( -5, -10, 210 )
				                                 AND ( w.coin_buy_money > 0 OR w.item_money > Ifnull(w.coin_buy_money, 0) + Ifnull(w.p_coin_buy_money, 0) )
				                 ) w
				                 LEFT JOIN (SELECT '合计' stat_time_type,
													      Round( Ifnull(Sum(IF(w.channel_code ='GAME', w.coin_prize_money, 0)), 0) + Ifnull(Sum(IF(w.channel_code ='YH', w.prize_money, 0))*0.004, 0) + Ifnull(Sum(IF(w.channel_code='KD', w.prize_money, 0))*0.006, 0)) return_coins,
														   Ifnull(Round(Sum(w.p_coin_prize_money)), 0) return_free_currency
													 FROM   game.t_order_item w
													 INNER JOIN t_trans_user_attr tu
														   ON w.user_id = tu.user_code
														   AND w.balance_time >= @begin_time
														   AND w.balance_time < @end_time
														   AND channel_no IN( @channel_no )
														   AND item_status NOT IN( -5, -10, 210 )
									  ) ww ON w.stat_time_type = ww.stat_time_type
			) ty ON ty.stat_time_type = g.stat_time 
