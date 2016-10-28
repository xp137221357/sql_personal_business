set @beginTime0='2016-10-03';
set @endTime0 = '2016-10-09 23:59:59';

set @beginTime1='2016-10-13';
set @endTime1 = '2016-10-16 23:59:59';

/*
select c.money,user_id from (
select user_id,
		case 
			when money > 1000 then 100
			when money >700 and money<=1000 then 50
			when money >500 and money<=700 then 30
			when money >300 and money<=500 then 20
			when money <=300  then 10
		end as money
from (
select a.user_id,sum(a.MONEY) money 
		from forum.t_user_match_recom a
		where a.PAY_STATUS = 10
		and a.MONEY>0
		and a.CRT_TIME>= @beginTime0
		and a.CRT_TIME <= @endTime0
		group by user_id
		order by money desc
		) b 
)c where c.money=100;
*/


select tt.money,concat(@beginTime1,'~',@endTime1) '时间',
count(distinct oi.USER_ID) `投注人数`, sum(oi.COIN_BUY_MONEY) `投注金币`,sum(oi.P_COIN_BUY_MONEY) `投注体验币`
from game.t_order_item oi
inner join report.t_trans_user_attr tu on tu.USER_CODE=oi.USER_ID and oi.CHANNEL_CODE = 'GAME' 
           and oi.ITEM_STATUS not in (-5, -10, 210) 
			  and oi.CRT_TIME >= @beginTime1 and oi.CRT_TIME < @endTime1
inner join (
	select c.money,user_id from (
	select user_id,
			case 
				when money > 1000 then 100
				when money >700 and money<=1000 then 50
				when money >500 and money<=700 then 30
				when money >300 and money<=500 then 20
				when money <=300  then 10
			end as money
	from (
	select a.user_id,sum(a.MONEY) money 
			from forum.t_user_match_recom a
			where a.PAY_STATUS = 10
			and a.MONEY>0
			and a.CRT_TIME>= @beginTime0
			and a.CRT_TIME <= @endTime0
			group by user_id
			order by money desc
			) b 
	)c where c.money IN (10,20,30,50,100)

)tt on tt.user_id=tu.USER_ID
GROUP BY tt.money
