专家推荐

新增专家,全部专家,媒体专家,草根专家,实战专家

时间,专家数目,购买人数,购买次数,购买金额,专家分成,专家数目,购买人数,购买次数,购买金额,专家分成,专家数目,购买人数,购买次数,购买金额,专家分成,专家数目,购买人数,购买次数,购买金额,专家分成,专家数目,购买人数,购买次数,购买金额,专家分成,

stat_date,first_experts_counts,first_buy_counts,first_buy_times,first_buy_money,first_buy_reward,all_experts_counts,all_buy_counts,all_buy_times,all_buy_money,all_buy_reward,media_experts_counts,media_buy_counts,media_buy_times,media_buy_money,media_buy_reward,plain_experts_counts,plain_buy_counts,plain_buy_times,plain_buy_money,plain_buy_reward,combat_experts_counts,combat_buy_counts,combat_buy_times,combat_buy_money,combat_buy_reward


周：

set @beginTime='2017-05-05';
set @endTime='2017-07-01';

select * from (
	select 
	t.stat_date, 
	t1.first_experts_counts,
	t2.first_buy_counts,
	t2.first_buy_times,
	t2.first_buy_money,
	t2.first_buy_reward
	from (
		select 
		date_format(t.stat_date,'%Y-%m') stat_date
		from t_stat_reference_time t
		where t.stat_date>=@beginTime
		and t.stat_date<=concat(@endTime,' 23:59:59')
		group by date_format(t.stat_date,'%Y-%m')
	) t
	left join (
		select 
		date_format(ta.crt_time,'%Y-%m') stat_time,count(distinct u.USER_ID) first_experts_counts
		from forum.t_user u 
		INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		and ta.MOD_TIME>=@beginTime and ta.MOD_TIME<=concat(@endTime,' 23:59:59')
		group by stat_time
	) t1 on t.stat_date=t1.stat_time
	left join(
		SELECT 
		date_format(tr.crt_time,'%Y-%m') stat_time,
		count(distinct tr.USER_ID) first_buy_counts,
		count(tr.RECOM_ID) first_buy_times,
		sum(tr.money) first_buy_money,
		sum(tr.crt_reward) first_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		and ta.MOD_TIME>=@beginTime and ta.MOD_TIME<=concat(@endTime,' 23:59:59')
		and date_format(ta.MOD_TIME,'%Y-%m') = date_format(tr.crt_time,'%Y-%m')
		group by stat_time
	) t2 on t.stat_date=t2.stat_time
) tt1 
inner join(
	select 
	t.stat_date, 
	t1.all_experts_counts,
	t1.all_buy_counts,
	t1.all_buy_times,
	t1.all_buy_money,
	t1.all_buy_reward
	from (
		select 
		date_format(t.stat_date,'%Y-%m') stat_date
		from t_stat_reference_time t
		where t.stat_date>=@beginTime
		and t.stat_date<=concat(@endTime,' 23:59:59')
		group by date_format(t.stat_date,'%Y-%m')
	) t
	left join(
	SELECT 
	   date_format(tr.crt_time,'%Y-%m') stat_time,
		count(distinct w.user_id) all_experts_counts,
		count(distinct tr.USER_ID) all_buy_counts,
		count(tr.RECOM_ID) all_buy_times,
		sum(tr.money) all_buy_money,
	   sum(tr.crt_reward) all_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		group by stat_time
	) t1 on t.stat_date=t1.stat_time
) tt2 on tt1.stat_date=tt2.stat_date
inner join(
	select 
	t.stat_date, 
	t1.media_experts_counts,
	t1.media_buy_counts,
	t1.media_buy_times,
	t1.media_buy_money,
	t1.media_buy_reward
	from (
		select 
		date_format(t.stat_date,'%Y-%m') stat_date
		from t_stat_reference_time t
		where t.stat_date>=@beginTime
		and t.stat_date<=concat(@endTime,' 23:59:59')
		group by date_format(t.stat_date,'%Y-%m')
	) t
	left join(
		SELECT 
		date_format(tr.crt_time,'%Y-%m') stat_time,
		count(distinct w.user_id) media_experts_counts,
		count(distinct tr.USER_ID) media_buy_counts,
		count(tr.RECOM_ID) media_buy_times,
		sum(tr.money) media_buy_money,
		sum(tr.crt_reward) media_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID
		group by stat_time
	) t1 on t.stat_date=t1.stat_time
) tt3 on tt1.stat_date=tt3.stat_date
inner join(
	select 
	t.stat_date, 
	t1.plain_experts_counts,
	t1.plain_buy_counts,
	t1.plain_buy_times,
	t1.plain_buy_money,
	t1.plain_buy_reward
	from (
		select 
		date_format(t.stat_date,'%Y-%m') stat_date
		from t_stat_reference_time t
		where t.stat_date>=@beginTime
		and t.stat_date<=concat(@endTime,' 23:59:59')
		group by date_format(t.stat_date,'%Y-%m')
	) t
	left join(
	SELECT 
		date_format(tr.crt_time,'%Y-%m') stat_time,
		count(distinct w.user_id) plain_experts_counts,
		count(distinct tr.USER_ID) plain_buy_counts,
		count(tr.RECOM_ID) plain_buy_times,
		sum(tr.money) plain_buy_money,
		sum(tr.crt_reward) plain_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD not in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID 
		group by stat_time
	) t1 on t.stat_date=t1.stat_time
) tt4 on tt1.stat_date=tt4.stat_date
inner join(
	select 
	t.stat_date, 
	t1.combat_experts_counts,
	t1.combat_buy_counts,
	t1.combat_buy_times,
	t1.combat_buy_money,
	t1.combat_buy_reward
	from (
		select 
		date_format(t.stat_date,'%Y-%m') stat_date
		from t_stat_reference_time t
		where t.stat_date>=@beginTime
		and t.stat_date<=concat(@endTime,' 23:59:59')
		group by date_format(t.stat_date,'%Y-%m')
	) t
	left join(
	SELECT 
		date_format(tr.crt_time,'%Y-%m') stat_time,
		count(distinct w.user_id) combat_experts_counts,
		count(distinct tr.USER_ID) combat_buy_counts,
		count(tr.RECOM_ID) combat_buy_times,
		sum(tr.money) combat_buy_money,
		sum(tr.crt_reward) combat_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		and ter.IS_COMBAT=1
		and ter.IS_EXPERT=1
		group by stat_time
	) t1 on t.stat_date=t1.stat_time
) tt5 on tt1.stat_date=tt5.stat_date;


-- 总
select * from (
	select 
	t.stat_date, 
	t1.first_experts_counts,
	t2.first_buy_counts,
	t2.first_buy_times,
	t2.first_buy_money,
	t2.first_buy_reward
	from (
		select 
		'合计' stat_date from dual
	) t
	left join (
		select 
		count(distinct u.USER_ID) first_experts_counts
		from forum.t_user u 
		INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		and ta.MOD_TIME>=@beginTime and ta.MOD_TIME<=concat(@endTime,' 23:59:59')
	) t1 on 1=1
	left join(
		SELECT 
		count(distinct tr.USER_ID) first_buy_counts,
		count(tr.RECOM_ID) first_buy_times,
		sum(tr.money) first_buy_money,
		sum(tr.crt_reward) first_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		and ta.MOD_TIME>=@beginTime and ta.MOD_TIME<=concat(@endTime,' 23:59:59')
		and date_format(ta.MOD_TIME,'%Y-%m') = date_format(tr.crt_time,'%Y-%m')
	) t2 on 1=1
) tt1 
inner join(
	select 
	t.stat_date, 
	t1.all_experts_counts,
	t1.all_buy_counts,
	t1.all_buy_times,
	t1.all_buy_money,
	t1.all_buy_reward
	from (
		select 
		'合计' stat_date from dual
	) t
	left join(
	SELECT 
		count(distinct w.user_id) all_experts_counts,
		count(distinct tr.USER_ID) all_buy_counts,
		count(tr.RECOM_ID) all_buy_times,
		sum(tr.money) all_buy_money,
	   sum(tr.crt_reward) all_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
	) t1 on 1=1
) tt2 on 1=1
inner join(
	select 
	t.stat_date, 
	t1.media_experts_counts,
	t1.media_buy_counts,
	t1.media_buy_times,
	t1.media_buy_money,
	t1.media_buy_reward
	from (
		select 
		'合计' stat_date from dual
	) t
	left join(
		SELECT 
		count(distinct w.user_id) media_experts_counts,
		count(distinct tr.USER_ID) media_buy_counts,
		count(tr.RECOM_ID) media_buy_times,
		sum(tr.money) media_buy_money,
		sum(tr.crt_reward) media_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID
	) t1 on 1=1
) tt3 on 1=1
inner join(
	select 
	t.stat_date, 
	t1.plain_experts_counts,
	t1.plain_buy_counts,
	t1.plain_buy_times,
	t1.plain_buy_money,
	t1.plain_buy_reward
	from (
		select 
		'合计' stat_date from dual
	) t
	left join(
	SELECT 
		count(distinct w.user_id) plain_experts_counts,
		count(distinct tr.USER_ID) plain_buy_counts,
		count(tr.RECOM_ID) plain_buy_times,
		sum(tr.money) plain_buy_money,
		sum(tr.crt_reward) plain_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
		inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD not in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID 
	) t1 on 1=1
) tt4 on 1=1
inner join(
	select 
	t.stat_date, 
	t1.combat_experts_counts,
	t1.combat_buy_counts,
	t1.combat_buy_times,
	t1.combat_buy_money,
	t1.combat_buy_reward
	from (
		select 
		'合计' stat_date from dual
	) t
	left join(
	SELECT 
		count(distinct w.user_id) combat_experts_counts,
		count(distinct tr.USER_ID) combat_buy_counts,
		count(tr.RECOM_ID) combat_buy_times,
		sum(tr.money) combat_buy_money,
		sum(tr.crt_reward) combat_buy_reward
		FROM forum.T_MATCH_RECOM w 
		INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
		and tr.crt_time>=@beginTime
		and tr.crt_time<=concat(@endTime,' 23:59:59')
		INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
		and ter.IS_COMBAT=1
		and ter.IS_EXPERT=1
	) t1 on 1=1
) tt5 on 1=1;

