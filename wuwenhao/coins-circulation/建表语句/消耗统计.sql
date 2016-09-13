INSERT into t_stat_coin_operate(stat_date,exchange_coins_consume,broadcast_coins_consume,broadcast_free_consume,
redeem_coins_consume,redeem_free_consume,draw_coins_consume,draw_free_consume)
select 
t.stat_date,
ifnull(t.anwser_coins,0)+ifnull(t1.present_coins,0) exchange_coins_consume,
t2.broadcast_coins_consume,
t2.broadcast_free_consume,
t3.redeem_coins_consume,
t3.redeem_free_consume,
t3.draw_coins_consume,
t3.draw_free_consume
from (select 
date_add(curdate(),interval -1 day) stat_date,
 -round(SUM(abs(ai.OFFER_TAX))) anwser_coins from game.t_offer ai
inner join forum.t_user u on u.USER_CODE = ai.USER_ID
where ai.CRT_TIME >= date_add(curdate(),interval -1 day) and ai.CRT_TIME <=concat(date_add(curdate(),interval -1 day),' 23:59:59'))t 
left join (
select 
date_add(curdate(),interval -1 day) stat_date,
 -round(SUM(ai.FEE_MONEY)) present_coins from forum.t_user_present ai
where  ai.STATUS = 10 AND ai.CRT_TIME >= date_add(curdate(),interval -1 day) and ai.CRT_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59') 
)t1 on t.stat_date=t1.stat_date

left join (
SELECT date_add(curdate(),interval -1 day) stat_date,
-ROUND(sum(if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0))) broadcast_coins_consume,
-ROUND(sum(if(ai.ACCT_TYPE=1015,ai.CHANGE_VALUE,0))) broadcast_free_consume
FROM game.t_msg ms
INNER JOIN forum.t_acct_items ai ON cast(ms.MSG_ID as char)= ai.TRADE_NO
AND ms.USER_ID=ai.ACCT_ID 
AND ms.ADD_TIME>= date_add(curdate(),interval -1 day)
AND ms.ADD_TIME <= concat(date_add(curdate(),interval -1 day),' 23:59:59') 
and ms.SEND_STATUS=1
AND ai.ITEM_EVENT='TRADE_COIN'
) t2 on t.stat_date = t2.stat_date

left join (
select 
date_add(curdate(),interval -1 day) stat_date,
 -round(SUM(if(ai.ITEM_EVENT='COIN_REDEEM' and ai.ACCT_TYPE=1001,ai.change_value,0))) redeem_coins_consume,
 -round(SUM(if(ai.ITEM_EVENT='BUY_ACT_TIMES' and ai.ACCT_TYPE=1001,ai.change_value,0))) draw_coins_consume,
 -round(SUM(if(ai.ITEM_EVENT='COIN_REDEEM' and ai.ACCT_TYPE=1015,ai.change_value,0))) redeem_free_consume,
 -round(SUM(if(ai.ITEM_EVENT='BUY_ACT_TIMES' and ai.ACCT_TYPE=1015,ai.change_value,0))) draw_free_consume 
from forum.t_acct_items ai
where  ai.ITEM_STATUS = 10 AND ai.ITEM_EVENT in ('COIN_REDEEM','BUY_ACT_TIMES') 
and ai.ADD_TIME >= date_add(curdate(),interval -1 day)  and ai.ADD_TIME <=concat(date_add(curdate(),interval -1 day),' 23:59:59') )
t3 on t.stat_date = t3.stat_date 
on duplicate key update 
exchange_coins_consume = values(exchange_coins_consume),
broadcast_coins_consume = values(broadcast_coins_consume),
broadcast_free_consume = values(broadcast_free_consume),
redeem_coins_consume = values(redeem_coins_consume),
redeem_free_consume = values(redeem_free_consume),
draw_coins_consume = values(draw_coins_consume),
draw_free_consume = values(draw_free_consume)