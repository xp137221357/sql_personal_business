
-- 汇总

select 
ifnull(sum(t.recharge_coins),0) '金币充值',
ifnull(sum(t.reward_coins),0) '金币赠送',
ifnull(sum(t.bet_coins),0) '竞猜投注',
ifnull(sum(t.prize_coins),0) '竞猜返奖',
ifnull(sum(t.casino_bet_coins),0) '娱乐场投注',
ifnull(sum(t.casino_prize_coins),0) '娱乐场返奖',
ifnull(sum(t.mall_in_coins),0) '商城收入',
ifnull(sum(t.mall_out_coins),0) '商城支出',
ifnull(sum(t.abnormal_coins),0) '派奖异常',
ifnull(sum(t.system_in_coins),0) '系统偏差(悬赏)',
ifnull(sum(t.system_out_coins),0) '系统偏差(答题)'
from t_acct_items_detail t 
inner join forum.t_user u on t.user_id=u.USER_ID
where t.stat_date='2017-09-12';


-- 明细
select 
u.USER_ID '用户ID',
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
ifnull(t.recharge_coins,0) '金币充值',
ifnull(t.reward_coins,0) '金币赠送',
ifnull(t.bet_coins,0) '竞猜投注',
ifnull(t.prize_coins,0) '竞猜返奖',
ifnull(t.casino_bet_coins,0) '娱乐场投注',
ifnull(t.casino_prize_coins,0) '娱乐场返奖',
ifnull(t.mall_in_coins,0) '商城收入',
ifnull(t.mall_out_coins,0) '商城支出',
ifnull(t.abnormal_coins,0) '派奖异常',
ifnull(t.system_in_coins,0) '系统偏差(悬赏)',
ifnull(t.system_out_coins,0) '系统偏差(答题)'
from t_acct_items_detail t 
inner join forum.t_user u on t.user_id=u.USER_ID
where t.stat_date='2017-09-12';




SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0912 t
union all
SELECT COUNT(1),SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0913 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0914 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0915 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0916 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0917 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0918 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0919 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0920 t
union all
SELECT COUNT(1), SUM(t.money_after)-SUM(t.money_before)
FROM t_stat_user_daily_balance_0921 t;