
-- 分币种，
-- 投注方式
-- 结算方式 
-- 自然时间 
-- 按比赛的时间，结算推迟两小时

SELECT Date_format(t1.stat_time, '%Y-%m-%d') stat_time,
       Ifnull(t1.recharge_counts, 0)    recharge_counts,
       Ifnull(t1.recharge_coins, 0)     recharge_coins,
       Ifnull(t4.bet_counts, 0)         bet_counts,
       Ifnull(t4.bet_oders, 0)          bet_oders,
       Ifnull(t4.bet_coins, 0)          bet_coins,
       Ifnull(t4.prize_counts, 0)       prize_counts,
       Ifnull(t4.prize_oders, 0)        prize_oders,
       Ifnull(t4.prize_coins, 0)        prize_coins,
       Ifnull(t2.reg_counts, 0)              reg_counts,
       Ifnull(t3.all_recharge_counts, 0)         all_recharge_counts,
       Ifnull(t5.all_bet_counts, 0)         all_bet_counts,
       Ifnull(t5.all_prize_counts, 0)         all_prize_counts
FROM   (SELECT Date(s.add_time)
                      stat_time,
               Count(DISTINCT tu.user_id)
                      recharge_counts,
               Round(Sum(s.change_value))
                      recharge_coins
        FROM   t_user_shangdong ts
               INNER JOIN t_trans_user_attr tu
                       ON ts.user_id = tu.user_id
                          AND tu.channel_no NOT IN ( 'BY', 'TD', 'baidu', 'qq',
                                                     'jrtt', 'jrtt1', 'jrtt2',
                                                     'jrtt3',
                                                     'jrtt4', 'jrtt5', 'jrtt6',
                                                     'jrtt7',
                                                     'jrtt8', 'jrtt9', 'jrtt10',
                                                     'jrtt11' )
               INNER JOIN forum.t_acct_items s
                       ON tu.user_id = s.user_id
                          AND s.item_status = 10
                          AND s.item_event = 'BUY_DIAMEND' 
        WHERE  s.add_time >= '2016-08-27 10:00:00'
               AND s.add_time <= '2016-09-03 10:00:00'
        GROUP  BY Date(s.add_time),
                  s.item_event) t1
       LEFT JOIN (SELECT Date(u.crt_time)             stat_time,
                         Count(DISTINCT( u.user_id )) reg_counts
                  FROM   t_user_shangdong ts
                         INNER JOIN forum.t_user u
                                 ON ts.user_id = u.user_id
                                    AND u.crt_time >= '2016-08-27 10:00:00'
                                    AND u.crt_time <= '2016-09-03 10:00:00'
                         INNER JOIN t_trans_user_attr tu
                                 ON u.user_id = tu.user_id
                                    AND tu.channel_no NOT IN (
                                        'BY', 'TD', 'baidu', 'qq',
                                        'jrtt', 'jrtt1', 'jrtt2', 'jrtt3',
                                        'jrtt4', 'jrtt5', 'jrtt6', 'jrtt7',
                                        'jrtt8', 'jrtt9', 'jrtt10',
                                        'jrtt11' )
                  GROUP  BY Date(u.crt_time)) t2
              ON t1.stat_time = t2.stat_time
left join (SELECT Date('2016-08-27 10:00:00')
                      stat_time,
               Count(DISTINCT tu.user_id)
                      all_recharge_counts
        FROM   t_user_shangdong ts
               INNER JOIN t_trans_user_attr tu
                       ON ts.user_id = tu.user_id
                          AND tu.channel_no NOT IN ( 'BY', 'TD', 'baidu', 'qq',
                                                     'jrtt', 'jrtt1', 'jrtt2',
                                                     'jrtt3',
                                                     'jrtt4', 'jrtt5', 'jrtt6',
                                                     'jrtt7',
                                                     'jrtt8', 'jrtt9', 'jrtt10',
                                                     'jrtt11' )
               INNER JOIN forum.t_acct_items s
                       ON tu.user_id = s.user_id
                          AND s.item_status = 10
                          AND s.item_event = 'BUY_DIAMEND' 
        WHERE  s.add_time >= '2016-08-27 10:00:00'
               AND s.add_time <= '2016-09-03 10:00:00'
       ) t3 on t1.stat_time=t3.stat_time
      left join (select 
			date(m.MATCH_TIME) stat_time,
			-- round(sum(oi.COIN_BUY_MONEY)) bet_coins,
			-- round(sum(oi.P_COIN_BUY_MONEY)) bet_coins,
			-- round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
			-- round(sum(oi.P_COIN_PRIZE_MONEY)) return_coins,
			count(distinct oi.user_id) bet_counts,
			count(oi.user_id) bet_oders,
			count(distinct if(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_PRIZE_MONEY,0)>0,oi.user_id,null)) prize_counts,
			count(if(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_PRIZE_MONEY,0)>0,oi.user_id,null)) prize_oders,
			round(sum(oi.COIN_BUY_MONEY)+sum(oi.P_COIN_BUY_MONEY)) bet_coins,
			round(sum(oi.COIN_PRIZE_MONEY)+sum(oi.P_COIN_PRIZE_MONEY)) prize_coins
			from game.t_order_item oi
			 inner join t_trans_user_attr tu on tu.USER_CODE=oi.user_id AND tu.channel_no NOT IN (
                                        'BY', 'TD', 'baidu', 'qq',
                                        'jrtt', 'jrtt1', 'jrtt2', 'jrtt3',
                                        'jrtt4', 'jrtt5', 'jrtt6', 'jrtt7',
                                        'jrtt8', 'jrtt9', 'jrtt10',
                                        'jrtt11' )
			 inner join t_user_shangdong ts on tu.user_id = ts.user_id
			 inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
			where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PASS_TYPE=1001 -- 单关
			and m.MATCH_TIME >= date_add('2016-08-27 10:00:00', interval -2 hour)
			and m.MATCH_TIME <= date_add('2016-09-03 10:00:00', interval -2 hour)
			group by stat_time
)t4 on t1.stat_time=t4.stat_time
left join (select 
			date('2016-08-27 10:00:00') stat_time,
			-- round(sum(oi.COIN_BUY_MONEY)) bet_coins,
			-- round(sum(oi.P_COIN_BUY_MONEY)) bet_coins,
			-- round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
			-- round(sum(oi.P_COIN_PRIZE_MONEY)) return_coins,
			count(distinct oi.user_id) all_bet_counts,
			count(distinct if(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_PRIZE_MONEY,0)>0,oi.user_id,null)) all_prize_counts
			from game.t_order_item oi
			inner join t_trans_user_attr tu on tu.USER_CODE=oi.user_id AND tu.channel_no NOT IN (
                                        'BY', 'TD', 'baidu', 'qq',
                                        'jrtt', 'jrtt1', 'jrtt2', 'jrtt3',
                                        'jrtt4', 'jrtt5', 'jrtt6', 'jrtt7',
                                        'jrtt8', 'jrtt9', 'jrtt10',
                                        'jrtt11' )
			 inner join t_user_shangdong ts on tu.user_id = ts.user_id
			 inner join fb_main.t_match m on oi.balance_match_id=m.MATCH_ID
			where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PASS_TYPE=1001 -- 单关
			and m.MATCH_TIME >= date_add('2016-08-27 10:00:00', interval -2 hour)
			and m.MATCH_TIME <= date_add('2016-09-03 10:00:00', interval -2 hour)
)t5 on t1.stat_time=t5.stat_time
GROUP  BY t1.stat_time; 
