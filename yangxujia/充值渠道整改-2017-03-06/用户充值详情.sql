set @param0 = '2017-03-20'; 
set @param1 = '2017-03-26 23:59:59';

-- 注意：
-- 将官充和第三方完全分开

-- 总充值
select '总充值' 充值类型,count(distinct tc.charge_user_id) '充值人数',sum(tc.rmb_value) '充值人民币' from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1
union all
select '官方总充值',count(distinct tc.charge_user_id),sum(tc.rmb_value) from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app'
union all
select '第三方充值',count(distinct tc.charge_user_id),sum(tc.rmb_value) from report.t_trans_user_recharge_coin tc
where tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method!='app'

union all

--  新增充值钻石
select '新增充值钻石' 充值类型,count(distinct td.charge_user_id) '充值人数',sum(td.rmb_value) '充值人民币'
from report.t_trans_user_recharge_diamond td
inner join report.t_stat_first_recharge_dmd tdd on td.charge_user_id=tdd.USER_ID
where td.crt_time>=@param0
and td.crt_time<@param1
and tdd.crt_time>=@param0
and tdd.crt_time<=@param1

union all

select '新增官充金币',count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_coin td
inner join (
	select tc.charge_user_id from 
	report.t_trans_user_recharge_coin tc
	inner join (
		select min(t.sn) sn
		from report.t_trans_user_recharge_coin t 
		group by t.charge_user_id
	) t on tc.sn=t.sn 
	and tc.crt_time>=@param0
	and tc.crt_time<=@param1
	and tc.charge_method='app'
) tdd on td.charge_user_id=tdd.charge_user_id
where td.crt_time>=@param0
and td.crt_time<=@param1
and td.charge_method='app'

union all

select '新增第三方充值金币',count(distinct td.charge_user_id),sum(td.rmb_value) 
from report.t_trans_user_recharge_coin td
inner join (
	select tc.charge_user_id from 
	report.t_trans_user_recharge_coin tc
	inner join (
		select min(t.sn) sn
		from report.t_trans_user_recharge_coin t 
		group by t.charge_user_id
	) t on tc.sn=t.sn 
	and tc.crt_time>=@param0
	and tc.crt_time<=@param1
	and tc.charge_method!='app'
) tdd on td.charge_user_id=tdd.charge_user_id
where td.crt_time>=@param0
and td.crt_time<=@param1
and td.charge_method!='app'


union all

select '新增充值金币总人数',count(1),null from (
select tc.charge_user_id from 
report.t_trans_user_recharge_coin tc
inner join (
	select min(t.sn) sn
	from report.t_trans_user_recharge_coin t where t.charge_method='app'
	group by t.charge_user_id
) t on tc.sn=t.sn 
and tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method='app'
union
select tc.charge_user_id from 
report.t_trans_user_recharge_coin tc
inner join (
	select min(t.sn) sn
	from report.t_trans_user_recharge_coin t where t.charge_method!='app'
	group by t.charge_user_id
) t on tc.sn=t.sn 
and tc.crt_time>=@param0
and tc.crt_time<=@param1
and tc.charge_method!='app'
) t ;

