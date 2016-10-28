
set @param0='2016-09-01';

set @param1='2016-09-30 23:59:59';

set @param2='1';

set @param3='7';

-- set @channel_company = '苹果';
-- date_format(,'%Y-%m-%d') '日期',
select 
tt1.stat_time '日期',
tt1.SYSTEM_MODEL,
concat(@param2,'~',@param3) '留存日期',
tt1.user_count '用户',
tt1.rmb_value '充值', 
tt2.user_count '留存用户',
tt2.rmb_value '留存充值'

from (
	select '金币',
	date_format(tt.crt_time,'%Y-%m-%d') stat_time,
	tu.SYSTEM_MODEL, 
	count(distinct tc.charge_user_id) user_count,
	sum(tc.rmb_value) rmb_value 
	from (
		select * from (
			select * from (
				select tt.charge_user_id,tt.crt_time from (
					select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t  
					where t.charge_method !='APP'
				) tt order by tt.crt_time asc ) t
				group by t.charge_user_id 
		) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt 
	inner join t_trans_user_attr tu on tu.user_id = tt.charge_user_id   
	inner join t_trans_user_recharge_coin tc on tc.charge_user_id = tu.USER_ID and tc.charge_method !='APP' 
		and date(tc.CRT_TIME) = date(tt.crt_time)
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
	group by date(tt.crt_time),tu.SYSTEM_MODEL
) tt1
left join(
	select '金币',
	date_format(tt.crt_time,'%Y-%m-%d') stat_time,
	tu.SYSTEM_MODEL, 
	count(distinct tc.charge_user_id) user_count,
	sum(tc.rmb_value) rmb_value
	from (
		select * from (
			select * from (
				select tt.charge_user_id,tt.crt_time from (
					select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t  
					where t.charge_method !='APP'
				) tt order by tt.crt_time asc ) t
				group by t.charge_user_id 
		) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
	) tt 
	inner join t_trans_user_attr tu on tu.user_id = tt.charge_user_id   
	inner join t_trans_user_recharge_coin ttc on ttc.charge_user_id = tu.USER_ID and ttc.charge_method !='APP' 
		and date(ttc.CRT_TIME) = date(tt.crt_time)
		and ttc.charge_user_id not in (select user_id from t_user_merchant)
		and ttc.charge_user_id not in (select user_id from v_user_boss)
	left join t_trans_user_recharge_coin tc on tc.charge_user_id = tu.USER_ID and tc.charge_method !='APP' 
		and tc.CRT_TIME >=date_add(date(tt.CRT_TIME),interval @param2 day)
		and tc.CRT_TIME <=date_add(date(tt.CRT_TIME),interval @param3 day)
		and tc.charge_user_id not in (select user_id from t_user_merchant)
		and tc.charge_user_id not in (select user_id from v_user_boss)
	group by date(tt.crt_time),tu.SYSTEM_MODEL
) tt2 on tt1.SYSTEM_MODEL=tt2.SYSTEM_MODEL and tt1.stat_time=tt2.stat_time
;

		