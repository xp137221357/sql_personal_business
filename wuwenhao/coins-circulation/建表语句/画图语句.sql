set @beginTime='2016-08-15';
set @endTime = '2016-08-17';
set @num = '3';

select 
t.stat_time,
(t.coin_recharge+t.coin_present) coins_raise,
(t.free_present) free_raise,
(t.coin_exchange_consume+t.coin_basketball_consume+t.coin_football_consume+t.coin_draw_consume+t.coin_redeem_consume+t.coin_broadcast_consume) free_raise,
(t.free_exchange_consume+t.free_basketball_consume+t.free_football_consume+t.free_draw_consume+t.free_redeem_consume+t.free_broadcast_consume) free_consume,
t.coin_recharge,
t.coin_present,
t.free_present,
(select t1.fore_asserts_free_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,1,10)) free_begin_balance,
(select t1.fore_asserts_normal_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,1,10)) coin_begin_balance,
(select t1.fore_asserts_free_coins
from t_stat_coin_operate t1 where t1.stat_date = date_add(substring(t.stat_time,12,10),interval 1 day)) free_end_balance,
(select t1.fore_asserts_normal_coins
from t_stat_coin_operate t1 where t1.stat_date = date_add(substring(t.stat_time,12,10),interval 1 day)) coin_end_balance

from (
SELECT stat_date,
floor(datediff(stat_date,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) value,
case  floor(datediff(stat_date,date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1))

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

ifnull(sum(ts.recharge_coins),0) coin_recharge,
ifnull(sum(ts.reward_coins),0) coin_present,
ifnull(sum(ts.reward_free_coins),0) free_present,
ifnull(sum(ts.prize_coins_abnormal),0) coin_distribute_abnormal,
ifnull(sum(ts.exchange_coins_consume),0) coin_exchange_consume,
ifnull(sum(ts.basketball_coins_consume),0) coin_basketball_consume,
ifnull(sum(ts.football_coins_consume),0) coin_football_consume,
ifnull(sum(ts.draw_coins_consume),0) coin_draw_consume,
ifnull(sum(ts.redeem_coins_consume),0) coin_redeem_consume,
ifnull(sum(ts.broadcast_coins_consume),0) coin_broadcast_consume,
ifnull(sum(ts.exchange_free_consume),0) free_exchange_consume,
ifnull(sum(ts.basketball_free_consume),0) free_basketball_consume,
ifnull(sum(ts.football_free_consume),0) free_football_consume,
ifnull(sum(ts.draw_free_consume),0) free_draw_consume,
ifnull(sum(ts.redeem_free_consume),0) free_redeem_consume,
ifnull(sum(ts.broadcast_free_consume),0) free_broadcast_consume

FROM t_stat_coin_operate ts
WHERE ts.stat_date>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
and ts.stat_date<=concat(@endTime,' 23:59:59')
group by stat_time ) t