-- xin

-- 表1

set @beginTime = '2016-08-22 00:00:00';
set @endTime = '2016-08-29 00:00:00';

-- 注册
select concat(@beginTime,'~',@endTime) '时间',count(u.USER_ID) '注册人数' from forum.t_user u 
where u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime ;

-- 投注
select concat(@beginTime,'~',@endTime) '时间',count(distinct oi.user_id) '投注人数',count(oi.user_id) '订单数',count(oi.BALANCE_MATCH_ID) '场次',
sum(oi.ITEM_MONEY) '投注金币',sum(oi.PRIZE_MONEY) '返奖金币',count(if(oi.PRIZE_MONEY>0,oi.USER_ID,null)) '中奖单数'
from game.t_order_item oi
inner join forum.t_user u on u.USER_CODE=oi.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime 
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime;

-- 官方+第三方充值
select concat(@beginTime,'~',@endTime) '时间',count(distinct tc.charge_user_id) '充值人数'
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on u.USER_ID=tc.charge_user_id and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime 
and tc.CRT_TIME >= @beginTime and tc.CRT_TIME < @endTime;



-- 表2

set @beginTime = '2016-08-22 00:00:00';
set @endTime = '2016-08-29 00:00:00';

select u.CRT_TIME '注册时间',u.USER_ID '用户ID',u.NICK_NAME '昵称',oi.PAY_TIME '投注时间',oi.item_MONEY '投注',oi.PRIZE_MONEY '返还' 
from game.t_order_item oi
inner join forum.t_user u on u.USER_CODE=oi.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime 
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime;


select 
count(distinct if(oi.ITEM_MONEY<100,oi.USER_ID,null)) '100一下',
count(distinct if(oi.ITEM_MONEY>=100 and oi.ITEM_MONEY<200,oi.USER_ID,null)) '100~200',
count(distinct if(oi.ITEM_MONEY>=200 and oi.ITEM_MONEY<500,oi.USER_ID,null)) '200~500',
count(distinct if(oi.ITEM_MONEY>=500 and oi.ITEM_MONEY<800,oi.USER_ID,null)) '500~800',
count(distinct if(oi.ITEM_MONEY>=800 and oi.ITEM_MONEY<1000,oi.USER_ID,null)) '800~1000',
count(distinct if(oi.ITEM_MONEY>=1000 and oi.ITEM_MONEY<3000,oi.USER_ID,null)) '1000~3000',
count(distinct if(oi.ITEM_MONEY>=3000 ,oi.USER_ID,null)) '1000~3000',
from game.t_order_item oi
inner join forum.t_user u on u.USER_CODE=oi.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime 
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime;

