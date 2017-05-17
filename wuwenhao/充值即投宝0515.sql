BEGIN
set @num = 1;

label1: WHILE @num <=7810 Do

insert into t_tb_bet_20170515(sn,user_id,crt_time,coins,rmb_value,item_event)
select ai.ITEM_ID,ai.USER_ID,ai.PAY_TIME,ai.CHANGE_VALUE,ai.COST_VALUE,ai.ITEM_EVENT from forum.t_acct_items ai 
inner join t_tb_20170515 t 
on ai.USER_ID=t.user_id and ai.ITEM_ID>t.sn and TIMESTAMPDIFF(hour,t.crt_time,ai.PAY_TIME)<1
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT!='COIN_FROM_DIAMEND'
and ai.ITEM_STATUS=10
and t.id=@num
order by ai.ITEM_ID asc limit 1
on duplicate key update 
user_id = values(user_id),
crt_time = values(crt_time),
coins = values(coins),
rmb_value = values(rmb_value),
item_event = values(item_event);
		 
SET @num = @num+1;
end while label1;

END

-- -------------------------------

select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.ACCT_NUM '会员号',u.CRT_TIME '注册时间',t.coins '金币',
if(t.item_event='APP_RECHARGE','官充','投宝') '事件',t.crt_time '事件时间' 
from t_tb_bet_20170515 t 
inner join forum.t_user u on t.user_id=u.USER_ID where t.user_id in ( 
 select t.user_id from t_tb_bet_20170515 t where t.item_event='tb_trade'
) 
and t.item_event in ('APP_RECHARGE','TB_TRADE') 
order by t.user_id asc,t.crt_time asc;