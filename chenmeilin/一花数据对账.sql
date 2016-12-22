
set @beginTime='2016-01-15 00:00:00';
set @endTime = '2016-01-15 23:59:59';
select t1.ITEM_MONEY-t2.PRIZE_MONEY 
from (
select 
sum(oi.ITEM_MONEY) ITEM_MONEY
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
)t1

left join (
select 
sum(oi.PRIZE_MONEY) PRIZE_MONEY
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
)t2 on 1=1

;

select * from (
select date_format(oi.Crt_time,'%Y-%m-%d') stat_time from game.t_order_item oi 
where oi.Crt_time >= @beginTime and oi.Crt_time < @endTime
group by stat_time
)t
left join(
select date_format(oi.PAY_TIME,'%Y-%m-%d') stat_time,
count(oi.USER_ID) '投注单数',
count(distinct oi.USER_ID)'投注人数',
sum(oi.ITEM_MONEY) '投注金额'
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
group by stat_time
) t1 on t.stat_time = t1.stat_time
left join (
select date_format(oi.PAY_TIME,'%Y-%m-%d') stat_time,
count(oi.USER_ID) '返奖单数',
count(distinct oi.USER_ID)'返奖人数',
sum(oi.PRIZE_MONEY) '返奖金额'
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.PRIZE_MONEY>0
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
group by stat_time
) t2 on t.stat_time=t2.stat_time


select oi.PAY_TIME '投注时间',
concat(oi.USER_ID,'-') '用户ID',
oi.ORDER_ID '订单号',
oi.ITEM_MONEY '投注金额'
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.crt_time >= @beginTime and oi.crt_time < @endTime;



select oi.BALANCE_TIME '结算时间',
concat(oi.USER_ID,'-') '用户ID',
oi.PRIZE_MONEY '返奖金额'
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'YH' 
and oi.PRIZE_MONEY>0
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime;


-- 订单差异
set @beginTime='2016-01-15 00:00:00';
set @endTime = '2016-01-15 23:59:59';

select 
t1.id,
t1.crt_time '一花时间',
t1.order_id '一花订单号',
t1.item_money '一花投注金额',
oi.PAY_TIME '投注时间',
concat(oi.USER_ID,'-') '用户ID',
oi.ORDER_ID '下注单号',
oi1.ITEM_ID '返奖单号',
oi.ITEM_MONEY '投注金额'
from report.t_yh_bet_2016_01_15 t1
left join game.t_order_item oi on (t1.ORDER_ID like concat('%',oi.ORDER_ID,'%') or t1.ORDER_ID like concat('%',oi.ITEM_ID,'%'))
and  oi.CHANNEL_CODE = 'YH' 
-- and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime
left join game.t_order_item oi1  on (t1.ORDER_ID like concat('%',oi1.ORDER_ID,'%') or t1.ORDER_ID like concat('%',oi1.ITEM_ID,'%'))
and oi1.CHANNEL_CODE = 'YH' 
-- and oi1.ITEM_STATUS not in (-5, -10, 210) 
and oi1.BALANCE_TIME >= @beginTime and oi1.BALANCE_TIME <= @endTime
where oi.ORDER_ID is null and oi1.ORDER_ID is null
order by t1.crt_time asc;
