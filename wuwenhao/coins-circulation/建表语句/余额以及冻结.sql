


INSERT into t_stat_coin_operate(stat_date,fore_asserts_normal_coins,fore_asserts_free_coins,fobidden_counts,fobidden_normal_coins,fobidden_free_coins)
select 
date_add(curdate(),interval -1 day) stat_date,
t.fore_asserts_normal_coin fore_asserts_normal_coins,
t.fore_asserts_free_coin fore_asserts_free_coins,
t.fobidden_counts fobidden_counts,
t.fobidden_normal_coins fobidden_normal_coins,
t.fobidden_free_coins fobidden_free_coins
from t_stat_coin_trends t 
where t.user_group='all' 
and t.stat_date = date_add(curdate(),interval -1 day)
on duplicate key update 
fore_asserts_normal_coins = values(fore_asserts_normal_coins),
fore_asserts_free_coins = values(fore_asserts_free_coins),
fobidden_counts = values(fobidden_counts),
fobidden_normal_coins = values(fobidden_normal_coins),
fobidden_free_coins = values(fobidden_free_coins)