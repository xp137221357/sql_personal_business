-- 发生行为时间
set @beginTime0 = '2016-08-29';
set @endTime0 = '2016-09-18 23:59:59';
-- 留存行为时间
set @beginTime1 = '2016-09-19';
set @endTime1 = '2016-09-22 23:59:59';

-- 继续留存时间
set @beginTime2 = '2016-09-23';
set @endTime2 = '2016-09-28 23:59:59';



-- --------------------------------1
-- 目标用户数
select count(t.user_id) '目标用户数' from test.t_order_temp2 t where t.rate < '-0.1' ;

-- 领取用户数
select count(t1.user_id)'领取用户数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate < '-0.1'
where t1.IS_REPAY = 1 ;

-- 派送金币数
select sum(t1.REPAY_MONEY) '派送金币数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate < '-0.1'
where t1.IS_REPAY = 1 ;


-- 留存时间-充值用户数以及金额
select count(t2.user_id) '充值用户数',sum(t2.coins) '金额' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate < '-0.1'
	where t1.IS_REPAY = 1 
	) t1
	inner join report.t_trans_user_attr tu on tu.USER_CODE = t1.USER_ID
	inner join (
	select charge_user_id user_id,sum(tc.coins) coins from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime2 and tc.crt_time<=@endTime2
	group by charge_user_id
)t2 on tu.user_id = t2.user_id
;


-- 留存时间-投注人数以及金币
select count(t2.user_id) '留存投注人数',sum(t2.coins) '金币' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate < '-0.1'
	where t1.IS_REPAY = 1 
	) t1
	inner join (
	select o.user_id,sum(o.ITEM_MONEY) coins from game.t_order_item o 
	where o.crt_time>=@beginTime2 and o.crt_time<=@endTime2
	and   o.ITEM_STATUS not in (-5, -10, 210)
	and   o.channel_code = 'GAME'
	group by o.user_id
)t2 on t1.user_id = t2.user_id
	;
	
	
-- ----------------------------------2
select count(t.user_id) '目标用户数' from test.t_order_temp2 t where t.rate >= '-0.1' and  t.rate < '-0.01';

-- 领取用户数
select count(t1.user_id) '领取用户数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '-0.1' and  t2.rate < '-0.01'
where t1.IS_REPAY = 1 ;

-- 派送金币数
select sum(t1.REPAY_MONEY) '派送金币数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '-0.1' and  t2.rate < '-0.01'
where t1.IS_REPAY = 1 ;

-- 留存时间-充值用户数以及金额
select count(t2.user_id) '充值用户数',sum(t2.coins) '金额' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '-0.1' and  t2.rate < '-0.01'
	where t1.IS_REPAY = 1 
	) t1
	inner join report.t_trans_user_attr tu on tu.USER_CODE = t1.USER_ID
	inner join (
	select charge_user_id user_id,sum(tc.coins) coins from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime2 and tc.crt_time<=@endTime2
	group by charge_user_id
)t2 on tu.user_id = t2.user_id
	;

-- 留存时间-投注人数以及金币
select count(t2.user_id) '留存投注人数',sum(t2.coins) '金币' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '-0.1' and  t2.rate < '-0.01'
	where t1.IS_REPAY = 1 
	) t1
	inner join (
	select o.user_id,sum(o.ITEM_MONEY) coins from game.t_order_item o 
	where o.crt_time>=@beginTime2 and o.crt_time<=@endTime2
	and   o.ITEM_STATUS not in (-5, -10, 210)
	and   o.channel_code = 'GAME'
	group by o.user_id
)t2 on t1.user_id = t2.user_id
	;
	
-- ----------------------------------3
select count(t.user_id) '目标用户数' from test.t_order_temp2 t where t.rate >= '0.01' ;

-- 领取用户数
select count(t1.user_id) '领取用户数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '0.01' 
where t1.IS_REPAY = 1 ;


-- 派送金币数
select sum(t1.REPAY_MONEY) '派送金币数' from game.t_rechar_repay  t1
inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '0.01' 
where t1.IS_REPAY = 1 ;


-- 留存时间-充值用户数以及金额
select count(t2.user_id) '充值用户数',sum(t2.coins) '金额' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '0.01' 
	where t1.IS_REPAY = 1 
	) t1
	inner join report.t_trans_user_attr tu on tu.USER_CODE = t1.USER_ID
	inner join (
	select charge_user_id user_id,sum(tc.coins) coins from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime2 and tc.crt_time<=@endTime2
	group by charge_user_id
)t2 on tu.user_id = t2.user_id
	;

-- 留存时间-投注人数以及金币
select count(t2.user_id) '留存投注人数',sum(t2.coins) '金币' from (
	select t1.user_id from game.t_rechar_repay  t1
	inner join test.t_order_temp2 t2 on t1.USER_ID= t2.user_id and t2.rate >= '0.01' 
	where t1.IS_REPAY = 1 
	) t1
	inner join (
	select o.user_id,sum(o.ITEM_MONEY) coins from game.t_order_item o 
	where o.crt_time>=@beginTime2 and o.crt_time<=@endTime2
	and   o.ITEM_STATUS not in (-5, -10, 210)
	and   o.channel_code = 'GAME'
	group by o.user_id
)t2 on t1.user_id = t2.user_id
	;

-- ----------------------------------4
select count(t.user_id) '目标用户数' from game.t_rechar_repay t where t.ITEM_TYPE = '1015'  ;

-- 领取用户数
select count(t.user_id) '领取用户数' from game.t_rechar_repay  t 
where t.ITEM_TYPE = '1015' and t.IS_REPAY = 1 ;


-- 派送金币数
select sum(t.REPAY_MONEY) '派送金币数' from game.t_rechar_repay  t 
where t.ITEM_TYPE = '1015' and t.IS_REPAY = 1 ;


-- 留存时间-充值用户数以及金额
select count(t2.user_id) '充值用户数',sum(t2.coins) '金额' from (
	select t.user_id from game.t_rechar_repay  t 
	where t.ITEM_TYPE = '1015' and t.IS_REPAY = 1
	) t1
	inner join report.t_trans_user_attr tu on tu.USER_CODE = t1.USER_ID
	inner join (
	select charge_user_id user_id,sum(tc.coins) coins from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime2 and tc.crt_time<=@endTime2
	group by charge_user_id
)t2 on tu.user_id = t2.user_id
	;


-- 留存时间-投注人数以及金币
select count(t2.user_id) '留存投注人数',sum(t2.coins) '金币' from (
	select t.user_id from game.t_rechar_repay  t 
	where t.ITEM_TYPE = '1015' and t.IS_REPAY = 1
	) t1
	inner join (
	select o.user_id,sum(o.ITEM_MONEY) coins from game.t_order_item o 
	where o.crt_time>=@beginTime2 and o.crt_time<=@endTime2
	and   o.ITEM_STATUS not in (-5, -10, 210)
	and   o.channel_code = 'GAME'
	group by o.user_id
)t2 on t1.user_id = t2.user_id
	;
	
-- 总人数


select count(t.user_id) '目标用户数' from game.t_rechar_repay t  ;



select count(t.user_id) '领取用户数' from game.t_rechar_repay  t 
where t.IS_REPAY = 1 ;


-- 派送金币数
select sum(t.REPAY_MONEY) '派送金币数' from game.t_rechar_repay  t 
where  t.IS_REPAY = 1 ;



-- 留存时间-充值用户数
select count(t2.user_id) '充值用户数',sum(t2.coins) '金额' from (
	select t.user_id from game.t_rechar_repay  t 
	where t.IS_REPAY = 1
	) t1
	inner join report.t_trans_user_attr tu on tu.USER_CODE = t1.USER_ID
	inner join (
	select charge_user_id user_id,sum(tc.coins) coins from t_trans_user_recharge_coin tc where tc.crt_time>=@beginTime2 and tc.crt_time<=@endTime2
	group by charge_user_id
)t2 on tu.user_id = t2.user_id
	;


-- 留存时间-投注人数
select count(t2.user_id) '留存投注人数',sum(t2.coins) '金币' from (
	select t.user_id from game.t_rechar_repay  t 
	where  t.IS_REPAY = 1
	) t1
	inner join (
	select o.user_id,sum(o.ITEM_MONEY) coins from game.t_order_item o 
	where o.crt_time>=@beginTime2 and o.crt_time<=@endTime2
	and   o.ITEM_STATUS not in (-5, -10, 210)
	and   o.channel_code = 'GAME'
	group by o.user_id
)t2 on t1.user_id = t2.user_id
	;
	
	
