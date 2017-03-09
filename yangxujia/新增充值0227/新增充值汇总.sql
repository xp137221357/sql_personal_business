set param=['2017-02-13', '2017-02-19 23:59:59'];

select 
tt1.stat_time '时间',
tt1.channel_company '公司名',
tt1.channel_name '渠道名',
tt1.system_model '终端',

tt1.first_dnum '首次激活',
tt1.reg_unum '注册人数',
tt1.reg_active '注册/激活',
tt1.first_buy_unum '新增充值人数',
tt1.first_recharge_reg '新增充值/注册',
tt1.first_recharge_active '新增充值/激活',
tt1.first_buy_amount '新增充值金额',
tt1.per_first_recharge_money '新增人均充值金额',
tt1.buy_unum '充值人数',
tt1.buy_amount '充值金额',
tt1.per_recharge_money '人均充值金额',

tt2.total_users '总新增充值人数',
tt2.app_recharge+tt2.third_recharge '总新增充值金额',
tt2.app_users '新增官充人数',
tt2.app_recharge '新增官充金额',
tt2.third_users '新增第三方充值人数',
tt2.third_recharge '新增第三方充值金额',

tt3.total_users '总人数',
tt3.total_recharge '总金额',
tt3.app_users '官充人数',  
tt3.app_recharge '官充金额',
tt3.third_users '第三方充值人数',
tt3.third_recharge '第三方充值金额'

from (
	SELECT
	Concat(@param0, '~', @param1)stat_time,
	ifnull(tdc.company_name,'other') channel_company,
	ifnull(tdc.channel_name,'other') channel_name,
	ifnull(tdc.system_model,'other') SYSTEM_MODEL,
	c.first_dnum,
	c.reg_unum,
	Concat(Round(IF(c.first_dnum > 0, c.reg_unum * 100 / c.first_dnum, 0), 2), '%') reg_active,
	c.first_buy_unum,
	Concat(Round(IF(c.reg_unum > 0, c.first_buy_unum * 100 / c.reg_unum, 0), 2), '%')  first_recharge_reg,
	Concat(Round(IF(c.first_dnum > 0, c.first_buy_unum * 100 / c.first_dnum, 0), 2), '%') first_recharge_active,
	c.first_buy_amount,
	Round(IF(c.first_buy_unum > 0, c.first_buy_amount / c.first_buy_unum, 0), 2) per_first_recharge_money,
	cc.buy_unum,
	c.buy_amount,
	Round(IF(c.buy_unum > 0, c.buy_amount / cc.buy_unum, 0), 2) per_recharge_money
	FROM   (SELECT channel_no,
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
	        WHERE  period_type = '1'
	               AND period_name >= @param0
	               AND period_name <= @param1
	        GROUP  BY channel_no,
	                  device_type) c
	       LEFT JOIN (SELECT tu.channel_no,
	                         tu.system_model,
	                         Count(DISTINCT ai.user_id) buy_unum
	                  FROM   forum.t_acct_items ai
	                         INNER JOIN forum.t_user u
	                                 ON u.user_id = ai.user_id
	                                    AND u.client_id = 'BYAPP'
	                                    AND u.group_type != 1
	                         LEFT JOIN report.t_trans_user_attr tu
	                                ON ai.user_id = tu.user_id 
	                  WHERE  ai.item_status = 10
	                         AND ai.item_event = 'BUY_DIAMEND'
	                         AND ai.add_time >= @param0
	                         AND ai.add_time <= @param1
	                  GROUP  BY tu.channel_no,
	                            tu.system_model) cc
	              ON cc.channel_no = c.channel_no
	                 AND cc.system_model = c.device_type
	       LEFT JOIN report.t_device_channel tdc
	              ON tdc.channel_no = c.channel_no
	                 AND tdc.system_model = c.device_type
	WHERE  ( c.first_dnum IS NOT NULL
	          OR c.reg_unum IS NOT NULL
	          OR c.first_buy_unum IS NOT NULL
	          OR c.first_buy_amount IS NOT NULL
	          OR c.buy_unum IS NOT NULL
	          OR c.buy_amount IS NOT NULL )
	ORDER  BY c.first_dnum DESC,
	          c.reg_unum DESC,
	          c.first_buy_unum DESC,
	          c.first_buy_amount DESC 
) tt1 

left join (

	select 
	   t1.channel_company,
	   t1.channel_name,
	   t1.SYSTEM_MODEL,
	   t1.total_users ,
		t2.app_users,
		t2.app_recharge,
		t3.third_users,
		t3.third_recharge
		from (
		select ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.channel_name,'other') channel_name,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) total_users
		from (
		select tu.*,tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'a_coin' method from t_trans_user_recharge_coin t where t.charge_method='app' group by t.charge_user_id  
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc 
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  
		and tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
	
		union all
		
		select tu.*,tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'t_coin' method  from t_trans_user_recharge_coin t where t.charge_method!='app' group by t.charge_user_id 
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc 
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  
		and tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL  
	) t1
	left join (
		select 
		ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.CHANNEL_NAME,'other') channel_name,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) app_users,
		sum(ttt.rmb_value) app_recharge
		from (
		select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
		inner join (
		
		select tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'a_coin' method from t_trans_user_recharge_coin t where t.charge_method='app' group by t.charge_user_id  
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc where tc.crt_time>=@param0 and tc.crt_time<=@param1 
		
		) tt on tc.charge_user_id = tt.charge_user_id 
		and tc.charge_method='APP'
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID 
		where 
		tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		union all
		select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
		
		inner join (
		
		select tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'a_coin' method from t_trans_user_recharge_coin t where t.charge_method='app' group by t.charge_user_id  
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc where tc.crt_time>=@param0 and tc.crt_time<=@param1
		
		) tt on td.charge_user_id = tt.charge_user_id 
		and td.charge_method='APP'
		inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID 
		where td.CRT_TIME >=@param0
		and td.CRT_TIME <=@param1
		and td.charge_user_id not in (select user_id from t_user_merchant)
		and td.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL  
	
	)t2 on t1.channel_name=t2.channel_name and t1.SYSTEM_MODEL=t2.SYSTEM_MODEL 
	left join (
	   select 
		ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.CHANNEL_NAME,'other') channel_name,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) third_users,
		sum(ttt.rmb_value) third_recharge
	   from (
		select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.CHANNEL_NAME, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
		
		inner join (
		select tt.charge_user_id,min(tt.crt_time) crt_time from (
		select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t where t.charge_method!='APP' group by t.charge_user_id   
		)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 group by tt.charge_user_id
		) tt on tc.charge_user_id = tt.charge_user_id and tc.charge_method!='APP'
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID
		where 
		tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL  
	)t3 on t1.channel_name=t3.channel_name and t1.SYSTEM_MODEL=t3.SYSTEM_MODEL

) tt2 on tt1.channel_name=tt2.channel_name and tt1.SYSTEM_MODEL=tt2.SYSTEM_MODEL

left join (
	select 
	   concat(@param0,'~',@param1) '起始时间',
	   t1.channel_company ,
	   t1.channel_name ,
	   t1.SYSTEM_MODEL,
	   t1.total_users ,
		t1.total_recharge ,
		t2.app_users,
		t2.app_recharge,
		t3.third_users,
		t3.third_recharge
		from (
		select ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.channel_name,'other') channel_name,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) total_users,
		sum(ttt.rmb_value) total_recharge
		from (
		select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID 
		where 
		tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		
		union all
		
		select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
		inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID 
		where td.CRT_TIME >=@param0
		and td.CRT_TIME <=@param1
		and td.charge_user_id not in (select user_id from t_user_merchant)
		and td.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL
	) t1
	left join (
		select 
		ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.channel_name,'other') channel_name,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) app_users,
		sum(ttt.rmb_value) app_recharge
		from (
		select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID 
		and tc.charge_method='APP'
		where 
		tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		union all
		select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.channel_name,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
		inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID 
		and td.charge_method='APP'
		where td.CRT_TIME >=@param0
		and td.CRT_TIME <=@param1
		and td.charge_user_id not in (select user_id from t_user_merchant)
		and td.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL
	)t2 on t1.channel_name=t2.channel_name and t1.SYSTEM_MODEL=t2.SYSTEM_MODEL 
	left join (
	   select 
		ifnull(ttt.channel_company,'other') channel_company,
		ifnull(ttt.CHANNEL_NAME,'other') CHANNEL_NAME,
		ifnull(ttt.SYSTEM_MODEL,'other') SYSTEM_MODEL,
		count(distinct ttt.charge_user_id) third_users,
		sum(ttt.rmb_value) third_recharge
	   from (
		select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,tu.CHANNEL_NAME, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID 
		and tc.charge_method !='APP'
		where 
		tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL  
	)t3 on t1.channel_name=t3.channel_name and t1.SYSTEM_MODEL=t3.SYSTEM_MODEL 

) tt3 on tt1.channel_name=tt3.channel_name and tt1.SYSTEM_MODEL=tt3.SYSTEM_MODEL
          
          
          

