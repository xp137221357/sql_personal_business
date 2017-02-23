
set @beginTime='2017-01-10 00:00:00';
set @endTime = '2017-01-10 23:59:59';

select 
t1.stat_time,
t1.bet_coins,
t1.bet_p_coins,
t1.bet_all_coins,
t2.return_coins,
t2.return_p_coins,
t2.return_all_coins
from (
select date(oi.CRT_TIME) stat_time,
round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins,
 round(sum(ifnull(oi.COIN_BUY_MONEY,0))+sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_all_coins
  from game.t_order_item oi
where  
oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS -- not in (-5, -10 , 210)
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME <= @endTime
group by stat_time
) t1
left join (
select date(oi.BALANCE_TIME) stat_time,
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins,
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_p_coins,
 round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))+sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_all_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' -- and oi.ITEM_STATUS not in (-5, -10 , 210) 
and oi.BALANCE_STATUS=20
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
group by stat_time
)t2 
on t1.stat_time=t2.stat_time
;


select @beginTime stat_time,
round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1001,-ai.CHANGE_VALUE,0)))) football_coins_consume,
round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1015,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1015,-ai.CHANGE_VALUE,0)))) football_free_consume 
from forum.t_acct_items ai
where ai.ADD_TIME>=@beginTime
and ai.ADD_TIME<=@endTime
and ai.ACCT_TYPE in (1001,1015) 
and ai.ITEM_EVENT in ('trade_coin','prize_coin')
and ai.USER_ID not in (select user_id from report.v_user_system)
and ai.ITEM_STATUS in (10,-10);

select count(distinct ai.user_id),sum(ai.CHANGE_VALUE)  
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
where ai.ADD_TIME>='2016-12-20'
and ai.ADD_TIME<=concat('2016-12-20',' 23:59:59')
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_EVENT in ('trade_coin')
and ai.ITEM_STATUS in (10,-10)
and ai.TRADE_NO not in (
select cast(ms.MSG_ID as char) from game.t_msg ms where ms.ADD_TIME >=date_add('2016-12-20',interval -1 hour)
)
and ai.USER_ID not in (select user_id from report.v_user_system);



select count(distinct ai.user_id),sum(ai.CHANGE_VALUE)  
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.user_id and u.CLIENT_ID='BYAPP'
where ai.ADD_TIME>='2016-12-20'
and ai.ADD_TIME<=concat('2016-12-20',' 23:59:59')
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_EVENT in ('prize_coin')
and ai.ITEM_STATUS in (10,-10)
and ai.TRADE_NO not in (
select cast(ms.MSG_ID as char) from game.t_msg ms where ms.ADD_TIME >=date_add('2016-12-20',interval -1 hour)
)
and ai.USER_ID not in (select user_id from report.v_user_system);


select date(oi.CRT_TIME) stat_time,
count(distinct oi.USER_ID),
round(sum(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins,
round(sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_p_coins,
 round(sum(ifnull(oi.COIN_BUY_MONEY,0))+sum(ifnull(oi.P_COIN_BUY_MONEY,0))) bet_all_coins
  from game.t_order_item oi
  inner join forum.t_user u on oi.USER_ID=u.user_code and u.CLIENT_ID='BYAPP'
where  
oi.CHANNEL_CODE = 'GAME' -- and oi.ITEM_STATUS not in (-5, -10 , 210)
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME <= @endTime
and oi.COIN_BUY_MONEY>0
group by stat_time;

-- 187424871.71753433
-- 178566482
-- 18220644

select date(oi.BALANCE_TIME) stat_time,
count(distinct oi.USER_ID),
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins,
round(sum(ifnull(oi.COIN_RETURN_MONEY,0))) return_return_coins,
round(sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_p_coins,
 round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))+sum(ifnull(oi.P_COIN_PRIZE_MONEY,0))) return_all_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' -- and oi.ITEM_STATUS not in (-5, -10 , 210) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
and ( oi.COIN_PRIZE_MONEY>0 or oi.COIN_RETURN_MONEY>0)
group by stat_time;



select date(oi.BALANCE_TIME) stat_time,
round(sum(ifnull(oi.COIN_PRIZE_MONEY,0))) return_coins,
round(sum(ifnull(oi.COIN_RETURN_MONEY,0))) return_return_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME'  and oi.ITEM_STATUS in (-10) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
and oi.COIN_PRIZE_MONEY>0;


select date(oi.return_TIME) stat_time,
round(sum(ifnull(oi.COIN_RETURN_MONEY,0))) return_coins,
round(sum(ifnull(oi.P_COIN_RETURN_MONEY,0))) return_p_coins,
 round(sum(ifnull(oi.COIN_RETURN_MONEY,0))+sum(ifnull(oi.P_COIN_RETURN_MONEY,0))) return_all_coins
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' 
and oi.RETURN_TIME >= @beginTime and oi.RETURN_TIME <= @endTime
group by stat_time;


select *
 from game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME'  and oi.ITEM_STATUS in (-10) 
and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME <= @endTime
and oi.COIN_PRIZE_MONEY>0;


