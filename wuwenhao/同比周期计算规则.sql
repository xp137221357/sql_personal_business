set @beginTime='2016-08-15';
set @endTime = '2016-08-17';
set @num = '3';


-- set @stat_date = '2016-07-11';
-- select date_format(@stat_date,'%Y-%m-%d');
-- select date_add(@stat_date,interval 1 day);
-- select datediff(@endTime,@stat_date); 
-- select datediff(@endTime,@stat_date)*@num; -- 周期时间起始点
-- select date_add(@stat_date,interval -datediff(@endTime,@stat_date)*@num day);
-- select floor(datediff(@endTime,date_add(@stat_date,interval -datediff(@endTime,@stat_date)*@num day))/5)
-- select concat(concat(date_add(@stat_date,interval @num+1 day),'~'),date_add(@stat_date,interval @num*2 day))

select 
t.*,
tt.recharge_counts,
tt.new_recharge_counts,
(select t1.fore_asserts_free_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,1,10)) free_begin_balance,
(select t1.fore_asserts_normal_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,1,10)) coin_begin_balance,
(select t1.fore_asserts_free_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,12,10)) free_end_balance,
(select t1.fore_asserts_normal_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,12,10)) coin_end_balance,
(select t1.fobidden_free_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,12,10)) free_forbidden,
(select t1.fobidden_normal_coins
from t_stat_coin_operate t1 where t1.stat_date = substring(t.stat_time,12,10)) coin_forbidden

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
ifnull(sum(ts.broadcast_free_consume),0) free_broadcast_consume,
ifnull(sum(ts.t_new_recharge_coins),0) new_recharge_coins,
ifnull(sum(ts.t_recharge_coins),0) recharge_coins
FROM t_stat_coin_operate ts
WHERE ts.stat_date>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
and ts.stat_date<=concat(@endTime,' 23:59:59')
group by stat_time ) t
left join (
select 
floor(datediff(date(tc.crt_time),date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day))/(datediff(@endTime,@beginTime)+1)) value,
count(DISTINCT tc.charge_user_id) recharge_counts,
count(DISTINCT tfc.charge_user_id) new_recharge_counts
from t_trans_user_recharge_coin tc 
left join (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
and tfc.crt_time>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
and tfc.crt_time<=concat(@endTime,' 23:59:59')
where tc.crt_time>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day)
and tc.crt_time<=concat(@endTime,' 23:59:59')
group by value
) tt on t.value = tt.value


