
-- 0点和12点切换，替换dawn和noon即可

update t_stat_jrtt_coin_operate_noon t set t.fore_asserts_free_coins=null,t.fore_asserts_normal_coins=null,t.fobidden_counts=null,t.fobidden_free_coins=null,t.fobidden_normal_coins=null;
update t_stat_baiyin_coin_operate_noon t set t.fore_asserts_free_coins=null,t.fore_asserts_normal_coins=null,t.fobidden_counts=null,t.fobidden_free_coins=null,t.fobidden_normal_coins=null;

-- 刷今日头条前总余额数据
set @param0='2017-07-26';


update t_stat_jrtt_coin_operate_noon t1
inner join t_stat_jrtt_coin_operate_noon t2 on t1.stat_date=date_add(t2.stat_date,interval -1 day)
and t2.stat_date=@param0
set t1.fore_asserts_free_coins=t2.fore_asserts_free_coins-t1.all_event_free_consume,
t1.fore_asserts_normal_coins=t2.fore_asserts_normal_coins-t1.all_event_coins_consume;


-- 刷百盈前总余额数据
set @param0='2017-07-25';

update t_stat_baiyin_coin_operate_noon t1
inner join t_stat_coin_operate_noon t2 on t1.stat_date=t2.stat_date
inner join t_stat_jrtt_coin_operate_noon t3 on t1.stat_date=t3.stat_date and t1.stat_date>=@param0 
set t1.fore_asserts_free_coins=t2.fore_asserts_free_coins-t3.fore_asserts_free_coins,
t1.fore_asserts_normal_coins=t2.fore_asserts_normal_coins-t3.fore_asserts_normal_coins,
t1.fobidden_counts=t2.fobidden_counts-t3.fobidden_counts,
t1.fobidden_free_coins=t2.fobidden_free_coins-t3.fobidden_free_coins,
t1.fobidden_normal_coins=t2.fobidden_normal_coins-t3.fobidden_normal_coins;