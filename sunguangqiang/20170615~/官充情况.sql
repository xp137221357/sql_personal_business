-- 新增官方充值用户


BEGIN

set @param0 = '2017-06-01';

label1: WHILE @param0 <='2017-07-08' Do

INSERT into t_recharge_coins_20170709(stat_date,counts,money)
select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(distinct tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
) t1 left join(
	select 
	count(distinct tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
)t2 on 1=1


on duplicate key update 
counts = values(counts),
money = values(money);


INSERT into t_recharge_coins_20170709(stat_date,counts1,money1)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=12
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=12
)t2 on 1=1


on duplicate key update 
counts1 = values(counts1),
money1 = values(money1);

INSERT into t_recharge_coins_20170709(stat_date,counts2,money2)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=30
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=30
)t2 on 1=1


on duplicate key update 
counts2 = values(counts2),
money2 = values(money2);


INSERT into t_recharge_coins_20170709(stat_date,counts3,money3)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=68
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=68
)t2 on 1=1


on duplicate key update 
counts3 = values(counts3),
money3 = values(money3);

INSERT into t_recharge_coins_20170709(stat_date,counts4,money4)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=128
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=128
)t2 on 1=1


on duplicate key update 
counts4 = values(counts4),
money4 = values(money4);

INSERT into t_recharge_coins_20170709(stat_date,counts5,money5)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=328
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=328
)t2 on 1=1


on duplicate key update 
counts5 = values(counts5),
money5 = values(money5);


INSERT into t_recharge_coins_20170709(stat_date,counts6,money6)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=648
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=648
)t2 on 1=1


on duplicate key update 
counts6 = values(counts6),
money6 = values(money6);

INSERT into t_recharge_coins_20170709(stat_date,counts7,money7)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=1000
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=1000
)t2 on 1=1


on duplicate key update 
counts7 = values(counts7),
money7 = values(money7);

INSERT into t_recharge_coins_20170709(stat_date,counts8,money8)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=3000
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=3000
)t2 on 1=1


on duplicate key update 
counts8 = values(counts8),
money8 = values(money8);

INSERT into t_recharge_coins_20170709(stat_date,counts9,money9)

select 
date(@param0) stat_date,
ifnull(t1.first_app_recharge_counts,0)+ifnull(t2.first_app_recharge_counts,0) first_app_recharge_counts,
ifnull(t1.first_app_recharge_coins,0)+ifnull(t2.first_app_recharge_coins,0) first_app_recharge_coins
from (
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_user_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=5000
) t1 left join(
	select 
	count(tc.charge_user_id) first_app_recharge_counts,
	ifnull(sum(tc.rmb_value),0) first_app_recharge_coins
	from report.t_trans_merchant_recharge_coin tc
	inner join (
		select tc.charge_user_id,min(tc.crt_time) crt_time from report.t_trans_user_recharge_coin tc 
		inner join report.t_trans_user_attr tu on tc.charge_user_id=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
		where tc.charge_method='app'
		group by tc.charge_user_id
	) t on tc.charge_user_id=t.charge_user_id 
	and t.crt_time>=@param0
	and t.crt_time< date_add(@param0,interval 1 day)
	and tc.crt_time>=@param0
	and tc.crt_time< date_add(@param0,interval 1 day)
	and tc.charge_method='app'
	and tc.rmb_value=5000
)t2 on 1=1


on duplicate key update 
counts9 = values(counts9),
money9 = values(money9);


SET @param0 = date_add(@param0,interval 1 day);
end while label1;

end