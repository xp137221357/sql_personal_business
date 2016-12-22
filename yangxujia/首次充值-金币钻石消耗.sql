
set @param0='2016-10-01 00:00:00';
set @param1='2016-10-31 23:59:59';


-- 首次充值的金币以及钻石消耗

select  
t.counts '首次充值人数',t.SYSTEM_MODEL '终端',t.coins '金币消耗',t.diamonds '钻石消耗',
round(t.coins/t.counts) '人均金币消耗',round(t.diamonds/t.counts) '人均钻石消耗'
from 
(
select count(t.user_id) counts,tu.SYSTEM_MODEL ,round((sum(t2.return_coins)-sum(t1.bet_coins))/146) coins,-sum(t3.diamonds) diamonds
 from 
report.t_stat_first_recharge t 
inner join t_trans_user_attr tu on t.user_id = tu.USER_ID  
and t.crt_time>=@param0 and t.crt_time<=@param1
left join (
select oi.USER_ID,
sum(oi.COIN_BUY_MONEY) bet_coins
from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
group by oi.USER_ID
) t1 on tu.USER_CODE =t1.user_id
left join (
select oi.USER_ID,sum(oi.COIN_PRIZE_MONEY) return_coins from  game.t_order_item oi 
where  oi.CHANNEL_CODE = 'GAME' 
and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.BALANCE_TIME >= @param0 and oi.BALANCE_TIME <= @param1
group by oi.USER_ID
) t2 on tu.USER_CODE =t2.user_id
left join (
 select ai.USER_ID,sum(ai.CHANGE_VALUE) diamonds from forum.t_acct_items ai 
 where ai.ADD_TIME >= @param0 
 and ai.ADD_TIME <= @param1 and ai.ITEM_STATUS=10 
 and ai.ACCT_TYPE='1003'
 and ai.ITEM_EVENT in ('BUY_RECOM','BUY_SERVICE','BUY_VIP')
 group by ai.USER_ID
) t3 on t3.USER_ID =tu.USER_ID
group by tu.SYSTEM_MODEL
) t


