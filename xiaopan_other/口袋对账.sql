set @beginTime='2016-07-18 00:00:00';
set @endTime = '2016-07-18 23:59:59';
/*
CREATE TABLE `koudai_20160702` (
	`time_stamp` INT(11) NULL DEFAULT NULL,
	`user_id` INT(11) NULL DEFAULT NULL,
	`stat_type` INT(2) NULL DEFAULT NULL,
	`coins` INT(19) NULL DEFAULT NULL,
	`crt_time` DATETIME NULL DEFAULT NULL,
	INDEX `user_id` (`user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- update koudai_20160702 t set t.crt_time=FROM_UNIXTIME(t.time_stamp,'%Y-%m-%d %H:%i:%S');
*/

-- select 1362297536.2380-1345792591;

select t.stat_type,sum(coins) from test.koudai_20160718 t 
where t.CRT_TIME>=@beginTime 
and t.CRT_TIME<=@endTime
group by t.stat_type;


select sum(ifnull(o.ITEM_MONEY,0)) from game.t_order_item o 
where o.PAY_TIME>=@beginTime 
and o.PAY_TIME<=@endTime
and o.CHANNEL_CODE='KD'  
;

select sum(if(o.ITEM_STATUS in (-5,-10,210),o.RETURN_MONEY,o.PRIZE_MONEY)) from game.t_order_item o 
where o.BALANCE_TIME>=@beginTime 
and o.BALANCE_TIME<=@endTime
and o.CHANNEL_CODE='KD'  
and o.BALANCE_STATUS=20
;



-- --------------------------------------------------------------------------------------------------

set @beginTime='2016-07-02 00:00:00';
set @endTime = '2016-07-02 23:59:59';


select t1.*,t2.coins from (
	select u.OUT_USER_ID user_id,round(sum(if(o.ITEM_STATUS in (-5,-10,210),o.RETURN_MONEY,o.PRIZE_MONEY))) coins
	from game.t_order_item o 
	inner join game.t_user u on o.USER_ID=u.USER_ID and u.CHANNEL_CODE='KD'
	where o.BALANCE_TIME>=@beginTime 
	and o.BALANCE_TIME<=@endTime
	and o.CHANNEL_CODE='KD' 
	and o.BALANCE_STATUS=20
	group by u.OUT_USER_ID 
) t1
left join (
	select t.user_id,t.stat_type,sum(coins) coins from test.koudai_20160702 t 
	where t.CRT_TIME>=@beginTime 
	and t.CRT_TIME<=@endTime
	and t.stat_type=0
	group by t.user_id
)t2 on t1.user_id=t2.user_id
where abs(t1.coins-ifnull(t2.coins,0))>10
;

-- select 280577769- 297077773

-- select 725911- 730794

select * from koudai_20160702 t 
	where t.CRT_TIME>=@beginTime 
	and t.CRT_TIME<=@endTime
	and t.stat_type=0
	and t.user_id='2306375';
	
select *
	from game.t_order_item o 
	inner join game.t_user u on o.USER_ID=u.USER_ID and u.CHANNEL_CODE='KD' and u.OUT_USER_ID='2306375'
	where o.BALANCE_TIME>=@beginTime 
	and o.BALANCE_TIME<=@endTime
	and o.CHANNEL_CODE='KD' ;
	
-- ---------------------------------------------------------------

set @param0='2016-07-02 00:00:00';
set @param1='2016-07-02 23:59:59';

select t1.ITEM_MONEY '投注金币',t2.PRIZE_MONEY '返奖金币' from (
(select round(sum(ifnull(o.ITEM_MONEY,0))) ITEM_MONEY from game.t_order_item o 
where o.PAY_TIME>=@param0 
and o.PAY_TIME<=@param1
and o.CHANNEL_CODE='KD'  
) t1,(
select round(sum(if(o.ITEM_STATUS in (-5,-10,210),o.RETURN_MONEY,o.PRIZE_MONEY))) PRIZE_MONEY from game.t_order_item o 
where o.BALANCE_TIME>=@param0 
and o.BALANCE_TIME<=@param1
and o.CHANNEL_CODE='KD'  
and o.BALANCE_STATUS=20
) t2
)


