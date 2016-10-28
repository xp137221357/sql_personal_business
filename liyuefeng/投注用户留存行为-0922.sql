-- 8.29日~9.18日之间有过投注行为，在9.19日~9.21日之间不再投注的用户，
-- 共有多少？这些人之中，有多少有过充值行为？
set @beginTime0='2016-08-29 00:00:00';
set @endTime0 = '2016-09-18 23:59:59';
set @beginTime1='2016-09-19 00:00:00';
set @endTime1 = '2016-09-21 23:59:59';

SELECT count(distinct t1.user_id) '不再投注人数'
from (
	select o.USER_ID from game.t_order_item o
	where        o.ITEM_STATUS not in (-5, -10, 210)
	and        o.channel_code = 'GAME'
	AND        o.crt_time >= @beginTime0
	AND        o.crt_time <= @endTime0
	group by o.user_id
)t1
left join (
	select o.USER_ID from game.t_order_item o
	where        o.ITEM_STATUS not in (-5, -10, 210)
	and        o.channel_code = 'GAME'
	AND        o.crt_time >= @beginTime1
	AND        o.crt_time <= @endTime1
	group by o.user_id
) t2 on t1.user_id=t2.user_id where t2.user_id is null

-- 5335

-- 充值人数
SELECT count(t.user_id) '不再投注,但充值人数'
from (
		SELECT t1.user_id
		from (
			select o.USER_ID from game.t_order_item o
			where        o.ITEM_STATUS not in (-5, -10, 210)
			and        o.channel_code = 'GAME'
			AND        o.crt_time >= @beginTime0
			AND        o.crt_time <= @endTime0
			group by o.user_id
		)t1
		left join (
			select o.USER_ID from game.t_order_item o
			where        o.ITEM_STATUS not in (-5, -10, 210)
			and        o.channel_code = 'GAME'
			AND        o.crt_time >= @beginTime1
			AND        o.crt_time <= @endTime1
			group by o.user_id
		) t2 on t1.user_id=t2.user_id where t2.user_id is null
)t
inner join report.t_trans_user_attr tu on tu.USER_CODE = t.user_id 
inner join (
select * from (
 select tc.charge_user_id from report.t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime1 and tc.crt_time<=@endTime1 
 union all
 select td.charge_user_id from report.t_trans_user_recharge_diamond td where td.crt_time>=@beginTime1 and td.crt_time<=@endTime1 
 )t group by charge_user_id
) tt on tu.user_id = tt.charge_user_id


-- 28

