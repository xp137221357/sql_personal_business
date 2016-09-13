SELECT t4.*,
       t4.device_type terminal_type,
       Ifnull(first_dnum, 0) active_counts,
       Ifnull(reg_unum, 0)   register_counts,
       Ifnull(buy_unum, 0)   recharge_counts,
       Ifnull(buy_amount, 0) recharge_money
FROM   (SELECT t1.period_name,
               t1.channel_company,
               t1.promote_position,
               t1.channel_name,
               t1.channel_no_name,
               t1.channel_no,
               t1.device_type,
               t1.link,
               t1.access_counts,
               t1.access_person,
               t1.download_counts,
               t1.download_person,
               Ifnull(t3.bets_order, 0)      bets_order,
               Ifnull(t3.bets_person, 0)     bets_person
        FROM   (SELECT 
tt.period_name,
     tt.channel_company,
     tt.promote_position,
     tt.channel_name,
     tt.channel_no_name,
     tt.channel_no,
     tt.device_type,
     tt.operate_type,
     tt.link,
sum(if(tt.operate_type='ACCESS',Ifnull(tt.access_counts, 0),0))  access_counts,
sum(if(tt.operate_type='ACCESS',Ifnull(tt.access_person, 0),0))  access_person,
sum(if(tt.operate_type='DOWNLOAD',Ifnull(tt.download_counts, 0),0))  download_counts,
sum(if(tt.operate_type='DOWNLOAD',Ifnull(tt.download_person, 0),0))  download_person
 FROM (
SELECT t.period_name,
     tp.channel_company,
     t.promote_position,
     t.channel_name,
     tp.channel_no_name,
     tp.channel_no,
     t.device_type,
     if(t.operate_type='ACCESS',Ifnull(t.pv, 0),0) access_counts,
     if(t.operate_type='ACCESS',Ifnull(t.uv, 0),0) access_person,
     if(t.operate_type='DOWNLOAD',Ifnull(t.pv, 0),0) download_counts,
     if(t.operate_type='DOWNLOAD',Ifnull(t.uv, 0),0) download_person,
     tp.operate_type,
     tp.link
FROM   forum.t_rpt_h5_url_pv_uv t
     INNER JOIN t_channel_promote tp
             ON t.channel_name = tp.channel_name
                AND t.promote_position = tp.promote_position
                AND t.operate_type = tp.operate_type
WHERE  t.period_type = 1
     AND t.period_name >= '2016-07-10'
     AND t.period_name <= '2016-07-10'
GROUP  BY t.period_name,
        t.channel_name,
        tp.channel_no,
        t.promote_position,
        t.device_type,
		  t.OPERATE_TYPE) tt 
		  GROUP  BY tt.period_name,
        tt.channel_name,
        tt.channel_no,
        tt.promote_position,
        tt.device_type) t1
               LEFT JOIN (SELECT Date(oi.crt_time)
                                 period_name,
                                 cp.channel_name
                                 channel_name,
                                 cp.channel_no,
                                 cp.promote_position,
                                 Ifnull(Count(1), 0)
                                 bets_order,
                                 Ifnull(Count(DISTINCT oi.user_id), 0)
                                 bets_person
                          FROM   game.t_order_item oi
                                 INNER JOIN t_channel_promote cp
                                         ON ( CASE oi.channel_code
                                                WHEN 'TD' THEN 'jrtt1'
                                                ELSE oi.channel_code
                                              end ) = cp.channel_no
                          WHERE  oi.crt_time >= '2016-07-10'
                                 AND oi.crt_time < '2016-07-10'
                                 AND oi.channel_code IN( 'TD', 'baidu' )
                          GROUP  BY oi.channel_code,
                                    Date(oi.crt_time)) t3
                      ON t1.period_name = t3.period_name
                         AND t3.channel_name = t1.channel_name) t4
       LEFT JOIN (SELECT ro.period_name,
                         ro.channel_no,
                         ro.device_type,
                         Ifnull(Sum(ro.first_dnum), 0) FIRST_DNUM,
                         Ifnull(Sum(ro.reg_unum), 0)   REG_UNUM,
                         Ifnull(Sum(ro.buy_unum), 0)   BUY_UNUM,
                         Ifnull(Sum(ro.buy_amount), 0) BUY_AMOUNT
                  FROM   forum.t_rpt_overview ro
                  WHERE  ro.period_type = 1
                         AND ro.period_name >= '2016-07-10'
                         AND ro.period_name < '2016-07-10'
                  GROUP  BY ro.period_name,
                            ro.channel_no,
                            ro.device_type)t5
              ON t4.period_name = t5.period_name
                 AND t4.channel_no = t5.channel_no
                 AND t4.device_type = t5.device_type
ORDER  BY t4.period_name,
          t4.channel_company,
          t4.channel_no; 
