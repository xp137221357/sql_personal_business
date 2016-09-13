INSERT into t_stat_coin_operate(stat_date,recharge_coins)
select 
date_add(curdate(),interval -1 day) stat_date,
round(sum(ifnull(ai.CHANGE_VALUE,0))) recharge_coins from forum.t_acct_items ai 
where ai.ADD_TIME >= date_add(curdate(),interval -1 day)
and ai.ADD_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ((ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%') or (ai.ITEM_EVENT='COIN_FROM_DIAMEND'))
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 
on duplicate key update 
recharge_coins = values(recharge_coins)
