select * from (
SELECT
Concat('2016-10-17', '~', '2016-10-24')
stat_time,
if(c.channel_company is null or c.channel_company='', 'other',c.channel_company)
channel_company,
if(c.device_type is null or c.device_type='', 'other',c.device_type)
device_type,
c.first_dnum,
c.reg_unum,
Concat(Round(IF(c.first_dnum > 0, c.reg_unum * 100 / c.first_dnum, 0), 2), '%')
       reg_active,
c.first_buy_unum,
Concat(Round(IF(c.reg_unum > 0, c.first_buy_unum * 100 / c.reg_unum, 0), 2), '%')     first_recharge_reg,
Concat(Round(IF(c.first_dnum > 0, c.first_buy_unum * 100 / c.first_dnum, 0), 2), '%') first_recharge_active,
c.first_buy_amount,
Round(IF(c.first_buy_unum > 0, c.first_buy_amount / c.first_buy_unum, 0), 2)
per_first_recharge_money,
cc.buy_unum,
c.buy_amount,
Round(IF(c.buy_unum > 0, c.buy_amount / c.buy_unum, 0), 2)
per_recharge_money
FROM   (SELECT Ifnull(tdc.company_name, 'other')
					channel_company,
               device_type,
               Sum(first_dnum)       AS first_dnum,
               Sum(second_dnum)      AS second_dnum,
               Sum(active_dnum)      AS active_dnum,
               Sum(reg_unum)         AS reg_unum,
               Sum(first_buy_unum)   AS first_buy_unum,
               Sum(first_buy_amount) AS first_buy_amount,
               Sum(buy_unum)         AS buy_unum,
               Sum(buy_amount)       AS buy_amount
        FROM   t_rpt_overview t
        LEFT JOIN report.t_device_channel tdc
              ON tdc.channel_no = t.channel_no
        where  period_type = '1'
               AND period_name >= '2016-10-17'
               AND period_name <= Concat('2016-10-24', ' 23:59:59')
        GROUP  BY channel_company,
                  device_type) c
       LEFT JOIN (SELECT Ifnull(tdc.company_name, 'other')
					channel_company,
					Count(DISTINCT tt.user_id) buy_unum,
                         tu.system_model
                  FROM   (SELECT charge_user_id user_id
                          FROM   (SELECT tc.charge_user_id
                                  FROM   t_trans_user_recharge_coin tc
                                  WHERE  tc.charge_method = 'APP'
                                         AND tc.crt_time >= '2016-10-17'
                                         AND tc.crt_time <= Concat('2016-10-24',
                                                            ' 23:59:59')
                                  UNION ALL
                                  SELECT tc.charge_user_id
                                  FROM   t_trans_user_recharge_diamond tc
                                  WHERE  tc.crt_time >= '2016-10-17'
                                         AND tc.crt_time <= Concat('2016-10-24',
                                                            ' 23:59:59')) tt
                          GROUP  BY tt.charge_user_id) tt
                          INNER JOIN t_trans_user_attr tu
                                 ON tu.user_id = tt.user_id
		                    LEFT JOIN report.t_device_channel tdc
		                    			ON tdc.channel_no = tu.channel_no
                  GROUP  BY tdc.company_name,
                            system_model) cc
              ON cc.channel_company = c.channel_company
                 AND cc.system_model = c.device_type
WHERE  c.first_dnum IS NOT NULL
        OR c.reg_unum IS NOT NULL
        OR c.first_buy_unum IS NOT NULL
        OR c.first_buy_amount IS NOT NULL
        OR c.buy_unum IS NOT NULL
        OR c.buy_amount IS NOT NULL 
        order by first_dnum desc,c.reg_unum desc ,first_buy_unum desc,first_buy_amount desc 
        ) t
        group by t.channel_company,t.device_type
