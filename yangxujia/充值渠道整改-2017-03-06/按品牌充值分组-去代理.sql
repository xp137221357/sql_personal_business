-- set param=['2017-01-01', '2017-01-31 23:59:59', '2017-01-01', '2017-01-31 23:59:59'];

set @param0='2016-08-01';
set @param1='2017-01-31 23:59:59';
set @param2='2016-08-01';
set @param3='2017-01-31 23:59:59';

select 
   concat(@param0,'~',@param1) '起始时间',
   concat(@param2,'~',@param3) '留存时间',
   t1.mobile_brand '品牌',
   t1.total_users '总人数',
	t1.total_recharge '总金额',
	t2.app_users '官充人数',
	t2.app_recharge '官充金额',
	t2.app_users_coin '官充金币人数',
	t2.app_recharge_coin '官充金币金额',
	t2.app_users_dmd '官充钻石人数',
	t2.app_recharge_dmd '官充钻石金额',
	t3.third_users '第三方充值人数',
	t3.third_recharge '第三方充值金额',
	t4.bet_count '投注人数',
	t4.bet_coins '投注金币'
	from (
	select ifnull(ttt.mobile_brand,'other') mobile_brand,
	count(distinct ttt.charge_user_id) total_users,
	sum(ttt.rmb_value) total_recharge
	from (
	select '金币',tu.mobile_brand, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
	inner join report.t_user_mobile tu on tc.charge_user_id = tu.USER_ID 
	and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			) 
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on tc.charge_user_id = tt.charge_user_id 
	where 
	tc.CRT_TIME >=@param2
	and tc.CRT_TIME <=@param3
	and tc.charge_user_id not in (select user_id from t_user_merchant)
	and tc.charge_user_id not in (select user_id from v_user_boss)
	
	union all
	
	select '钻石',tu.mobile_brand,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
	inner join report.t_user_mobile tu on td.charge_user_id = tu.USER_ID  
	and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			)
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on td.charge_user_id = tt.charge_user_id 
	where td.CRT_TIME >=@param2
	and td.CRT_TIME <=@param3
	and td.charge_user_id not in (select user_id from t_user_merchant)
	and td.charge_user_id not in (select user_id from v_user_boss)
	) ttt
	group by ttt.mobile_brand
) t1
left join (
	select 
	ifnull(ttt.mobile_brand,'other') mobile_brand,
	count(distinct ttt.charge_user_id) app_users,
	sum(ttt.rmb_value) app_recharge,
	count(distinct if(buy_type=0,ttt.charge_user_id,null)) app_users_coin,
	sum(if(buy_type=0,ttt.rmb_value,0)) app_recharge_coin,
	count(distinct if(buy_type=1,ttt.charge_user_id,null)) app_users_dmd,
	sum(if(buy_type=1,ttt.rmb_value,0)) app_recharge_dmd
	from (
	select '金币',tu.mobile_brand, tc.charge_user_id,tc.rmb_value,0 as buy_type from t_trans_user_recharge_coin tc
	inner join report.t_user_mobile tu on tc.charge_user_id = tu.USER_ID  
	and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			)
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method ='APP'
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on tc.charge_user_id = tt.charge_user_id 
	and tc.charge_method='APP'
	where 
	tc.CRT_TIME >=@param2
	and tc.CRT_TIME <=@param3
	and tc.charge_user_id not in (select user_id from t_user_merchant)
	and tc.charge_user_id not in (select user_id from v_user_boss)
	union all
	select '钻石',tu.mobile_brand,td.charge_user_id,td.rmb_value,1 as buy_type from t_trans_user_recharge_diamond td
	inner join report.t_user_mobile tu on td.charge_user_id = tu.USER_ID 
	and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			) 
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t  where t.charge_method ='APP'
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on td.charge_user_id = tt.charge_user_id 
	and td.charge_method='APP'
	where td.CRT_TIME >=@param2
	and td.CRT_TIME <=@param3
	and td.charge_user_id not in (select user_id from t_user_merchant)
	and td.charge_user_id not in (select user_id from v_user_boss)
	) ttt
	group by ttt.mobile_brand
)t2 on t1.mobile_brand=t2.mobile_brand 
left join (
   select 
	ifnull(ttt.mobile_brand,'other') mobile_brand,
	count(distinct ttt.charge_user_id) third_users,
	sum(ttt.rmb_value) third_recharge
   from (
	select '金币',tu.mobile_brand, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
	inner join report.t_user_mobile tu on tc.charge_user_id = tu.USER_ID 
	and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			)
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method !='APP'
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on tc.charge_user_id = tt.charge_user_id 
	and tc.charge_method !='APP'
	where 
	tc.CRT_TIME >=@param2
	and tc.CRT_TIME <=@param3
	and tc.charge_user_id not in (select user_id from t_user_merchant)
	and tc.charge_user_id not in (select user_id from v_user_boss)
	) ttt
	group by ttt.mobile_brand 
)t3 on t1.mobile_brand=t3.mobile_brand 
left join (
select tu.mobile_brand,count(distinct oi.user_id) bet_count,round(sum(oi.COIN_BUY_MONEY)) bet_coins from (
select * from (
select tc.charge_user_id from t_trans_user_recharge_coin tc
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on tc.charge_user_id = tt.charge_user_id 
	where 
	tc.CRT_TIME >=@param2
	and tc.CRT_TIME <=@param3
	and tc.charge_user_id not in (select user_id from t_user_merchant)
	and tc.charge_user_id not in (select user_id from v_user_boss)
	
	union all
	
	select td.charge_user_id from t_trans_user_recharge_diamond td
	inner join (
	select * from (
	select * from (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
	union all
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
	) tt order by tt.crt_time asc ) t
	group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt on td.charge_user_id = tt.charge_user_id 
	where td.CRT_TIME >=@param2
	and td.CRT_TIME <=@param3
	and td.charge_user_id not in (select user_id from t_user_merchant)
	and td.charge_user_id not in (select user_id from v_user_boss)
) t group by t.charge_user_id
) tt 
inner join report.t_user_mobile tu on tu.USER_ID = tt.charge_user_id
and tu.USER_ID not in (
			SELECT 
			       u.user_id
			FROM   forum.t_user u
			       INNER JOIN game.t_group_ref r1
			               ON u.user_code = r1.user_id
			       INNER JOIN game.t_group_ref r2
			               ON r1.root_id = r2.ref_id
			       INNER JOIN report.t_user_general_agent tu 
			       			ON r2.user_id = tu.user_code
			WHERE  u.client_id = 'BYAPP'
			union 
			select user_id from  report.t_user_general_agent
			)
inner join report.t_trans_user_attr ta on ta.USER_ID= tu.USER_ID 
left join game.t_order_item oi on ta.USER_CODE=oi.USER_ID 
and oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
and oi.COIN_BUY_MONEY>0
and oi.PAY_TIME >= @param2 and oi.PAY_TIME <= @param3
group by tu.mobile_brand
) t4 on t1.mobile_brand=t4.mobile_brand