set @param0='2016-09-14';
set @param1='2016-09-21';

-- set params=['2016-09-14','2016-09-21'];
-- device_type: 终端类型,device_pv：访问PV，device_uv：访问UV
-- device_num:访问设备数，online_unum，在线设备，first_dnum：首次激活，second_dnum：二次激活，active_dnum：设备激活数，reg_unum：新增注册
-- first_buy_unum：首次充值人数，first_buy_amount：首次充值金额，buy_unum：充值人数，buy_amount：充值金额
-- first_srv_unum：首次购买服务人数，first_srv_amount：首次购买服务金额，srv_unum：购买服务人数，srv_amount：购买服务金额
-- first_bcoin_unum：首次充值金币人数，first_bcoin_amount：首次充值金币金额，bcoin_unum：充值金币人数，bcoin_amount：充值金币金额
-- diamond_user_cnt：充值钻石人数，diamond_recharge_sum：充值钻石金额

select ifnull(tdc.channel_name,'other') channel_name,c.*,v.device_pv,v.device_uv,dw.diamond_user_cnt,dw.diamond_recharge_sum
FROM    (SELECT period_name,
                          channel_no,
                          device_type,
                          Sum(device_num)         AS device_num,
                          Sum(online_unum)        AS online_unum,
                          Sum(first_dnum)         AS first_dnum,
                          Sum(second_dnum)        AS second_dnum,
                          Sum(active_dnum)        AS active_dnum,
                          Sum(reg_unum)           AS reg_unum,
                          Sum(first_buy_unum)     AS first_buy_unum,
                          Sum(first_buy_amount)   AS first_buy_amount,
                          Sum(buy_unum)           AS buy_unum,
                          Sum(buy_amount)         AS buy_amount,
                          Sum(first_srv_unum)     AS first_srv_unum,
                          Sum(first_srv_amount)   AS first_srv_amount,
                          Sum(srv_unum)           AS srv_unum,
                          Sum(srv_amount)         AS srv_amount,
                          Sum(first_bcoin_unum)   AS first_bcoin_unum,
                          Sum(first_bcoin_amount) AS first_bcoin_amount,
                          Sum(buycoin_unum)       AS buycoin_unum,
                          Sum(buycoin_amount)     AS buycoin_amount
                   FROM   t_rpt_overview
                   WHERE  period_type = '1'
                          AND period_name >= @param0
                          AND period_name <= @param1
                   GROUP  BY period_name,channel_no,device_type) c
        LEFT JOIN  (SELECT period_name AS period_name_v,
		               channel_no,
		               device_type,
		               Sum(pv)     AS device_pv,
		               Sum(uv)     AS device_uv
		         FROM   t_rpt_channel_pv_uv
        WHERE  period_type = '1'
               AND period_name >= @param0
               AND period_name <= @param1
        GROUP  BY period_name,channel_no,device_type) v
               ON v.period_name_v = c.period_name and v.channel_no = c.channel_no and c.device_type = v.device_type
       LEFT JOIN (SELECT Date(ai.add_time)                       period_name_d,
                         ue.channel_no,
                         ue.SYSTEM_MODEL,
                         Count(DISTINCT ai.user_id)
                         diamond_user_cnt,
                         Round(Ifnull(Sum(ai.cost_value), 0), 2)
                         diamond_recharge_sum
                  FROM   forum.t_acct_items ai
                         INNER JOIN forum.t_user_event ue
                                 ON ai.user_id = ue.user_id
                                    AND ue.event_code = 'REG'
                                    AND ai.item_event = 'BUY_DIAMEND'
                                    AND ai.item_status = 10
                                    AND ( ai.comments NOT LIKE '%buy_coin":1%'
                                          AND ai.comments NOT LIKE '%underline%'
                                        )
                  WHERE  Date(ai.add_time) >= @param0
                         AND Date(ai.add_time) <= @param1
                  GROUP  BY Date(ai.add_time),ue.channel_no,ue.SYSTEM_MODEL) dw
              ON dw.period_name_d = c.period_name and dw.channel_no = c.channel_no and dw.SYSTEM_MODEL = c.device_type
      left join forum.t_device_channel tdc on tdc.CHANNEL_NO = c.channel_no 
