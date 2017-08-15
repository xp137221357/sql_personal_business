-- 竞猜消耗



select * from t_stat_coin_operate_dawn t order by t.stat_date desc limit 10;

-- 杭州手机号码+投注>100000(2017-01-01~现在)，用户昵称，会员号，累积投注金币，累积返奖

select * from t_mobile_location t where t.CITY='杭州';



select sum(o.COIN_BUY_MONEY) from forum.t_user u 
inner join forum.t_mobile_location tm on u.USER_MOBILE=tm.MOBILE and tm.CITY='杭州'
inner join game.t_order_item o on u.USER_CODE=o.USER_ID
and o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.COIN_BUY_MONEY>0
and o.CRT_TIME>='2017-01-01';



select ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) from forum.t_user u 
inner join forum.t_mobile_location tm on u.USER_MOBILE=tm.MOBILE and tm.CITY='杭州'
inner join game.t_order_item o on u.USER_CODE=o.USER_ID
and o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.COIN_BUY_MONEY>0
and o.BALANCE_TIME>='2017-01-01';



insert into t_user_hangzhou(user_id)
select u.USER_CODE from forum.t_user u 
inner join forum.t_mobile_location tm on u.USER_MOBILE=tm.MOBILE and tm.CITY='杭州';





