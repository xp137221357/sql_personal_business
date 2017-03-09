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