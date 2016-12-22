-- insert into no_bet_user_acct_balance_2016_1124(user_id,nick_name,USER_MOBILE,CRT_TIME,acct_balance,stat)
select u.USER_ID,u.NICK_NAME,u.USER_MOBILE,u.CRT_TIME,ta.acct_balance,if(u.`STATUS`=11,'冻结','正常') stat 
from no_bet_user_2016_10_11 t 
inner join forum.t_user u on u.user_id = t.user_id
inner join user_acct_balance_2016_1124 ta on u.USER_CODE = ta.acc_name
limit 100 
on duplicate key update 
nick_name = values(nick_name),
USER_MOBILE = values(USER_MOBILE),
CRT_TIME = values(CRT_TIME),
acct_balance = values(acct_balance),
stat = values(stat)


call procedure_user_acct_balance()

