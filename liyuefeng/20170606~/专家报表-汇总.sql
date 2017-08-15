set @beginTime='2017-06-01';
set @endTime='2017-06-06';

-- 分成
-- 新增
-- 新增专
-- 新增专家
-- 时间,-,专家数目,购买人数,购买次数,购买金额,专家分成
-- stat_date,consume,first_experts_counts,first_buy_counts,first_buy_times,first_buy_money,first_buy_reward
select 
t.stat_date, 
'-' consume, 
t1.first_experts_counts,
t1.first_buy_counts,
t1.first_buy_times,
t1.first_buy_money,
t1.first_buy_reward
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join(
	SELECT 
	date(tr.crt_time) stat_time,
	count(distinct w.user_id) first_experts_counts,
	count(distinct tr.USER_ID) first_buy_counts,
	count(tr.RECOM_ID) first_buy_times,
	sum(tr.money) first_buy_money,
	sum(tr.crt_reward) first_buy_reward
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
	and tr.crt_time>=@beginTime
	and tr.crt_time<=concat(@endTime,' 23:59:59')
	INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
	INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
	and ta.MOD_TIME>=@beginTime and ta.MOD_TIME<=concat(@endTime,' 23:59:59')
	group by stat_time
) t1 on t.stat_date=t1.stat_time;


-- 全部专家

-- 全部专家
-- 时间,-,专家数目,购买人数,购买次数,购买金额,专家分成
-- stat_date,consume,all_experts_counts,all_buy_counts,all_buy_times,all_buy_money,all_buy_reward


select 
t.stat_date, 
'-' consume, 
t1.all_experts_counts,
t1.all_buy_counts,
t1.all_buy_times,
t1.all_buy_money,
t1.all_buy_reward
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join(
SELECT 
   date(tr.crt_time) stat_time,
	count(distinct w.user_id) all_experts_counts,
	count(distinct tr.USER_ID) all_buy_counts,
	count(tr.RECOM_ID) all_buy_times,
	sum(tr.money) all_buy_money
   sum(tr.crt_reward) all_buy_reward
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
	and tr.crt_time>=@beginTime
	and tr.crt_time<=concat(@endTime,' 23:59:59')
	INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
	INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
	group by stat_time
) t1 on t.stat_date=t1.stat_time;

-- 媒体专家

-- 媒体专家
-- 时间,-,专家数目,购买人数,购买次数,购买金额,专家分成
-- stat_date,consume,media_experts_counts,media_buy_counts,media_buy_times,media_buy_money,media_buy_reward

select 
t.stat_date, 
'-' consume, 
t1.media_experts_counts,
t1.media_buy_counts,
t1.media_buy_times,
t1.media_buy_money,
t1.media_buy_reward
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join(
	SELECT 
	date(tr.crt_time) stat_time,
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
) t1 on t.stat_date=t1.stat_time;

-- 草根专家

-- 草根专家
-- 时间,-,专家数目,购买人数,购买次数,购买金额,专家分成
-- stat_date,consume,plain_experts_counts,plain_buy_counts,plain_buy_times,plain_buy_money,plain_buy_reward
select 
t.stat_date, 
'-' consume, 
t1.plain_experts_counts,
t1.plain_buy_counts,
t1.plain_buy_times,
t1.plain_buy_money,
t1.plain_buy_reward
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join(
SELECT 
	date(tr.crt_time) stat_time,
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
) t1 on t.stat_date=t1.stat_time;

-- 实战专家

-- 实战专家
-- 时间,-,专家数目,购买人数,购买次数,购买金额,专家分成
-- stat_date,consume,combat_experts_counts,combat_buy_counts,combat_buy_times,combat_buy_money,combat_buy_reward
select 
t.stat_date, 
'-' consume, 
t1.combat_experts_counts,
t1.combat_buy_counts,
t1.combat_buy_times,
t1.combat_buy_money,
t1.combat_buy_reward
from (
	select 
	date_format(t.stat_date,'%Y-%m-%d') stat_date
	from t_stat_reference_time t
	where t.stat_date>=@beginTime
	and t.stat_date<=concat(@endTime,' 23:59:59')
) t
left join(
SELECT 
	date(tr.crt_time) stat_time,
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
) t1 on t.stat_date=t1.stat_time;