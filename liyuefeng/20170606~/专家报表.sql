
set @param0='2017-06-01 00:00:00';
set @param1='2017-06-06 23:59:59';

-- 分成
-- 新增

-- 新增专

SELECT 
'新增专家',
count(distinct w.user_id) experts,
count(distinct tr.USER_ID) counts,
count(tr.RECOM_ID) times,
sum(tr.money) money
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
and ta.MOD_TIME>=@param0 and ta.MOD_TIME<=@param1;

-- 全部专家
SELECT 
'全部专家',
count(distinct w.user_id) experts,
count(distinct tr.USER_ID) counts,
count(tr.RECOM_ID) times,
sum(tr.money) money,
sum(tr.crt_reward) reward
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0;

-- 媒体专家
SELECT 
'媒体专家',
count(distinct w.user_id) experts,
count(distinct tr.USER_ID) counts,
count(tr.RECOM_ID) times,
sum(tr.money) money,
sum(tr.crt_reward) reward
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID;


-- 草根专家

SELECT 
'草根专家',
count(distinct w.user_id) experts,
count(distinct tr.USER_ID) counts,
count(tr.RECOM_ID) times,
sum(tr.money) money,
sum(tr.crt_reward) reward
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
inner join (select USER_ID from forum.t_expert_type_ref where TYPE_CD not in (7,9,10,11) group by user_id) tf on ta.USER_ID=tf.USER_ID ;



-- 实战专家
SELECT 
'实战专家',
count(distinct w.user_id) experts,
count(distinct tr.USER_ID) counts,
count(tr.RECOM_ID) times,
sum(tr.money) money,
sum(tr.crt_reward) reward
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert ter on ter.USER_ID=w.USER_ID and ter.`STATUS`=10
and ter.IS_COMBAT=1
and ter.IS_EXPERT=1;




