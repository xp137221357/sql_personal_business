set @param0='2016-12-01';
set @param1 = '2017-01-01';

-- 
-- 没有去代理本身
;
select concat(@param0,'~',@param1) '时间','新用户官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数' ,sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
where tt.charge_user_id not in (select user_id from report.t_user_merchant) and tt.charge_method='app'
and tt.charge_user_id not in (select user_id from report.t_user_general_agent)
and tt.charge_user_id not in (
	SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent)
		and u.client_id = 'BYAPP'
)
group by tt.charge_user_id   
)tt on  tt.crt_time>=@param0 and tt.crt_time<@param1 and tc.charge_method='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1

union all

select concat(@param0,'~',@param1) '时间','老用户官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
where tt.charge_user_id not in (select user_id from report.t_user_merchant) and tt.charge_method='app'
and tt.charge_user_id not in (select user_id from report.t_user_general_agent)
and tt.charge_user_id not in (
	SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent)
		and u.client_id = 'BYAPP'
)
group by tt.charge_user_id   
)tt on  tt.crt_time<@param0 and tc.charge_method='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1

union all

select concat(@param0,'~',@param1) '时间','全部用户官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
where tt.charge_user_id not in (select user_id from report.t_user_merchant) and tt.charge_method='app'
and tt.charge_user_id not in (select user_id from report.t_user_general_agent)
and tt.charge_user_id not in (
	SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent)
		and u.client_id = 'BYAPP'
)
group by tt.charge_user_id   
)tt on  tt.crt_time<@param1 and tc.charge_method='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1;



