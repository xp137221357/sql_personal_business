-- 表2,3,4专家分组

-- t_expert_type_ref  
-- t_expert_type
-- 名家-7

set @beginTime='2016-09-05';
set @endTime = '2016-09-11 23:59:59';


-- 名家
-- 发起推荐人数，推荐次数，推荐收费场次
SELECT '名家',
 COUNT(DISTINCT(w.USER_ID)) '发起推荐人数',
 count(w.RECOM_ID) '推荐次数',
 count( if(w.single_money>0,w.RECOM_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@beginTime
and w.crt_time<=@endTime
and w.status =10
-- group by statTime,w.recom_type
;



-- 购买人数 	购买次数 	购买金额 	人均购买金额 	网站收入 	稿费支出
SELECT '名家',
 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
 count(tr.RECOM_ID) '购买次数',
 sum(tr.MONEY) '购买金额',
 if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0) '人均购买金额',
 sum(tr.MONEY) - sum(tr.CRT_REWARD) '网站收入',
 sum(tr.CRT_REWARD) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@beginTime
and tr.crt_time<=@endTime
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
-- group by statTime,w.recom_type
;


-- 非名家----------------------------------------------------------------------
-- 发起推荐人数，推荐次数，推荐收费场次
SELECT '非名家',
 COUNT(DISTINCT(w.USER_ID)) '发起推荐人数',
 count(w.RECOM_ID) '推荐次数',
 count(if(w.single_money>0,w.RECOM_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)
and w.crt_time>=@beginTime
and w.crt_time<=@endTime
and w.status =10
-- group by statTime,w.recom_type
;

-- 购买人数 	购买次数 	购买金额 	人均购买金额 	网站收入 	稿费支出
SELECT '非名家',
 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
 count(tr.RECOM_ID) '购买次数',
 sum(tr.MONEY) '购买金额',
 if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0) '人均购买金额',
 sum(tr.MONEY) - sum(tr.CRT_REWARD) '网站收入',
 sum(tr.CRT_REWARD) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@beginTime
and tr.crt_time<=@endTime
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)
-- group by statTime,w.recom_type
;


-- 所有总计------------------------------------------------------------------------------

SELECT '合计',
 COUNT(DISTINCT(w.USER_ID)) '发起推荐人数',
 count(w.RECOM_ID) '推荐次数',
 count(if(w.single_money>0,w.RECOM_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@beginTime
and w.crt_time<=@endTime
and w.status =10
-- group by statTime,w.recom_type
;

SELECT '合计',
 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
 count(tr.RECOM_ID) '购买次数',
 sum(tr.MONEY) '购买金额',
 if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0) '人均购买金额',
 sum(tr.MONEY) - sum(tr.CRT_REWARD) '网站收入',
 sum(tr.CRT_REWARD) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 
and tr.crt_time>=@beginTime
and tr.crt_time<=@endTime
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP';



