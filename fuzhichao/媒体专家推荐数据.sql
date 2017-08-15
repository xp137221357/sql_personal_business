set @param0='2016-12-01 00:00:00';
set @param1='2016-12-06 23:59:59';

select 
concat(@param0,'~',@param1) '时间',
t1.TYPE_NAME '类型',
t1.value1 '推荐人数',
t1.value2 '推荐人数',
t1.value3 '推荐场次',
t2.value1 '推荐收费次数',
t2.value2 '推荐收费场次',
t3.value1 '购买人数',
t3.value2 '购买次数',
t3.value3 '购买金额',
t4.value1 '人均购买金额',
t4.value2 '网站收入',
t4.value3 '稿费支出'

from (
	SELECT '名家-推荐人数-推荐次数-推荐场次',
	 te.TYPE_NAME,te.TYPE_CD,
	 COUNT(DISTINCT(w.USER_ID)) value1,
	 count(w.RECOM_ID) value2,
	 count(distinct w.Match_ID) value3
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID 
	inner join forum.t_expert_type te on tf.TYPE_CD=te.TYPE_CD
	INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	and w.crt_time>=@param0
	and w.crt_time<=@param1
	and w.status =10
	group by te.TYPE_CD
) t1 
left join (
	SELECT te.TYPE_CD,
	 count( if(w.single_money>0,w.RECOM_ID,null)) value1 ,
	 count(distinct if(w.single_money>0,w.Match_ID,null)) value2
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID 
	inner join forum.t_expert_type te on tf.TYPE_CD=te.TYPE_CD
	INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	and w.crt_time>=@param0
	and w.crt_time<=@param1
	and w.status =10
	group by te.TYPE_CD
) t2 on t1.TYPE_CD=t2.TYPE_CD
left join (
	SELECT '名家-购买人数-购买次数-购买金额',
	 te.TYPE_CD,
	 COUNT(DISTINCT(tr.USER_ID)) value1,
	 count(tr.RECOM_ID) value2,
	 sum(tr.MONEY) value3
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
	and tr.crt_time>=@param0
	and tr.crt_time<=@param1
	INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID 
	inner join forum.t_expert_type te on tf.TYPE_CD=te.TYPE_CD
	INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	group by te.TYPE_CD
)t3 on t1.TYPE_CD=t3.TYPE_CD
left join (
	SELECT '名家-人均购买金额-网站收入-稿费支出',
	te.TYPE_CD,
		 round(if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0)) value1,
		 round(sum(tr.MONEY) - sum(tr.CRT_REWARD)) value2,
		 round(sum(tr.CRT_REWARD)) value3
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0
	and tr.crt_time>=@param0
	and tr.crt_time<=@param1
	INNER JOIN forum.t_expert_type_ref tf on w.user_id = tf.USER_ID 
	inner join forum.t_expert_type te on tf.TYPE_CD=te.TYPE_CD
	INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	group by te.TYPE_CD
)t4 on t1.TYPE_CD=t4.TYPE_CD;