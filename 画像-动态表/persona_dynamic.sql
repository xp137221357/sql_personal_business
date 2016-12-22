-- 按月的数据分布 充值以及投注



set @param0='2016-01-01 00:00:00';
set @param1='2016-02-01 00:00:00';
-- 充值金币
select 
tu.user_id user_id,
tu.user_code use_code,
tu.SYSTEM_MODEL terminal_type,
tu.CHANNEL_NO channel_no,
count(1) recharge_count,
sum(tc.coins) recharge_value,
sum(tc.rmb_value) recharge_money,
max(tc.coins) recharge_max,
min(tc.coins) recharge_min, 
avg(tc.coins) recharge_avg 
from report.t_trans_user_recharge_coin tc
inner join report.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID
where tc.crt_time>=@param0 and tc.crt_time<@param1
group by tc.charge_user_id;
-- 充值钻石
select 
tu.user_id user_id,
tu.user_code use_code,
tu.SYSTEM_MODEL terminal_type,
tu.CHANNEL_NO channel_no,
count(1) recharge_count,
sum(td.diamonds) recharge_value,
sum(td.rmb_value) recharge_money,
max(td.diamonds) recharge_max,
min(td.diamonds) recharge_min, 
avg(td.diamonds) recharge_avg 
from report.t_trans_user_recharge_diamond td
inner join report.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID
where td.crt_time>=@param0 and td.crt_time<@param1
group by td.charge_user_id;


-- 购买服务，购买推荐

select ai.USER_ID,sum(ai.CHANGE_VALUE) diamonds from forum.t_acct_items ai 
 where ai.ADD_TIME >= @param0 
 and ai.ADD_TIME <= @param1 and ai.ITEM_STATUS=10 
 and ai.ACCT_TYPE='1003'
 and ai.ITEM_EVENT in ('BUY_RECOM','BUY_SERVICE','BUY_VIP')
 group by ai.USER_ID;


-- 投注

select 
tu.user_id user_id,
tu.user_code use_code,
tu.SYSTEM_MODEL terminal_type,
tu.CHANNEL_NO channel_no,
count(1) bet_total_count,
sum(oi.ITEM_MONEY) bet_total,
sum(oi.PRIZE_MONEY) return_total,
max(oi.ITEM_MONEY) bet_total_max,
min(oi.ITEM_MONEY) bet_total_max,
avg(oi.ITEM_MONEY) bet_total_max,
if(sum(oi.ITEM_MONEY)>0,sum(oi.PRIZE_MONEY)/sum(oi.ITEM_MONEY),0) rate_total

count(if(COIN_BUY_MONEY>0,1,null)) bet_coin_count,
sum(oi.COIN_BUY_MONEY) bet_coin,
sum(oi.COIN_PRIZE_MONEY) return_coin,
max(oi.COIN_BUY_MONEY) bet_coin_max,
min(oi.COIN_BUY_MONEY) bet_coin_min,
avg(oi.COIN_BUY_MONEY) bet_coin_avg,
if(sum(oi.COIN_BUY_MONEY)>0,sum(oi.COIN_PRIZE_MONEY)/sum(oi.COIN_BUY_MONEY),0) rate_coin

count(if(P_COIN_BUY_MONEY>0,1,null)) bet_coin_count,
sum(oi.P_COIN_BUY_MONEY) bet_free,
sum(oi.P_COIN_PRIZE_MONEY) return_free,
max(oi.P_COIN_BUY_MONEY) bet_free_max,
min(oi.P_COIN_BUY_MONEY) bet_free_min,
avg(oi.P_COIN_BUY_MONEY) bet_free_avg,
if(sum(oi.P_COIN_BUY_MONEY)>0,sum(oi.P_COIN_PRIZE_MONEY)/sum(oi.P_COIN_BUY_MONEY),0) rate_coin
from game.t_order_item oi
inner join report.t_trans_user_attr tu on oi.USER_ID = tu.USER_CODE
where oi.ITEM_STATUS not in (-5, -10, 210)
and oi.channel_code='game' 
and oi.CRT_TIME>=@param0 
and oi.CRT_TIME<@param1
group by oi.USER_ID;

-- 发帖

-- 发帖量，跟帖量，回帖量，被阅读量

select 
tu.user_id user_id,
tu.user_code use_code,
tu.SYSTEM_MODEL terminal_type,
tu.CHANNEL_NO channel_no,
sum(LOOK_UP_COUNT) read_count,
count(if(t.NOTE_TYPE=10,1,null)) post_count,
count(if(t.NOTE_TYPE=20,1,null)) response_count
from forum.t_circles_note t 
inner join report.t_trans_user_attr tu on t.USER_ID = tu.USER_ID
where 
t.CRT_TIME>=@param0 and t.CRT_TIME<@param1
group by t.user_id;


-- 登录行为

-- 很重要



