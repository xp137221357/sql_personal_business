set param=['2017-02-20','2017-02-26','2017-03-05 23:59:59'];
-- 1.目标用户时间点，2.行为起始时间，3.行为结束时间

-- set @param0='2017-01-20 00:00:00';
-- set @param1='2017-01-26 23:59:59';
-- set @param2='2017-01-26 23:59:59';

select 
 count(distinct oi.USER_ID) '投注人数',
 round(sum(oi.COIN_BUY_MONEY)) '投注金币',
 round(sum(oi.P_COIN_BUY_MONEY)) '投注体验币'
 from game.t_order_item oi
 inner join(
 		select t.user_id,t.ACCT_ID
		from forum.t_acct_items t 
		left join(
			   select b.user_id
				from forum.t_user_match_recom b
				where b.PAY_STATUS = 10
				and b.CRT_TIME>= ADDDATE(@param0, -14)
				and b.CRT_TIME <@param0
				and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
				group by b.user_id
				) t1 on t.USER_ID=t1.user_id 
		left join(
			   SELECT USER_ID FROM forum.t_big_user_coupon_bak group by user_id
				) t2 on t.USER_ID=t2.user_id 
		left join(
			   select a.user_id
				from forum.t_user_match_recom a
				left join forum.t_big_user_coupon_bak b on a.USER_ID=b.user_id
				left join (
					select b.user_id
					from forum.t_user_match_recom b
					where b.PAY_STATUS = 10
					and b.CRT_TIME>= ADDDATE(@param0, -7)
					and b.CRT_TIME < @param0
					and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
					group by b.user_id
				) c on a.USER_ID=c.user_id
				where a.PAY_STATUS = 10
				and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
				and a.CRT_TIME>= ADDDATE(@param0, -21)
				and a.CRT_TIME < ADDDATE(@param0, -7)
				and b.USER_ID is null 
				and c.user_id is null
				group by a.user_id
				) t3 on t.USER_ID=t3.user_id
		where
		t.ITEM_EVENT = 'TRADE_COIN'
		and t.ITEM_STATUS=10
		and t.PAY_TIME>=ADDDATE(@param0, -14)
		and t.PAY_TIME <@param0
		and t1.user_id is null
		and t2.user_id is null
		and t3.user_id is null
		group by t.user_id
 ) t on t.ACCT_ID=oi.USER_ID
 where oi.CHANNEL_CODE in ('GAME') 
 and oi.ITEM_STATUS not in (-5, -10 ,210)
 and oi.PAY_TIME>=@param1
 and oi.PAY_TIME<=@param2
