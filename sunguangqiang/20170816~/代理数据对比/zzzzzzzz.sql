-- 数据

select 
t.agent,
t.agent_acct_num,
sum(t.ITEM_MONEY) ITEM_ALL_MONEY,
sum(t.COIN_BUY_MONEY) ITEM_MONEY,
sum(t.PRIZE_MONEY) PRIZE_ALL_MONEY,
sum(t.COIN_PRIZE_MONEY) PRIZE_MONEY,
sum(t.ITEM_MONEY - t.PRIZE_MONEY) PROFIT_ALL_COIN,
sum(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) PROFIT_COIN,
sum(case when t.pass_type = '1001' and t.MATCH_ODDS >= 1.5 then ABS(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) else 0 end ) EFFECTIVE_MONEY
from (
select 
	o.item_id,
	tf.agent,
	tf.agent_acct_num,
	o.PASS_TYPE,
	o.ITEM_STATUS,
	o.ITEM_MONEY,
	o.COIN_BUY_MONEY,
	IFNULL(o.PRIZE_MONEY,0) + ifnull(o.RETURN_MONEY,0) PRIZE_MONEY,
	IFNULL(o.COIN_PRIZE_MONEY,0) + IFNULL(o.COIN_RETURN_MONEY,0) COIN_PRIZE_MONEY,
	o.BALANCE_TIME,
	o.PAY_TIME,
	c.MATCH_ODDS
from game.t_order_item o
inner join (
select tf.user_id,tf.CRT_TIME CRT_TIME,t3.agent,t3.agent_acct_num from
game.t_group_ref tf 
inner join game.t_group_ref tf2 on tf.ROOT_ID=tf2.REF_ID 
inner join report.t_partner_group t3 on t3.user_id=tf2.USER_ID and t3.agent_acct_num in (
'999999',
'13165038',
'12920883',
'11413124',
'13197600',
'13225530',
'12030632',
'13491843',
'11412833',
'11039270',
'11424347',
'12164501',
'13164990',
'11010143',
'11439065',
'19462881',
'15096129',
'19880439',
'20069730',
'13201482',
'13342017',
'11402447',
'11176565',
'13531746',
'12796487',
'11176682',
'11388287',
'20112552',
'20414784',
'21755766',
'11057396',
'22050222',
'21899652',
'22366095',
'22499361',
'22447215'
)

union all 

select t3.user_id,t3.crt_time,t3.agent,t3.agent_acct_num from report.t_partner_group t3 where t3.agent_acct_num in (
'999999',
'13165038',
'12920883',
'11413124',
'13197600',
'13225530',
'12030632',
'13491843',
'11412833',
'11039270',
'11424347',
'12164501',
'13164990',
'11010143',
'11439065',
'19462881',
'15096129',
'19880439',
'20069730',
'13201482',
'13342017',
'11402447',
'11176565',
'13531746',
'12796487',
'11176682',
'11388287',
'20112552',
'20414784',
'21755766',
'11057396',
'22050222',
'21899652',
'22366095',
'22499361',
'22447215'
)

)tf on o.USER_ID=tf.USER_ID 
left join game.t_item_content c on c.ITEM_ID = o.item_id
where o.crt_time >= tf.CRT_TIME
-- and o.item_status not in (0,10,-5,-10,200,210)
and o.BALANCE_TIME>='2017-07-31 12:00:00'
and o.BALANCE_TIME< '2017-08-07 12:00:00'
group by o.item_id
)t 
group by t.agent_acct_num asc;