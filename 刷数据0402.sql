CREATE TABLE `t_bk_item_id_acct_0410` (
	`index_id` VARCHAR(50) NOT NULL DEFAULT '',
	`item_id` VARCHAR(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`index_id`)
);

CREATE TABLE `t_bk_item_id_order_0410` (
	`item_id` VARCHAR(50) NOT NULL DEFAULT '',
	`order_id` VARCHAR(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`item_id`)
);


CREATE TABLE `t_bk_order_id_acct_0410` (
	`index_id` VARCHAR(50) NOT NULL DEFAULT '',
	`order_id` VARCHAR(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`index_id`)
);

CREATE TABLE `t_bk_order_id_order_0410` (
	`index_id` VARCHAR(50) NOT NULL DEFAULT '',
	`order_id` VARCHAR(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`index_id`)
);


set @beginTime='2017-04-02 00:00:00';
set @endTime = '2017-04-02 23:59:59';
--  PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER'

insert into t_order_id_acct_0410 
SELECT ai.ITEM_ID,ai.TRADE_NO from forum.t_acct_items ai 
where ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
and ai.ITEM_EVENT in ('trade_coin','PK_TRADE_COIN_USER');

SELECT * from forum.t_acct_items ai 
where ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
and ai.ITEM_EVENT in ('trade_coin');


SELECT ai.ACCT_TYPE,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
where ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
and ai.ITEM_EVENT in ('trade_coin','PK_TRADE_COIN_USER')
group by ai.ACCT_TYPE;

SELECT * from forum.t_acct_items ai 
where ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
AND ai.ITEM_STATUS in (10,-10)
and ai.ITEM_EVENT in ('prize_coin','PK_PRIZE_COIN_USER')
and ai.ACCT_TYPE=1001
group by ai.ACCT_TYPE;


insert into t_item_id_acct_0410 
SELECT ai.ITEM_ID,ai.TRADE_NO from forum.t_acct_items ai 
where ai.PAY_TIME>=@beginTime
and ai.PAY_TIME<=@endTime
and ai.ITEM_EVENT in ('prize_coin','PK_PRIZE_COIN_USER');


insert into t_order_id_order_0410 
select o.ITEM_ID,o.ORDER_ID from game.t_order_item o 
where o.PAY_TIME>=@beginTime
and o.PAY_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai');

select sum(o.COIN_BUY_MONEY) from game.t_order_item o 
where o.PAY_TIME>=@beginTime
and o.PAY_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai');

select IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0) from game.t_order_item o 
where o.BALANCE_TIME>=@beginTime
and o.BALANCE_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai');

select * from game.t_order_item o 
where o.BALANCE_TIME>=@beginTime
and o.BALANCE_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and (o.COIN_PRIZE_MONEY>0 or o.COIN_RETURN_MONEY>0);

insert into t_item_id_order_0410 
select o.ITEM_ID,o.ORDER_ID from game.t_order_item o 
where o.BALANCE_TIME>=@beginTime
and o.BALANCE_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai');


select count(1) from t_item_id_acct_0410
union all
select count(1) from t_order_id_acct_0410
union all
select count(1) from t_item_id_order_0410
union all
select count(1) from t_order_id_order_0410;

update t_item_id_acct_0410 t set t.item_id = replace(t.item_id,'REF-','');

-- 足球
-- 缺少投注订单数
select * from (
select * from t_order_id_order_0410 t 
group by t.order_id
) t1
left join (
select * from t_order_id_acct_0410 t 
group by t.order_id
) t2 on t1.order_id=t2.order_id
where t2.order_id is null
group by t1.order_id;

-- 足球
-- 缺少返奖订单数
select * from (
select * from t_item_id_order_0410 t 
group by t.item_id
) t1
left join (
select * from t_item_id_acct_0410 t 
group by t.item_id
) t2 on t1.item_id=t2.item_id
where t2.item_id is null
group by t1.item_id;

select sum(o.COIN_BUY_MONEY),sum(o.P_COIN_BUY_MONEY) from game.t_order_item o 
where 
o.ORDER_ID
in (
	select t1.order_id from (
	select * from t_order_id_order_0410 t 
	group by t.order_id
	) t1
	left join (
	select * from t_order_id_acct_0410 t 
	group by t.order_id
	) t2 on t1.order_id=t2.order_id
	where t2.order_id is null
	group by t1.order_id
);

select IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0),IFNULL(sum(o.P_COIN_PRIZE_MONEY),0)+IFNULL(sum(o.P_COIN_RETURN_MONEY),0) 
from game.t_order_item o 
where 
 o.ITEM_ID
in (
	select t1.item_id from (
	select * from t_item_id_order_0410 t 
	group by t.item_id
	) t1
	left join (
	select * from t_item_id_acct_0410 t 
	group by t.item_id
	) t2 on t1.item_id=t2.item_id
	where t2.item_id is null
	group by t1.item_id
);




SELECT * from game.t_order_item o WHERE o.ITEM_ID='0006c21b6bcb4f6b9249b4dcfd9fbce2';
select * from  forum.t_acct_items ai where ai.TRADE_NO like '%0006c21b6bcb4f6b9249b4dcfd9fbce2%'
-- 投注
-- 20411660 金币
-- 135176 体验币


-- 返奖
-- 1181957 金币
-- 314191 体验币

select 
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)))
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
-- and ai.ITEM_STATUS in (10,-10)
and ai.ITEM_EVENT in ('TRADE_COIN','PRIZE_COIN','PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY')
and v.USER_ID is null
;



select  -11615831+32321532


select o.ITEM_ID,o.ORDER_ID from game.t_order_item o 
where o.PAY_TIME>=@beginTime
and o.PAY_TIME<=@endTime
and o.CHANNEL_CODE in ('game','jrtt-jingcai');







