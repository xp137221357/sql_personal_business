
select sum(r.SINGLE_MONEY) from t_user_match_recom t inner join t_match_recom r on t.RECOM_ID = r.RECOM_ID and r.`STATUS`=10 and r.SINGLE_MONEY>0
where t.PAY_STATUS=10
and t.CRT_TIME>'2017-01-20 00:00:00'
and t.CRT_TIME<'2017-01-26 23:59:59'
and t.USER_ID in
(
select distinct a.user_id
		from t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= '2016-12-30 00:00:00'
		and a.CRT_TIME < ADDDATE('2016-12-30 00:00:00', 14)
		and a.user_id not in (SELECT USER_ID FROM t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select distinct b.user_id
		from t_user_match_recom b
		where b.PAY_STATUS = 10

		and b.CRT_TIME>= ADDDATE('2016-12-30 00:00:00', 14)
		and b.CRT_TIME < ADDDATE('2016-12-30 00:00:00', 21)
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
		)
)