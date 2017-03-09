select 
count(distinct oi.USER_ID)
 from game.t_order_item oi
 where oi.CHANNEL_CODE in ('GAME') 
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.PAY_TIME >= '2017-01-20 00:00:00' 
 and oi.PAY_TIME < '2017-01-27 00:00:00'
 
  and oi.user_id in
  (
	select distinct u.user_code
		from t_user_match_recom a inner join t_user u on a.user_id = u.user_id
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