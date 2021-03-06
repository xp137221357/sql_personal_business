-- 表2,3,4专家分组

set @param0='2016-12-01';
set @param1 = '2016-12-06 23:59:59';

SELECT '名家-推荐人数-推荐次数-推荐场次',
 COUNT(DISTINCT(w.USER_ID)) value1,
 count(w.RECOM_ID) value2,
 count(distinct w.Match_ID) value3
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all

SELECT '名家-推荐收费次数-推荐收费场次',
 null,
 count( if(w.single_money>0,w.RECOM_ID,null)) '推荐收费次数',
 count(distinct if(w.single_money>0,w.Match_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all


SELECT '名家-购买人数-购买次数-购买金额',
 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
 count(tr.RECOM_ID) '购买次数',
 sum(tr.MONEY) '购买金额'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'


union all 


SELECT '名家-人均购买金额-网站收入-稿费支出',
	 round(if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0)) '人均购买金额',
	 round(sum(tr.MONEY) - sum(tr.CRT_REWARD)) '网站收入',
	 round(sum(tr.CRT_REWARD)) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID and tf.TYPE_CD = 7
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'

union all


SELECT '非名家-推荐人数-推荐次数-推荐场次',
	 COUNT(DISTINCT(w.USER_ID)) '发起推荐人数',
	 count(w.RECOM_ID) '推荐次数',
	 count(distinct w.Match_ID) '推荐场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all


SELECT '非名家-推荐收费次数-推荐收费场次',
	  null,
	 count( if(w.single_money>0,w.RECOM_ID,null)) '推荐收费次数',
	 count(distinct if(w.single_money>0,w.Match_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all


SELECT '非名家-购买人数-购买次数-购买金额',
	 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
	 count(tr.RECOM_ID) '购买次数',
	 sum(tr.MONEY) '购买金额'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)

union all 

SELECT '非名家-人均购买金额-网站收入-稿费支出',
	 round(if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0)) '人均购买金额',
	 round(sum(tr.MONEY) - sum(tr.CRT_REWARD)) '网站收入',
	 round(sum(tr.CRT_REWARD)) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and u.USER_ID not in (select tf.user_id from forum.t_expert_type_ref tf  where tf.TYPE_CD = 7)

union all


SELECT '合计-推荐人数-推荐次数-推荐场次',
	 COUNT(DISTINCT(w.USER_ID)) '发起推荐人数',
	 count(w.RECOM_ID) '推荐次数',
	 count(distinct w.Match_ID) '推荐场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all


SELECT '合计-推荐收费次数-推荐收费场次',
 null,
 count( if(w.single_money>0,w.RECOM_ID,null)) '推荐收费次数',
 count(distinct if(w.single_money>0,w.Match_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10


union all

SELECT '合计-购买人数-购买次数-购买金额',
	 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
    count(tr.RECOM_ID) '购买次数',
    sum(tr.MONEY) '购买金额'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'

union all


SELECT '合计-人均购买金额-网站收入-稿费支出',
	 round(if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0)) '人均购买金额',
	 round(sum(tr.MONEY) - sum(tr.CRT_REWARD)) '网站收入',
	 round(sum(tr.CRT_REWARD)) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP';




