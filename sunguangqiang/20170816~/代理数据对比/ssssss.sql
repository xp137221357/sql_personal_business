

select u.NICK_NAME '昵称',
u.ACCT_NUM '会员号',
o.COIN_BUY_MONEY '投注金币',
ifnull(o.COIN_PRIZE_MONEY,0)+ifnull(o.COIN_RETURN_MONEY) '返奖金币',
o.ITEM_STATUS '状态',
o.PAY_TIME '投注时间',
o.BALANCE_TIME '结算时间',
t.CRT_TIME '加入该代理时间',
t.ADD_TIME '成为代理时间',
t3.agent '代理' 
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
inner join game.t_group_ref t on o.USER_ID=t.USER_ID
inner join game.t_group_ref t2 on t.ROOT_ID=t2.REF_ID
inner join report.t_partner_group t3 on t3.user_id=t2.USER_ID and t3.agent_acct_num in (
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
and o.item_status in (0,10,-5,-10,200,210)
and o.PAY_TIME>=t.ADD_TIME
and o.BALANCE_TIME>='2017-07-24 12:00:00'
and o.BALANCE_TIME< '2017-07-31 12:00:00';


