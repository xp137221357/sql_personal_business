-- set param=['2017-02-20','2017-02-26','2017-03-05 23:59:59'];
-- 1.目标用户时间点，2.行为起始时间，3.行为结束时间

set @param0='2017-01-20 00:00:00';
set @param1='2017-01-26';
set @param2='2017-02-01 23:59:59';

-- 金币 

select * from (
select count(distinct a.user_id) 'a标用户数'
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM forum.t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select distinct b.user_id
		from forum.t_user_match_recom b
		where b.PAY_STATUS = 10

		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003)))
) t 
left join (
select count(distinct t.user_id)'使用人数' 
from forum.t_user_match_recom t inner join forum.t_match_recom r on t.RECOM_ID = r.RECOM_ID and r.`STATUS`=10 and r.SINGLE_MONEY>0
where t.PAY_STATUS=10
and t.CRT_TIME>=@param1
and t.CRT_TIME<=@param2
and t.PAY_TYPE = 104
and t.USER_ID in
(
select distinct a.user_id
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and ((a.MONEY>0 and a.PAY_TYPE=1003) or (a.MONEY=0 and a.PAY_TYPE !=1003))
		and a.CRT_TIME>= ADDDATE(@param0, -21)
		and a.CRT_TIME < ADDDATE(@param0, -7)
		and a.user_id not in (SELECT USER_ID FROM forum.t_big_user_coupon_bak)
		and a.USER_ID not in
		(
		select distinct b.user_id
		from forum.t_user_match_recom b
		where b.PAY_STATUS = 10

		and b.CRT_TIME>= ADDDATE(@param0, -7)
		and b.CRT_TIME < @param0
		and ((b.MONEY>0 and b.PAY_TYPE=1003) or (b.MONEY=0 and b.PAY_TYPE !=1003)))
)
)t1 on 1=1
left join (
select 
count(distinct tc.charge_user_id) '充值金币人数',
sum(tc.coins) '充值金币数'
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
 and tc.crt_time>=@param1
 and tc.crt_time<=@param2
 and tc.charge_method='app'				
) t2 on 1=1
left join (
 
 -- 钻石
 select 
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
 and td.crt_time>=@param1
 and td.crt_time<=@param2
 and td.charge_method='app'
 ) t3 on 1=1
 				
 left join (
 
 -- 推荐

select 
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
and tm.CRT_TIME>=@param1
and tm.CRT_TIME<=@param2
) t4 on 1=1

left join (

select 
 count(distinct oi.USER_ID) '投注人数',
 round(sum(oi.COIN_BUY_MONEY)) '投注金币',
 round(sum(oi.P_COIN_BUY_MONEY)) '投注体验币'
 from game.t_order_item oi
 inner join(
 		select u.USER_CODE
		from forum.t_user_match_recom a
		inner join forum.t_user u on a.user_id = u.user_id
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
		) group by u.USER_CODE
 ) t on t.USER_CODE=oi.USER_ID
 where oi.CHANNEL_CODE in ('GAME') 
 and oi.PAY_TIME>=@param1
 and oi.PAY_TIME<=@param2
 ) t5 on 1=1
 
 
 
 

