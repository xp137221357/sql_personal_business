set @param0='2016-11-07 00:00:00';
set @param1 = '2016-11-13 23:59:59';


select 
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员账号',
t1.match_count '投注场次',
t1.orders '投注订单',
t1.bet_coins '投注金币',
t2.return_coins '返还金币',
t3.app_coins '官方充值',
t3.third_coins '第三方充值'
 from (
select * from (
select oi.USER_ID,
count(distinct oi.BALANCE_MATCH_ID) match_count,-- '投注场次',
count(oi.ORDER_ID) orders,-- '投注订单',
sum(oi.COIN_BUY_MONEY) bet_coins-- '投注金币',

from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
group by oi.USER_ID ) t
order by t.bet_coins desc limit 20
) t1
inner join forum.t_user u on u.USER_CODE=t1.USER_ID
left join (
select oi.USER_ID,sum(oi.COIN_PRIZE_MONEY) return_coins from  game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.BALANCE_TIME >= @param0 and oi.BALANCE_TIME <= @param1
group by oi.USER_ID
) t2 on U.USER_CODE=t2.USER_ID
left join (
select tc.charge_user_id user_id,
sum(if(tc.charge_method = 'app',tc.coins,0)) app_coins,
sum(if(tc.charge_method != 'app',tc.coins,0)) third_coins 
from report.t_trans_user_recharge_coin tc 
where tc.crt_time>=@param0 and tc.crt_time<=@param1
group by  tc.charge_user_id
) t3 on U.USER_ID=t3.USER_ID

