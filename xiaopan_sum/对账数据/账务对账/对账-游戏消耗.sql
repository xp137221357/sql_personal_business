

INSERT into t_stat_coin_operate(stat_date,penalty_coins_consume,penalty_free_consume,rotary_coins_consume,
rotary_free_consume)
select 
t1.stat_date,
t1.rotary_coins_consume,t1.rotary_free_consume,
t2.penalty_coins_consume,t2.penalty_free_consume
from 
(
	select date_add(curdate(),interval -1 day) stat_date,
	round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1001,-ai.CHANGE_VALUE,0)))) rotary_coins_consume,
	round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1015,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1015,-ai.CHANGE_VALUE,0)))) rotary_free_consume 
	from forum.t_acct_items ai
	where ai.ADD_TIME>=date_add(curdate(),interval -1 day)
	and ai.ADD_TIME<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
	and ai.ACCT_TYPE in (1001,1015) 
	and ai.ITEM_EVENT in ('lp_trade','lp_prize')
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.ITEM_STATUS in (10,-10)
) t1,
(
	select date_add(curdate(),interval -1 day) stat_date,
	round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1001,-ai.CHANGE_VALUE,0)))) penalty_coins_consume,
	round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1015,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1015,-ai.CHANGE_VALUE,0)))) penalty_free_consume 
	from forum.t_acct_items ai
	where ai.ADD_TIME>=date_add(curdate(),interval -1 day)
	and ai.ADD_TIME<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
	and ai.ACCT_TYPE in (1001,1015) 
	and ai.ITEM_EVENT in ('dq_trade','dq_prize')
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.ITEM_STATUS in (10,-10)
)t2
on duplicate key update 
penalty_coins_consume = values(penalty_coins_consume),
penalty_free_consume = values(penalty_free_consume),
rotary_coins_consume = values(rotary_coins_consume),
rotary_free_consume = values(rotary_free_consume);


INSERT into t_stat_coin_operate(stat_date,football_coins_consume,football_free_consume)
select date_add(curdate(),interval -1 day) stat_time,
round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1001,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1001,-ai.CHANGE_VALUE,0)))) football_coins_consume,
round(sum(if(ai.CHANGE_TYPE=0,if(ai.ACCT_TYPE=1015,ai.CHANGE_VALUE,0),if(ai.ACCT_TYPE=1015,-ai.CHANGE_VALUE,0)))) football_free_consume 
from forum.t_acct_items ai
where ai.ADD_TIME>=date_add(curdate(),interval -1 day)
and ai.ADD_TIME<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ACCT_TYPE in (1001,1015) 
and ai.ITEM_EVENT in ('trade_coin','prize_coin')
and ai.USER_ID not in (select user_id from report.v_user_system)
and ai.ITEM_STATUS in (10,-10)
on duplicate key update 
football_coins_consume = values(football_coins_consume),
football_free_consume = values(football_free_consume);