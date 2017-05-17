set @param0='2017-01-20';
set @param1='2017-02-12';


-- 充值赠送钻石
select date_format(ai.PAY_TIME,'%Y-%m') stat_time,count(distinct user_id) '充值人数',sum(ai.CHANGE_VALUE) '赠送钻石数' from forum.t_acct_items ai 
where ai.ITEM_EVENT='DIAMEND_PRESENT'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS in (10,-10)
group by stat_time;


-- 金币总充值人数
select 
date_format(t.crt_time,'%Y-%m') stat_time,
count(distinct t.charge_user_id)'金币总充值人数',
sum(t.rmb_value) '金币总充值金额RMB'
from report.t_trans_user_recharge_coin t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID='BYAPP'
where t.crt_time>=@param0
and t.crt_time<@param1
group by stat_time;

-- 钻石总充值人数
select 
date_format(t.crt_time,'%Y-%m') stat_time,
count(distinct t.charge_user_id)'钻石充值人数',
count(t.charge_user_id)'钻石充值次数',
sum(t.rmb_value) '钻石充值RMB'
from report.t_trans_user_recharge_diamond t 
inner join forum.t_user u on t.charge_user_id=u.USER_ID and u.CLIENT_ID='BYAPP'
where t.crt_time>=@param0
and t.crt_time<@param1
group by stat_time;

-- 投注金币

select 
date_format(oi.PAY_TIME,'%Y-%m') stat_time,
date(oi.CRT_TIME) stat_time,
count(oi.USER_ID)'投注人数',
round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins
from game.t_order_item oi
inner join forum.t_user u on oi.USER_ID=u.USER_CODE and u.CLIENT_ID='BYAPP'
where  
oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
and oi.COIN_BUY_MONEY>0
and oi.PAY_TIME >= @param0 
and oi.PAY_TIME < @param1
group by stat_time;




