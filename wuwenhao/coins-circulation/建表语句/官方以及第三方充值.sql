INSERT into t_stat_coin_operate(stat_date,t_new_recharge_coins,t_recharge_coins)
select 
date_add(curdate(),interval -1 day) stat_date,
sum(ifnull(coins,0)) new_recharge_coins,
t.recharge_coins
from t_trans_user_recharge_coin tc 
inner join (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
and tfc.crt_time>=date_add(curdate(),interval -1 day) and tfc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
and tc.crt_time>=date_add(curdate(),interval -1 day) and tc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
left join 
(
select 
date_add(curdate(),interval -1 day) stat_date,
sum(ifnull(coins,0)) recharge_coins
from t_trans_user_recharge_coin tc 
where tc.crt_time>=date_add(curdate(),interval -1 day) and tc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
) t on t.stat_date = stat_date
on duplicate key update 
t_new_recharge_coins = values(t_new_recharge_coins),
t_recharge_coins = values(t_recharge_coins)
;