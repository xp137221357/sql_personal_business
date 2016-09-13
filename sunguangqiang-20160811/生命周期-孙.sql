set @beginTime:='2016-07-12 00:00:00';
set @endTime:='2016-07-17 23:59:59';

-- 欧洲杯前（5.9-6.9） 			 						
-- '2016-05-09 00:00:00'	'2016-06-09 23:59:59'
-- 欧洲杯（6.10-7.11） 	'2
-- '2016-06-10 00:00:00'	 '2016-07-11 23:59:59'						
-- 欧洲杯后（7.12-7.17） 
-- '2016-07-12 00:00:00'	 '2016-07-17 23:59:59'
	
-- UV  t_rpt_h5_url_pv_uv

select 'uv', sum(tr.UV) from forum.t_rpt_h5_url_pv_uv tr 
where tr.PERIOD_TYPE=1 
and tr.PERIOD_NAME>=@beginTime
and tr.PERIOD_NAME <= @endTime

UNION ALL


-- 设备激活
select '设备激活', count(DISTINCT device_code) from forum.t_device_info ti
inner join forum.t_user u on u.USER_CODE = ti.user_code and u.`STATUS` =10
where ti.ADD_TIME >=@beginTime
and ti.ADD_TIME <=@endTime


UNION ALL

-- 新注册用户数
select '新注册用户数' ,count(DISTINCT USER_ID) from forum.t_user tu
where tu.CLIENT_ID = 'BYAPP' and tu.`STATUS` =10
and tu.CRT_TIME >=@beginTime
and tu.CRT_TIME <=@endTime

UNION ALL

-- 新充值用户数(包括第三方)

select '新充值用户数', count(DISTINCT t1.USER_ID) from (
select tc.charge_user_id user_id from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime and tc.crt_time<=@endTime
union all
select td.charge_user_id user_id from t_trans_user_recharge_diamond td where td.crt_time>=@beginTime and td.crt_time<=@endTime
) t1
inner join forum.t_user u on t1.USER_ID = u.user_id and u.CLIENT_ID = 'BYAPP' and u.`STATUS` =10 AND u.crt_time>=@beginTime and u.crt_time<=@endTime

UNION ALL


-- 新投注用户数
select ' 新投注用户数', count(DISTINCT tu.USER_ID) from test.t_stat_first_recharge_bet tu
 inner join forum.t_user u on tu.USER_ID = u.user_id and u.`STATUS` =10 and u.CLIENT_ID = 'BYAPP' AND u.crt_time>=@beginTime and u.crt_time<=@endTime
where tu.CRT_TIME >=@beginTime
and tu.CRT_TIME <=@endTime

UNION ALL


-- 新购买服务用户数
select '新购买服务用户数', count(DISTINCT tu.USER_ID) from test.t_stat_first_buy_srv tu
inner join forum.t_user u on tu.USER_ID = u.user_id and u.`STATUS` =10 and u.CLIENT_ID = 'BYAPP' AND u.crt_time>=@beginTime and u.crt_time<=@endTime
where tu.CRT_TIME >=@beginTime
and tu.CRT_TIME <=@endTime;



