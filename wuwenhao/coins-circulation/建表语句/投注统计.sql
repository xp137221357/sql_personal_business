set @beginTime='2016-08-15 00:00:00';
set @endTime = '2016-08-21 23:59:59';

-- pass_type = 1001 为单关
-- item_type = 0,10 为未结算 或者结算时间 为空
-- inplay =0 为滚球

-- 金币投注返奖盈利
INSERT into t_stat_coin_operate(stat_date,football_coins_consume,football_free_consume)
select 
t.stat_date,
t.football_coins_consume,
tt.football_free_consume
from (
select 
date_add(curdate(),interval -1 day) stat_date,
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) football_coins_consume
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= date_add(curdate(),interval -1 day) and oi.PAY_TIME < concat(date_add(curdate(),interval -1 day),' 23:59:59')
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0)+ifnull(oi.COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= date_add(curdate(),interval -1 day) and oi.BALANCE_TIME < concat(date_add(curdate(),interval -1 day),' 23:59:59')
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t2 ) t
left join (
select date_add(curdate(),interval -1 day) stat_date,
round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) football_free_consume
from (select 
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= date_add(curdate(),interval -1 day) and oi.PAY_TIME < concat(date_add(curdate(),interval -1 day),' 23:59:59')
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t1,(select 
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)+ifnull(oi.P_COIN_RETURN_MONEY,0))) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= date_add(curdate(),interval -1 day) and oi.BALANCE_TIME < concat(date_add(curdate(),interval -1 day),' 23:59:59')
and oi.USER_ID not in (select user_code from forum.v_user_system)
) t2 ) tt on t.stat_date=tt.stat_date
on duplicate key update 
football_coins_consume = values(football_coins_consume),
football_free_consume = values(football_free_consume)