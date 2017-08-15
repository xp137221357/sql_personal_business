-- 新用户充值留存

-- 老用户充值留存

set @param0='2017-07-01';
set @param2='7月份';
set @param4='购买金币';
set @param3='老用户';
set @param1='';

select 

@param4 '事件类型',
@param3 '用户属性',
@param2 '时间',

count(distinct t.charge_user_id) '基础用户',

count(distinct t1.charge_user_id) '1月后',

count(distinct t2.charge_user_id) '2月后',

count(distinct t3.charge_user_id) '3月后',

count(distinct t4.charge_user_id) '4月后',

count(distinct t5.charge_user_id) '5月后',

count(distinct t6.charge_user_id) '6月后',

count(distinct t7.charge_user_id) '7月后',

count(distinct t8.charge_user_id) '8月后',

count(distinct t9.charge_user_id) '9月后',

count(distinct t10.charge_user_id) '10月后',

count(distinct t11.charge_user_id) '11月后',

count(distinct t12.charge_user_id) '12月后'

 from (
select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
and tu.CRT_TIME<@param0
where tc.crt_time>=@param0
and tc.crt_time< date_add(@param0,interval 1 month)
group by tc.charge_user_id
) t
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 1 month)
	and tc.crt_time< date_add(@param0,interval 2 month)
	group by tc.charge_user_id
)t1 on t1.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 2 month)
	and tc.crt_time< date_add(@param0,interval 3 month)
	group by tc.charge_user_id
)t2 on t2.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 3 month)
	and tc.crt_time< date_add(@param0,interval 4 month)
	group by tc.charge_user_id
)t3 on t3.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 4 month)
	and tc.crt_time< date_add(@param0,interval 5 month)
	group by tc.charge_user_id
)t4 on t4.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 5 month)
	and tc.crt_time< date_add(@param0,interval 6 month)
	group by tc.charge_user_id
)t5 on t5.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 6 month)
	and tc.crt_time< date_add(@param0,interval 7 month)
	group by tc.charge_user_id
)t6 on t6.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 7 month)
	and tc.crt_time< date_add(@param0,interval 8 month)
	group by tc.charge_user_id
)t7 on t7.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 8 month)
	and tc.crt_time< date_add(@param0,interval 9 month)
	group by tc.charge_user_id
)t8 on t8.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 9 month)
	and tc.crt_time< date_add(@param0,interval 10 month)
	group by tc.charge_user_id
)t9 on t9.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 10 month)
	and tc.crt_time< date_add(@param0,interval 11 month)
	group by tc.charge_user_id
)t10 on t10.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 11 month)
	and tc.crt_time< date_add(@param0,interval 12 month)
	group by tc.charge_user_id
)t11 on t11.charge_user_id=t.charge_user_id
left join (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc 
	inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	where tc.crt_time>=date_add(@param0,interval 12 month)
	and tc.crt_time< date_add(@param0,interval 13 month)
	group by tc.charge_user_id
)t12 on t12.charge_user_id=t.charge_user_id

