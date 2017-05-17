
set @param0='2016-11-01';
set @param1='2017-05-15 23:59:59';
set @param2='%百度手机助手%';


-- 新增官方金币充值
select '新增官方金币充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '新增充值人数',sum(tc.rmb_value) '新增充值rmb' 
from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
inner join (
select t.charge_user_id from (
	select t.charge_user_id,t.crt_time from (
		select tc.charge_user_id,tc.crt_time from report.t_trans_user_recharge_coin tc 
		where tc.charge_method='app'
		order by tc.sn asc
	) t 
	group by t.charge_user_id
) t 
where t.crt_time>=@param0
and t.crt_time<=@param1
) t on t.charge_user_id=tc.charge_user_id
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all


-- 新增第三方金币充值
select '新增第三方金币充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '新增充值人数',sum(tc.rmb_value) '新增充值rmb' 
from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
inner join (
select t.charge_user_id from (
	select t.charge_user_id,t.crt_time from (
		select tc.charge_user_id,tc.crt_time from report.t_trans_user_recharge_coin tc 
		where tc.charge_method!='app'
		order by tc.sn asc
	) t 
	group by t.charge_user_id
) t 
where t.crt_time>=@param0
and t.crt_time<=@param1
) t on t.charge_user_id=tc.charge_user_id
where tc.charge_method!='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all


-- 官方金币充值
select '官方金币充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '新增充值人数',sum(tc.rmb_value) '新增充值rmb' 
from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all


-- 第三方金币充值
select '第三方金币充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '新增充值人数',sum(tc.rmb_value) '新增充值rmb' 
from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tc.charge_method!='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all

-- 新增钻石充值
select '新增钻石充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '新增充值钻石人数',sum(tc.rmb_value) '新增钻石充值rmb' 
from report.t_trans_user_recharge_diamond tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
inner join (
select t.charge_user_id from (
	select t.charge_user_id,t.crt_time from (
		select tc.charge_user_id,tc.crt_time from report.t_trans_user_recharge_diamond tc 
		where tc.charge_method='app'
		order by tc.sn asc
	) t 
	group by t.charge_user_id
) t 
where t.crt_time>=@param0
and t.crt_time<=@param1
) t on t.charge_user_id=tc.charge_user_id
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all


-- 钻石充值
select '钻石充值',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tc.charge_user_id) '充值钻石人数',sum(tc.rmb_value) '钻石充值rmb' 
from report.t_trans_user_recharge_diamond tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1


union all


select '新增官充人数',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct tf.USER_ID) '新增官充人数','-' 
from report.t_stat_first_recharge tf
inner join report.t_trans_user_attr tu on tf.USER_ID=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tf.CRT_TIME>=@param0
and tf.CRT_TIME<=@param1


union all

-- 官充人数
select '官充人数',concat(@param0,'~',@param1) '时间',@param2 '渠道',count(distinct t.charge_user_id) '官充人数','-' from (
select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1

union all 

select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID
inner join (
	select td.CHANNEL_NO from report.t_device_channel td where td.CHANNEL_NAME like @param2
	group by td.CHANNEL_NO
) td on tu.CHANNEL_NO=td.CHANNEL_NO 
where tc.charge_method='app'
and tc.crt_time>=@param0
and tc.crt_time<=@param1
) t ;
