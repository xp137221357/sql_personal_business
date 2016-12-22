set @beginTime='2016-10-01 00:00:00';
set @endTime = '2016-10-31 23:59:59';


-- 充值金额
select '充值金额',concat(@beginTime,'~',@endTime) '时间',
count(DISTINCT t1.user_id) '充值人数',
sum(t1.rmb_value) '充值金额'
from(

select tc.charge_user_id user_id,tc.rmb_value rmb_value from t_trans_user_recharge_coin tc 
where tc.crt_time>=@beginTime and tc.crt_time<=@endTime

union all

select td.charge_user_id user_id,td.rmb_value rmb_value
from t_trans_user_recharge_diamond td 
where td.crt_time>=@beginTime and td.crt_time<=@endTime
)t1 
inner join report.t_trans_user_attr tu on tu.USER_ID=t1.user_id 
inner join 
(
select user_id from h5game.t_roulette_act where create_time>=@beginTime
and create_time<=@endTime
group by user_id
)t2 on tu.user_code = t2.user_id

union all


-- 投注金币
select '投注金币',concat(@beginTime,'~',@endTime) '时间',
count(DISTINCT oi.user_id) '投注人数',
round(sum(oi.COIN_BUY_MONEY)) '投注金额'
from game.t_order_item oi
inner join 
(
select user_id from h5game.t_roulette_act where create_time>=@beginTime
and create_time<=@endTime
group by user_id
)t2 on oi.USER_ID=t2.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime

union all


-- 购买推进人数以及金额

select 
'购买推荐',concat(@beginTime,'~',@endTime) '时间',
count(distinct ai.user_id)'购买推荐人数',sum(ai.CHANGE_VALUE) '购买金额' 
from forum.t_acct_items ai 
inner join report.t_trans_user_attr tu on tu.USER_ID=ai.user_id 
inner join 
(
select user_id from h5game.t_roulette_act where create_time>=@beginTime
and create_time<=@endTime
group by user_id
)t2 on tu.USER_CODE=t2.user_id
where ai.ADD_TIME>= @beginTime and ai.ADD_TIME<=@endTime
and ai.ITEM_EVENT in ('BUY_SERVICE','BUY_RECOM')
and ai.ITEM_STATUS=10;

