set @beginTime='2016-08-27';
set @endTime = '2016-08-28 23:59:59';
set @num = '2';

SELECT
tt.value,
tt.stat_time,
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
floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) value,
case floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
when 0 then concat(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval datediff(@endTime,@beginTime) day))
when 1 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1) day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*2-1 day))
when 2 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*2 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*3-1 day))
when 3 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*3 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*4-1 day))
when 4 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*4 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*5-1 day))
when 5 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*5 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*6-1 day))
when 6 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*6 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*7-1 day))
when 7 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*7 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*8-1 day))
when 8 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*8 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*9-1 day))
when 9 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*9 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*10-1 day))
when 10 then concat(date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*10 day),'~',
date_add(date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day),interval (datediff(@endTime,@beginTime)+1)*11-1 day))
end as stat_time,

count(distinct if(floor(datediff(u.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
=floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)),u.user_id,null)) new_bet_users ,
count(distinct if(floor(datediff(u.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
=floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)),tfc.charge_user_id,null)) new_recharge_users,
count(distinct if(floor(datediff(u.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
<floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) ,u.user_id,null)) old_bets_user ,
count(distinct if(floor(datediff(u.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
<floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) ,tt.charge_user_id,null)) old_recharge_users ,
count(distinct u.user_id) bet_users,
count(u.user_id) bet_orders,
round(sum(IF(TF.CHANNEL_CODE ='GAME',TF.COIN_BUY_MONEY,0))+ SUM(IF(TF.CHANNEL_CODE IN ('YH','KD'),TF.ITEM_MONEY,0))) bet_coins ,
round(sum(tf.P_COIN_BUY_MONEY)) bet_free_currency ,
round(sum(IF(TF.CHANNEL_CODE ='GAME' ,TF.COIN_PRIZE_MONEY,0))+SUM(IF(TF.CHANNEL_CODE IN ('YH','KD'),TF.PRIZE_MONEY,0))) return_coins,
round(sum(tf.P_COIN_PRIZE_MONEY)) return_free_currency
from game.t_order_item tf
inner join forum.t_user u on U.user_CODE = tf.user_ID  AND TF.CHANNEL_CODE = 'GAME'
and TF.ITEM_STATUS not in (-5, -10 , 210)
and tf.CRT_TIME>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
and tf.CRT_TIME<=@endTime
left join( 
SELECT t.charge_user_id,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 1000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 1000
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 4
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 5
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 6
     end                             AS value_type,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID  -- and tt.value_type = 5
left join 
(select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id) tfc on U.USER_ID = tfc.charge_user_id
and floor(datediff(tfc.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) =
floor(datediff(tf.CRT_TIME,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))
-- where tt.charge_user_id is not null
 group by stat_time 
)tt ;





