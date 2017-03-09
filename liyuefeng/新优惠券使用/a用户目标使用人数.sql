set param=['2017-02-20','2017-02-26','2017-03-05 23:59:59'];
-- 1.目标用户时间点，2.行为起始时间，3.行为结束时间

-- set @param0='2017-01-20 00:00:00';
-- set @param1='2017-01-26 23:59:59';
-- set @param2='2017-01-26 23:59:59';

select * from (
select count(distinct a.user_id) 'a目标用户人数'
		from t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select distinct b.user_id
		from t_user_match_recom b
		where b.PAY_STATUS = 10

		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003)))
		) t1
left join (
select count(distinct t.user_id)'a使用人数' from t_user_match_recom t inner join t_match_recom r on t.RECOM_ID = r.RECOM_ID and r.`STATUS`=10 and r.SINGLE_MONEY>0
where t.PAY_STATUS=10
and t.CRT_TIME>=@param1
and t.CRT_TIME<=@param2
and t.PAY_TYPE = 104
and t.USER_ID in
(
select distinct a.user_id
		from t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select distinct b.user_id
		from t_user_match_recom b
		where b.PAY_STATUS = 10

		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003)))
)
)t2 on 1=1
;
