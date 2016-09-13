set @beginTime = '2016-07-07';
set @endTime = '2016-07-08';
set @channelNo = 'apple';


-- 按渠道购买钻石金额

set @beginTime = '2016-06-01';
set @endTime = '2016-07-08';
set @channelNo = 'apple';
select ifnull(sum(ai.COST_VALUE),0) from forum.t_acct_items ai 
 inner join forum.t_user_event ue on ue.event_code='reg' and ue.USER_ID = ai.user_id and ue.CHANNEL_NO = 'apple'
where ai.item_event = 'BUY_DIAMEND'
AND ai.comments NOT LIKE '%buy_coin%'
AND ai.comments NOT LIKE '%underline%'
and ai.ADD_TIME>=@beginTime
and ai.ADD_TIME<=@endTime;

-- 按渠道首次购买钻石金额
select ifnull(sum(ai.COST_VALUE),0) from forum.t_acct_items ai 
inner join forum.t_user_event ue on ue.event_code='reg' and ue.USER_ID = ai.user_id and ue.CHANNEL_NO = 'apple'
inner join t_stat_first_recharge_dmd ts on ts.USER_ID = ai.USER_ID 
and ai.ADD_TIME>=@beginTime
and ai.ADD_TIME<=@endTime
and ts.crt_time >=@beginTime 
and ts.crt_time <=@endTime

-- 投注详情（待优化）
 
set @beginTime = '2016-07-07';
set @endTime = '2016-07-08';
set @channelNo = 'apple';

select 
count(1),
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user u on u.USER_CODE = oi.USER_ID and u.CLIENT_ID='BYAPP'
 inner join forum.t_user_event ue on ue.event_code='reg' and ue.USER_ID = u.user_id and ue.CHANNEL_NO = @channelNo 
where  oi.CHANNEL_CODE = 'game' and oi.ITEM_STATUS not in (-5, -10, 210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
 union all
 
select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
 inner join forum.t_user u on u.USER_CODE = oi.USER_ID and u.CLIENT_ID='BYAPP'
 inner join forum.t_user_event ue on ue.event_code='reg' and ue.USER_ID = u.user_id and ue.CHANNEL_NO = @channelNo 
where  oi.CHANNEL_CODE = 'game' and oi.ITEM_STATUS not in (-5, -10, 210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime;
