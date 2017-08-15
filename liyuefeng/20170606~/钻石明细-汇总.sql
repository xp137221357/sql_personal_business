set @beginTime = '2017-06-06'; 
set @endTime = '2017-06-07'; 
set @acctType=1003; -- 1003,1004


-- 1 
-- 钻石增加明细
-- 首次充值,总充值,获赠钻石,获赠钻石券,推荐收入
-- 时间,'-',首次充值人数,首次充值金额,总充值人数,总充值金额,获赠送人数,获赠送金额,获赠钻石券人数,获赠钻石券金额,推荐收入人数,推荐收入金额
-- stat_date,consum,first_recharge_counts,first_recharge_amount,all_recharge_counts,all_recharge_amount,reward_counts,reward_amount,get_coupon_counts,get_coupon_amount,recom_earn_counts,recom_earn_amount
select 
t.stat_date, 
'' consum, 
t1.first_recharge_counts,
t1.first_recharge_amount,
t2.all_recharge_counts,
t2.all_recharge_amount,
t3.reward_counts,
t3.reward_amount,
t4.get_coupon_counts,
t4.get_coupon_amount,
t5.recom_earn_counts,
t5.recom_earn_amount
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join (
	select date(td.crt_time) stat_time,
	count(distinct td.charge_user_id) first_recharge_counts,round(sum(td.diamonds)) first_recharge_amount
	from t_trans_user_recharge_diamond td
	inner join t_stat_first_recharge_dmd tf on td.charge_user_id=tf.USER_ID 
	and tf.crt_time>=@beginTime 
	and tf.crt_time<=concat(@endTime,' 23:59:59')
	and td.crt_time>=@beginTime 
	and td.crt_time<=concat(@endTime,' 23:59:59')
	group by stat_time
) t1 on t.stat_date=t1.stat_time
left join (
	select date(td.crt_time) stat_time,
	count(distinct td.charge_user_id) all_recharge_counts,round(sum(td.diamonds)) all_recharge_amount
	from t_trans_user_recharge_diamond td
	where td.crt_time>=@beginTime 
	and td.crt_time<=concat(@endTime,' 23:59:59')
	group by stat_time
) t2 on t.stat_date=t2.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.USER_ID) reward_counts,round(sum(ai.CHANGE_VALUE)) reward_amount
	from forum.t_acct_items ai 
	where ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_EVENT ='DIAMEND_PRESENT'
	and ai.ITEM_STATUS=10 
	and ai.pay_time>=@beginTime 
	and ai.pay_time<=concat(@endTime,' 23:59:59')
	group by stat_time
) t3 on t.stat_date=t3.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.USER_ID) get_coupon_counts,round(sum(ai.CHANGE_VALUE*t.CHILD_CODE_VALUE)) get_coupon_amount
	from forum.t_acct_items ai 
	inner join forum.t_code t on convert(t.CHILD_CODE,signed)=ai.ACCT_TYPE 
	and t.CODE ='COUPONS' 
	and t.CHILD_CODE_VALUE!=-1 
	and ai.ITEM_STATUS=10 
	and (ai.TRADE_NO like 'SIGN_%' OR ai.TRADE_NO like 'ACT_YYLB%')
	and ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	group by stat_time
) t4 on t.stat_date=t4.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.USER_ID)  recom_earn_counts,round(sum(ai.CHANGE_VALUE))recom_earn_amount
	from forum.t_acct_items ai 
	where ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10 
	and ai.ITEM_EVENT='RECOM_PRIZE'
	and ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	group by stat_time
) t5 on t.stat_date=t5.stat_time;


-- 2
-- 钻石消耗明细
-- 首次购买,总购买服务,购买数据,购买推荐,购买VIP,购买金币
-- 时间,'-',首次购买人数,首次购买金额,,总购买人数,总购买金额,购买服务数,购买服务金额,购买推荐人数,购买推荐金额,购买VIP人数,购买VIP金额,购买金币人数,购买金币金额
-- stat_date,consum,first_buy_service_counts,first_buy_service_amount,all_buy_service_counts,all_buy_service_amount,buy_service_counts,buy_service_amount,buy_recom_counts,buy_recom_amount,buy_vip_counts,buy_vip_amount,
select 
t.stat_date,
'' consum, 
t1.first_buy_service_counts,
t1.first_buy_service_amount,
t2.all_buy_service_counts,
t2.all_buy_service_amount,
t3.buy_service_counts,
t3.buy_service_amount,
t4.buy_recom_counts,
t4.buy_recom_amount,
t5.buy_vip_counts,
t5.buy_vip_amount
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join (
	select date(ai.PAY_TIME) stat_time,
	count(distinct ai.user_id) first_buy_service_counts,
	round(sum(ai.CHANGE_VALUE)) first_buy_service_amount 
	from forum.t_acct_items ai 
	inner join report.t_stat_first_buy_srv ts on ai.USER_ID=ts.USER_ID 
	and ts.CRT_TIME>=@beginTime 
	and ts.CRT_TIME<=concat(@endTime,' 23:59:59')
	and date(ts.CRT_TIME)=date(ai.PAY_TIME)
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('buy_service','buy_recom','buy_vip')
	group by stat_time
) t1 on t.stat_date=t1.stat_time
left join (
	select date(ai.PAY_TIME) stat_time,
	count(distinct ai.user_id) all_buy_service_counts,
	round(sum(ai.CHANGE_VALUE)) all_buy_service_amount 
	from forum.t_acct_items ai 
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('buy_service','buy_recom','buy_vip')
	group by stat_time
) t2 on t.stat_date=t2.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.user_id) buy_service_counts,
	round(sum(ai.CHANGE_VALUE)) buy_service_amount 
	from forum.t_acct_items ai 
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('buy_service')
	group by stat_time
) t3 on t.stat_date=t3.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.user_id) buy_recom_counts,
	round(sum(ai.CHANGE_VALUE)) buy_recom_amount 
	from forum.t_acct_items ai 
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('buy_recom')
	group by stat_time
) t4 on t.stat_date=t4.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.user_id) buy_vip_counts,
	round(sum(ai.CHANGE_VALUE)) buy_vip_amount 
	from forum.t_acct_items ai 
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('buy_vip')
	group by stat_time
) t5 on t.stat_date=t5.stat_time
left join (
	select date(ai.pay_time) stat_time,
	count(distinct ai.user_id) buy_coin_counts,
	round(sum(ai.CHANGE_VALUE)) buy_coin_amount 
	from forum.t_acct_items ai 
	where ai.PAY_TIME>=@beginTime
	and ai.PAY_TIME<=concat(@endTime,' 23:59:59')
	and ai.ACCT_TYPE in (@acctType)
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('diamend_t_coin')
	group by stat_time
) t6 on t.stat_date=t6.stat_time;
