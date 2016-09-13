set @beginTime='2016-08-01 00:00:00';
set @endTime = '2016-08-03 23:59:59';


-- 只针对BYAPP投注渠道

-- 用户充值区间
-- 0-500,501-1000,1001-2000,2001-5000,5001-10000,10001-o

-- *选择无的时候，应该增加家条件 ，去掉and tt.value_type 并且增加 where  U.USER_ID is null
-- *选择全部的时候，应该整个过滤条件去掉

-- 这里的计算投注和返还不再是按结算时间，而是按单来计算，便于统计投注盈利的真实情况
-- 但是由于不确定结算时间，始终得不到精确的值

-- 这部分只针对BYAPP注册且投注的用户

-- GAME(BYAPP),KD(KD),YH(YH) 3个渠道（选所有时就这几个渠道，另外需要计算规则）
 
 -- 合体
 
select 
tt.bet_users,
(tt.new_bet_users-tt.new_recharge_users) new_free_users,
tt.new_recharge_users,
(tt.old_bets_user-tt.old_recharge_users) old_free_users,
tt.old_recharge_users,
tt.bet_orders,
if(tt.bet_users>0,tt.bet_orders/tt.bet_users,0) per_user_orders,
if(tt.bet_orders>0,(tt.bet_coins+tt.bet_free_currency)/tt.bet_orders,0) per_order_coins,
(tt.bet_coins+tt.bet_free_currency) bet_game_currency,
tt.bet_coins,
tt.bet_free_currency,
(tt.return_coins+tt.return_free_currency) return_game_currency,
tt.return_coins,
tt.return_free_currency,
(tt.return_coins+tt.return_free_currency-tt.bet_coins-tt.bet_free_currency) consume_game_currency,
(tt.return_coins-tt.bet_coins) consume_coins,
(tt.return_free_currency-tt.bet_free_currency) consume_free_currency
from (
select
count(distinct if(u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime,u.user_id,null)) new_bet_users ,
count(distinct if(u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime,tfc.charge_user_id,null)) new_recharge_users,
count(distinct if(u.CRT_TIME<=@beginTime,u.user_id,null)) old_bets_user ,
count(distinct if(u.CRT_TIME<=@beginTime,tt.charge_user_id,null)) old_recharge_users ,
count(distinct u.user_id) bet_users,
count(u.user_id) bet_orders,
round(sum(IF(TF.CHANNEL_CODE ='GAME',TF.COIN_BUY_MONEY,0))+ SUM(IF(TF.CHANNEL_CODE IN ('YH','KD'),TF.ITEM_MONEY,0))) bet_coins ,
round(sum(tf.P_COIN_BUY_MONEY)) bet_free_currency ,
round(sum(IF(TF.CHANNEL_CODE ='GAME',TF.COIN_PRIZE_MONEY,0))+SUM(IF(TF.CHANNEL_CODE IN ('YH','KD'),TF.PRIZE_MONEY,0))) return_coins,
round(sum(tf.P_COIN_PRIZE_MONEY)) return_free_currency
from game.t_order_item tf
inner join forum.t_user u on U.user_CODE = tf.user_ID AND TF.CHANNEL_CODE = 'KD'
and TF.ITEM_STATUS not in (-5, -10 , 210)
and tf.CRT_TIME>=@beginTime and tf.CRT_TIME<=@endTime
left join(
SELECT t.charge_user_id,
       t.crt_time,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 4
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 5
     end                             AS value_type,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID  -- and tt.value_type = 5
left join 
(select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id) tfc on tt.charge_user_id = tfc.charge_user_id
and tfc.CRT_TIME>=@beginTime and tfc.CRT_TIME<=@endTime
)tt ;
