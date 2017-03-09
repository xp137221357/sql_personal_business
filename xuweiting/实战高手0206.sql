set param=['2017-01-01 00:00:00','2017-02-06 23:59:59'];
-- set @param0='2017-01-30 00:00:00';
-- set @param1='2017-02-05 23:59:59';


-- -------------------------------实战高手

SELECT '实战高手-推荐人数-推荐次数-推荐场次',
 COUNT(DISTINCT(w.USER_ID)) value1,
 count(w.RECOM_ID) value2,
 count(distinct w.Match_ID) value3
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP' and w.`status`=10 and w.RECOM_SRC=0
INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.IS_COMBAT=1 and ter.`STATUS`=10
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all

SELECT '实战高手-推荐收费次数-推荐收费场次',
 null,
 count( if(w.single_money>0,w.RECOM_ID,null)) '推荐收费次数',
 count(distinct if(w.single_money>0,w.Match_ID,null)) '推荐收费场次'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP' and w.`status`=10 and w.RECOM_SRC=0
INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.IS_COMBAT=1 and ter.`STATUS`=10
and w.crt_time>=@param0
and w.crt_time<=@param1
and w.status =10

union all

-- and tr.MONEY>0(过滤优惠券)
SELECT '实战高手-购买人数-购买次数-购买金额',
 COUNT(DISTINCT(tr.USER_ID)) '购买人数',
 count(tr.RECOM_ID) '购买次数',
 sum(tr.MONEY) '购买金额'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and tr.PAY_STATUS=10 and w.`status`=10 and w.RECOM_SRC=0 
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.IS_COMBAT=1 and ter.`STATUS`=10 


union all 


SELECT '实战高手-人均购买金额-网站收入-稿费支出',
	 round(if(count(tr.RECOM_ID)>0,sum(tr.MONEY)/count(tr.RECOM_ID),0)) '人均购买金额',
	 round(sum(tr.MONEY) - sum(tr.CRT_REWARD)) '网站收入',
	 round(sum(tr.CRT_REWARD)) '稿费支出'
FROM forum.T_MATCH_RECOM w 
INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and tr.PAY_STATUS=10 and w.`status`=10 and w.RECOM_SRC=0
and tr.crt_time>=@param0
and tr.crt_time<=@param1
INNER JOIN forum.t_user u on w.USER_ID = u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.IS_COMBAT=1 and ter.`STATUS`=10



