

set @param0='2016-06-01';
set @param1='2017-04-10';
set @param2='2017-05-10';

INSERT t_bet_20170509(user_id)
select user_id from forum.t_acct_items ai 
where ai.CHANGE_TYPE=1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='trade_coin'
and ai.PAY_TIME>='2016-06-01'
and ai.PAY_TIME<='2017-04-10'
group by user_id
on duplicate key update 
user_id = values(user_id);

update t_bet_20170509 t 
inner join (
	select user_id from forum.t_acct_items ai 
	where ai.CHANGE_TYPE=1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.ITEM_EVENT='trade_coin'
	and ai.PAY_TIME>@param1
	and ai.PAY_TIME<=@param2
	group by user_id
) tt on t.USER_ID=tt.user_id
set t.`STATUS`=1;



INSERT t_bet_20170509(user_id,bet_coins)
select ai.user_id,round(sum(ai.CHANGE_VALUE)) bet_coins from forum.t_acct_items ai 
inner join t_bet_20170509 t on ai.USER_ID=t.USER_ID and t.ID>=1 and t.ID<100 and t.`STATUS`=0
where ai.CHANGE_TYPE=1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='trade_coin'
and ai.PAY_TIME>='2016-06-01'
and ai.PAY_TIME<='2017-04-10'
group by ai.user_id
on duplicate key update 
bet_coins = values(bet_coins);


select max(t.ID) from t_bet_20170509 t


update t_bet_20170509 t
inner join (
select user_id from t_bet_20170509 t order by t.BET_COINS desc limit 100
) tt on t.USER_ID=tt.user_id
 set t.`STATUS`=2

update t_bet_20170509 t set t.`STATUS`=10;



update t_bet_20170509 t 
inner join (
SELECT t.USER_ID,e.DEVICE_CODE FROM FORUM.t_user_event e 
inner join t_bet_20170509 t on e.USER_ID=t.USER_ID and t.`STATUS`=2
where e.EVENT_CODE='reg'
) tt on t.USER_ID=tt.user_id
set t.DEVICE_CODE=tt.DEVICE_CODE;


update t_bet_20170509 t 
inner join (
SELECT t.USER_ID,round(sum(ai.CHANGE_VALUE)) PRIZE_MONEY FROM FORUM.t_acct_items ai 
inner join t_bet_20170509 t on ai.USER_ID=t.USER_ID and t.`STATUS`=2
where ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='prize_coin'
group by ai.USER_ID
) tt on t.USER_ID=tt.user_id
set t.PRIZE_MONEY=tt.PRIZE_MONEY;


select * from t_bet_20170509 t where t.`STATUS`=2;

update t_bet_20170509 t 
inner join (
	select * from (
	SELECT t.USER_ID,e.DEVICE_CODE FROM FORUM.t_user_event e 
	inner join t_bet_20170509 t on e.USER_ID=t.USER_ID and t.`STATUS`=2 and t.DEVICE_CODE is null
	order by e.CRT_TIME desc
) t group by t.USER_ID
) tt on t.USER_ID=tt.user_id
set t.DEVICE_CODE=tt.DEVICE_CODE;


select tt.USER_ID '大户ID',u.NICK_NAME '昵称',u.ACCT_NUM '会员号',t.BET_COINS '投注',t.PRIZE_MONEY '返奖',t.DEVICE_CODE '设备号' from t_bet_20170509 t 
inner join forum.t_user u on t.USER_ID=u.USER_ID
left join report.t_user_boss tt on u.USER_ID = tt.USER_ID
where t.`STATUS`=2;