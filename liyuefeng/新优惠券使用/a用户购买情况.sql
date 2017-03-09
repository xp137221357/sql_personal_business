set param=['2017-01-20 00:00:00','2017-01-26 23:59:59'];

-- set @param0='2017-01-20 00:00:00';
-- set @param1='2017-01-26 23:59:59';

-- 金币 
select 'a用户充值金币人数-充值金币数',
count(distinct tc.charge_user_id) '充值金币人数',
sum(tc.coins) '数值',  
from  report.t_trans_user_recharge_coin tc
inner join(
 		select a.user_id
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM forum.t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select b.user_id
		from forum.t_user_match_recom b
		where b.PAY_STATUS = 10
		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
		group by b.user_id
		) group by a.user_id
 ) t  on t.user_ID=tc.charge_user_id 
 and tc.crt_time>=@param0
 and tc.crt_time<=@param1
 and tc.charge_method='app'				
 
 
 union all
 
 -- 钻石
 select 'a用户充值钻石人数-充值钻石数',
count(distinct td.charge_user_id) '充值钻石人数',
sum(td.diamonds) '充值钻石数'
from report.t_trans_user_recharge_diamond td 
inner join(
 		select a.user_id
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM forum.t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select b.user_id
		from forum.t_user_match_recom b
		where b.PAY_STATUS = 10
		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
		group by b.user_id
		) group by a.user_id
 ) t on t.user_ID=td.charge_user_id
 and td.crt_time>=@param0
 and td.crt_time<=@param1
 and td.charge_method='app'
 				
 union all
 
 -- 推荐

select 'a用户购买推荐人数-购买推荐金额',
count(distinct tm.user_id) '购买推荐人数',
sum(r.SINGLE_MONEY) '购买推荐金额'
from forum.t_user_match_recom tm 
inner join forum.t_match_recom r on tm.RECOM_ID = r.RECOM_ID and r.`STATUS`=10 and r.SINGLE_MONEY>0
inner join(
 		select a.user_id
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM forum.t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select b.user_id
		from forum.t_user_match_recom b
		where b.PAY_STATUS = 10
		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003))
		group by b.user_id
		) group by a.user_id
 ) t on t.USER_ID=tm.USER_ID
where tm.PAY_STATUS=10
and tm.CRT_TIME>=@param0
and tm.CRT_TIME<=@param1

 
 
 
 

