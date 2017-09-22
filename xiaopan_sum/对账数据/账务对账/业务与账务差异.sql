SELECT o.* FROM game.t_order_item o left join forum.t_acct_items ai on o.ORDER_ID=ai.TRADE_NO and ai.ACCT_ID=o.USER_ID and ai.ITEM_EVENT IN ('TRADE_COIN','BK_TRADE_COIN')
where o.CHANNEL_CODE='GAME' AND o.item_status!=0  AND o.crt_time<date_add(now(),interval -10 minute) and  o.crt_time>date_add(now(),interval -5 day) and ai.ITEM_ID is null
union all
SELECT o.* FROM game.t_order_item o left join forum.t_acct_items ai on ai.TRADE_NO=concat(o.ITEM_ID,'_0') and ai.ACCT_ID=o.USER_ID and ai.ITEM_EVENT IN ('PRIZE_COIN','BK_PRIZE_COIN')
where o.CHANNEL_CODE='GAME' AND o.item_status =210  AND o.BALANCE_TIME<date_add(now(),interval -10 minute) and  o.BALANCE_TIME>date_add(now(),interval -3 day) and ai.ITEM_ID is null
union all
SELECT o.* FROM game.t_order_item o left join forum.t_acct_items ai on ai.TRADE_NO=concat('REF-',o.ITEM_ID) and ai.ACCT_ID=o.USER_ID and ai.ITEM_EVENT IN ('PRIZE_COIN','BK_PRIZE_COIN')
where o.CHANNEL_CODE='GAME' AND o.item_status =-10  AND o.BALANCE_TIME<date_add(now(),interval -10 minute) and  o.BALANCE_TIME>date_add(now(),interval -5 day) and ai.ITEM_ID is null
union all
SELECT o.* FROM game.t_order_item o left join forum.t_acct_items ai on ai.TRADE_NO=concat(o.ITEM_ID,'_ex_0') and ai.ACCT_ID=o.USER_ID and ai.ITEM_EVENT IN ('EXTRA_COIN','BK_EXTRA_COIN')
where o.CHANNEL_CODE='GAME' AND o.item_status !=0  AND o.BALANCE_TIME<date_add(now(),interval -10 minute) and  o.BALANCE_TIME>date_add(now(),interval -5 day) and ai.ITEM_ID is null
union all
SELECT o.* FROM game.t_order_item o left join forum.t_acct_items ai on ai.TRADE_NO in (concat(o.ITEM_ID,'_0'),concat(o.ITEM_ID,'_1')) and ai.ACCT_ID=o.USER_ID and ai.ITEM_EVENT IN ('PRIZE_COIN','BK_PRIZE_COIN')
where o.CHANNEL_CODE='GAME' AND o.item_status =110  AND o.BALANCE_TIME<date_add(now(),interval -10 minute) and  o.BALANCE_TIME>date_add(now(),interval -3 day) and ai.ITEM_ID is null
union all
select * from forum.t_acct_items ai 
where ai.ADD_TIME>date_add(now(),interval -5 day) and ai.ADD_TIME<date_add(now(),interval -10 minute) and ai.ITEM_STATUS=0 and ai.ACCT_RESULT='acc.success-waiting-callback'
