-- set param=['2017-03-01','2017-03-10 23:59:59','2017-03-01','2017-03-10 23:59:59'];
set @param0='2017-03-01';
set @param1='2017-03-10 23:59:59';
set @param2='2017-03-01';
set @param3='2017-03-10 23:59:59';

select 
t1.CHANNEL_NAME '渠道名称',
t1.CHANNEL_NO'渠道编码',
t1.buy_counts '购买一元礼包人数',
t1.app_recharge_counts '官充人数',
t1.app_recharge_rmb '官充金额',
t2.third_recharge_counts '第三方充值人数',
t2.third_recharge_rmb'第三方充值金额',
t3.dmd_recharge_counts'钻石充值人数',
t3.dmd_recharge_rmb'钻石充值金额',
t4.bet_counts '投注人数',
t4.bet_coins '投注金币'

from (
	select 
	tu.CHANNEL_NAME,
	tu.CHANNEL_NO,
	count(t.charge_user_id) buy_counts,
	count(distinct tc.charge_user_id) app_recharge_counts,
	sum(tc.rmb_value) app_recharge_rmb
	from (
		select tc.charge_user_id from 
		report.t_trans_user_recharge_coin tc 
		where tc.rmb_value=1 
		and tc.crt_time>=@param0
		and tc.crt_time<=@param1
		group by tc.charge_user_id
	) t 
	inner join report.t_trans_user_attr tu on tu.USER_ID=t.charge_user_id
	left join report.t_trans_user_recharge_coin tc on tc.charge_user_id=tu.USER_ID
	and tc.rmb_value!=1 
	and tc.crt_time>=@param2
	and tc.crt_time<=@param3
	and tc.charge_method='app'
	group by tu.CHANNEL_NO
) t1
left join (
	select 
	tu.CHANNEL_NO,
	count(distinct tc.charge_user_id) third_recharge_counts,
	sum(tc.rmb_value) third_recharge_rmb
	from (
		select tc.charge_user_id from 
		report.t_trans_user_recharge_coin tc 
		where tc.rmb_value=1 
		and tc.crt_time>=@param0
		and tc.crt_time<=@param1
		group by tc.charge_user_id
	) t 
	inner join report.t_trans_user_attr tu on tu.USER_ID=t.charge_user_id
	left join report.t_trans_user_recharge_coin tc on tc.charge_user_id=tu.USER_ID
	and tc.rmb_value!=1 
	and tc.crt_time>=@param2
	and tc.crt_time<=@param3
	and tc.charge_method!='app'
	group by tu.CHANNEL_NO
)t2 on t1.CHANNEL_NO=t2.CHANNEL_NO
left join(
	select 
	tu.CHANNEL_NO ,
	count(distinct td.charge_user_id) dmd_recharge_counts,
	sum(td.rmb_value) dmd_recharge_rmb
	from (
		select tc.charge_user_id from 
		report.t_trans_user_recharge_coin tc 
		where tc.rmb_value=1 
		and tc.crt_time>=@param0
		and tc.crt_time<=@param1
		group by tc.charge_user_id
	) t 
	inner join report.t_trans_user_attr tu on tu.USER_ID=t.charge_user_id
	left join report.t_trans_user_recharge_diamond td on td.charge_user_id=tu.USER_ID
	and td.crt_time>=@param2
	and td.crt_time<=@param3
	group by tu.CHANNEL_NO
)t3 on t1.CHANNEL_NO=t3.CHANNEL_NO

left join (
	select 
	tu.CHANNEL_NO,
	count(distinct o.USER_ID) bet_counts,
	round(sum(o.COIN_BUY_MONEY)) bet_coins
	from (
		select tc.charge_user_id from 
		report.t_trans_user_recharge_coin tc 
		where tc.rmb_value=1 
		and tc.crt_time>=@param0
		and tc.crt_time<=@param1
		group by tc.charge_user_id
	) t 
	inner join report.t_trans_user_attr tu on tu.USER_ID=t.charge_user_id
	left join game.t_order_item o on o.USER_ID=tu.USER_CODE
	and o.PAY_TIME>=@param2
	and o.PAY_TIME<=@param3
	and o.COIN_BUY_MONEY>0
	group by tu.CHANNEL_NO
) t4 on t1.CHANNEL_NO=t4.CHANNEL_NO


