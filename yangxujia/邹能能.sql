set @beginTime = '2015-01-01';
set @endTime = '2016-06-30';
set @invite_name = '邹能能';

-- 投注场次 投注金额 返奖金额 余额 
select concat(@beginTime,'~',@endTime) '时间',t1.user_id,round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_boss)) t1,(select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.v_user_boss)) t2


/*
SELECT Concat(@beginTime, '~', @endTime)         '时间',
       Ifnull(Count(DISTINCT( tp.tuser_id )), 0) '人数',
       Ifnull(Sum(tp.money), 0)                  '金币数'
       
       */
       
select 
u.NICK_NAME,u.USER_ID,
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user u on u.USER_CODE = oi.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5,-10,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and u.USER_ID in (    
SELECT tp.tuser_id user_id
FROM   forum.t_user_present tp
       INNER JOIN forum.t_user u
               ON u.user_id = tp.tuser_id
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
                  AND r2.user_id IN (SELECT u.user_code
                                     FROM   forum.t_user u
                                     WHERE  u.nick_name = @invite_name)
WHERE  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
		 group by tp.tuser_id)
group by oi.USER_ID



      
SELECT tp.tuser_id user_id
FROM   forum.t_user_present tp
       INNER JOIN forum.t_user u
               ON u.user_id = tp.tuser_id
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
                  AND r2.user_id IN (SELECT u.user_code
                                     FROM   forum.t_user u
                                     WHERE  u.nick_name = @invite_name)
WHERE  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
		 group by tp.tuser_id; 