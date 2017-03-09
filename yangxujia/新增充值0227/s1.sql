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
		select t.charge_user_id,min(t.crt_time) crt_time,'t_coin' method  from t_trans_user_recharge_coin t where t.charge_method!='app' group by t.charge_user_id 
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc 
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tc.method='a_coin' 
		and tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		
		union all
		
		select tu.*,tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'a_coin' method from t_trans_user_recharge_coin t where t.charge_method='app' group by t.charge_user_id  
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'t_coin' method  from t_trans_user_recharge_coin t where t.charge_method!='app' group by t.charge_user_id 
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc 
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tc.method='t_coin' 
		and tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		
		union all
		
		select tu.*,tc.charge_user_id from (		
		select t2.* from (	
		select t1.charge_user_id,t1.crt_time,t1.method from (
		select t.charge_user_id,min(t.crt_time) crt_time,'a_coin' method from t_trans_user_recharge_coin t where t.charge_method='app' group by t.charge_user_id  
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'t_coin' method  from t_trans_user_recharge_coin t where t.charge_method!='app' group by t.charge_user_id 
		union all
		select t.charge_user_id,min(t.crt_time) crt_time,'diamend' method from t_trans_user_recharge_diamond t group by t.charge_user_id
		)t1 order by t1.crt_time asc 
		)t2 group by t2.charge_user_id 
		) tc 
		inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tc.method='diamend' 
		and tc.CRT_TIME >=@param0
		and tc.CRT_TIME <=@param1
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
		) ttt
		group by ttt.channel_name,ttt.SYSTEM_MODEL 