select distinct t.user_id
		from t_acct_items t 
		where
		t.ITEM_EVENT = 'TRADE_COIN'
		and t.ITEM_STATUS=10
		and t.PAY_TIME>='2017-01-06 00:00:00'
		and t.PAY_TIME <ADDDATE('2017-01-06 00:00:00', 14)
		and t.user_id not in
		(
				select distinct b.user_id
				from t_user_match_recom b
				where b.PAY_STATUS = 10
				and b.CRT_TIME>= '2017-01-06 00:00:00'
				and b.CRT_TIME <ADDDATE('2017-01-06 00:00:00', 14)
				and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
		)
		and t.user_id not in (SELECT USER_ID FROM t_big_user_coupon_bak)
		and t.USER_ID not in (
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
	
	