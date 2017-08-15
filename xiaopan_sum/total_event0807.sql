BEGIN

-- forum.t_acct_items所有事件
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_TYPE,ifnull(sum(ai.CHANGE_VALUE),0)+ifnull(tt.CHANGE_VALUE,0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(ai.PAY_TIME)),max(ai.PAY_TIME) 
from forum.t_acct_items ai
left join t_stat_user_items_total_data tt on ai.USER_ID=tt.USER_ID and ai.ITEM_EVENT=tt.ITEM_EVENT and ai.ACCT_TYPE=tt.ACCT_TYPE 
where ai.PAY_TIME>=date_add(curdate(),interval -1 day)
and ai.PAY_TIME<curdate()
and ai.PAY_TIME>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
group by ai.USER_ID,ai.ITEM_EVENT,ai.ACCT_TYPE
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);


-- 钻石充值
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select td.charge_user_id,'buy_diamond_stat','1003',ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(td.diamonds),0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(td.crt_time)),max(td.crt_time)  
from report.t_trans_user_recharge_diamond td
left join t_stat_user_items_total_data tt on td.charge_user_id=tt.USER_ID and tt.ITEM_EVENT='buy_diamond_stat' and tt.ACCT_TYPE='1003'
where td.crt_time>=date_add(curdate(),interval -1 day)
and td.crt_time<curdate()
and td.crt_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
group by td.charge_user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 钻石提现
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select t.USER_ID,'withdraw_diamond_stat',t.ACCT_TYPE,ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(t.MONEY),0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(t.CRT_TIME)),max(t.CRT_TIME)  
from forum.t_acct_withdraw t 
left join t_stat_user_items_total_data tt on tt.user_id=t.USER_ID and tt.ITEM_EVENT='withdraw_diamond_stat' and tt.ACCT_TYPE=t.ACCT_TYPE
where t.crt_time>=date_add(curdate(),interval -1 day)
and t.crt_time<curdate()
and t.crt_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and t.`STATUS`=10
group by t.USER_ID,t.ACCT_TYPE
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 金币官充
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select tc.charge_user_id,'app_buy_coin_stat','1001',ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(tc.coins),0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(tc.CRT_TIME)),max(tc.CRT_TIME) 
from report.t_trans_user_recharge_coin tc
left join t_stat_user_items_total_data tt on tt.user_id=tc.charge_user_id and tt.ITEM_EVENT='app_buy_coin_stat' and tt.ACCT_TYPE='1001'
where tc.crt_time>=date_add(curdate(),interval -1 day)
and tc.crt_time<curdate()
and tc.crt_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and tc.charge_method='app'
group by tc.charge_user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 金币第三方充
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select tc.charge_user_id,'third_buy_coin_stat','1001',ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(tc.coins),0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(tc.CRT_TIME)),max(tc.CRT_TIME)  
from report.t_trans_user_recharge_coin tc
left join t_stat_user_items_total_data tt on tt.user_id=tc.charge_user_id and tt.ITEM_EVENT='third_buy_coin_stat' and tt.ACCT_TYPE='1001'
where tc.crt_time>=date_add(curdate(),interval -1 day)
and tc.crt_time<curdate()
and tc.crt_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and tc.charge_method!='app'
group by tc.charge_user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

 -- 金币提现
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,COUNTS,BEGIN_TIME,END_TIME)
select t.USER_ID,'withdraw_coin_stat','1001',ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(t.coins),0),ifnull(tt.counts,0)+count(1),ifnull(tt.BEGIN_TIME,min(t.CRT_TIME)),max(t.CRT_TIME)  
from report.t_trans_user_withdraw t
left join t_stat_user_items_total_data tt on tt.user_id=t.USER_ID and tt.ITEM_EVENT='withdraw_coin_stat' and tt.ACCT_TYPE='1001'
where t.crt_time>=date_add(curdate(),interval -1 day)
and t.crt_time<curdate()
and t.crt_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
group by t.USER_ID
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);



-- 足球金币投注
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'ft_bet_coins',
'1001',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.COIN_BUY_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='ft_bet_coins' and tt.ACCT_TYPE='1001'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
and o.COIN_BUY_MONEY>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);


-- 足球体验币投注
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'ft_bet_coins',
'1015',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.P_COIN_BUY_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='ft_bet_coins' and tt.ACCT_TYPE='1015'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
and o.P_COIN_BUY_MONEY>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 足球金币返奖
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'ft_prize_coins',
'1001',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='ft_prize_coins' and tt.ACCT_TYPE='1001'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
and ifnull(o.COIN_PRIZE_MONEY,0)+ifnull(o.COIN_RETURN_MONEY,0)>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 足球=体验币返奖
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'ft_prize_coins',
'1015',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.P_COIN_PRIZE_MONEY),0)+ifnull(sum(o.P_COIN_RETURN_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='ft_prize_coins' and tt.ACCT_TYPE='1015'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
and ifnull(o.P_COIN_PRIZE_MONEY,0)+ifnull(o.P_COIN_RETURN_MONEY,0)>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);



-- 篮球金币投注
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'bk_bet_coins',
'1001',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.COIN_BUY_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='bk_bet_coins' and tt.ACCT_TYPE='1001'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
and o.COIN_BUY_MONEY>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);


-- 篮球体验币投注
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'bk_bet_coins',
'1015',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.P_COIN_BUY_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='bk_bet_coins' and tt.ACCT_TYPE='1015'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
and o.P_COIN_BUY_MONEY>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 篮球金币返奖
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'bk_prize_coins',
'1001',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='bk_prize_coins' and tt.ACCT_TYPE='1001'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
and ifnull(o.COIN_PRIZE_MONEY,0)+ifnull(o.COIN_RETURN_MONEY,0)>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);

-- 篮球=体验币返奖
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,counts,begin_time,end_time)
select 
u.USER_ID,
'bk_prize_coins',
'1015',
ifnull(sum(tt.CHANGE_VALUE),0)+ifnull(sum(o.P_COIN_PRIZE_MONEY),0)+ifnull(sum(o.P_COIN_RETURN_MONEY),0),
ifnull(tt.counts,0)+count(1),
ifnull(tt.BEGIN_TIME,min(o.pay_time)),
max(o.pay_time)  
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
left join t_stat_user_items_total_data tt on u.USER_ID=tt.USER_ID and tt.ITEM_EVENT='bk_prize_coins' and tt.ACCT_TYPE='1015'
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='BB'
and ifnull(o.P_COIN_PRIZE_MONEY,0)+ifnull(o.P_COIN_RETURN_MONEY,0)>0
and o.pay_time>=date_add(curdate(),interval -1 day)
and o.pay_time<curdate()
and o.pay_time>ifnull(tt.END_TIME, date_add(curdate(),interval -2 day))
and u.user_id is not null
group by o.user_id
on duplicate key update 
CHANGE_VALUE = values(CHANGE_VALUE),
begin_time = values(begin_time),
end_time = values(end_time);


END