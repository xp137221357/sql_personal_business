
set param=['2017-02-10','2017-02-16 23:59:59'];

-- set @param0='2017-02-10';
-- set @param1='2017-02-16 23:59:59';

select tt.stat_region '投注区间',tt.stat_time '投注时间',tt.num '投注人数' from (
select '100~500' stat_region,t.stat_time,count(1) num,1 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=100
and t.money<500
group by t.stat_time

union all

select '500~1000' stat_region,t.stat_time,count(1) num,2 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=500
and t.money<1000
group by t.stat_time


union all

select '1000~5000' stat_region,t.stat_time,count(1) num,3 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=1000
and t.money<5000
group by t.stat_time


union all


select '5000~10000' stat_region,t.stat_time,count(1) num,4 stat_type  from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=5000
and t.money<10000
group by t.stat_time


union all

select '10000~20000' stat_region,t.stat_time,count(1) num,5 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=10000
and t.money<20000
group by t.stat_time

union all

select '20000~50000' stat_region,t.stat_time,count(1) num,6 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=20000
and t.money<50000
group by t.stat_time


union all

select '50000~100000' stat_region,t.stat_time,count(1) num,7 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=50000
and t.money<100000
group by t.stat_time

union all

select '>=100000' stat_region,t.stat_time,count(1) num,8 stat_type from ( 
select date_format(o.PAY_TIME,'%Y-%m-%d') stat_time,sum(o.ITEM_MONEY) money from  game.t_order_item o 
where o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE='game'
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
group by stat_time,o.USER_ID
) t where t.money>=100000
group by t.stat_time

) tt order by tt.stat_time asc,tt.stat_type asc;