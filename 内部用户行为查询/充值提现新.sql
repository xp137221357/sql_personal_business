


select * from ( 
select '用户充值',tc.sn,u.nick_name '用户昵称',u.ACCT_NUM '用户会员号',u2.nick_name '币商',tc.coins '充值金币',tc.crt_time '充值时间' ,e.*
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on u.USER_ID=tc.charge_user_id -- and tc.charge_method!='app'
inner join forum.t_user u2 on u2.USER_ID=tc.saler 
inner join forum.t_user_event e on u.USER_ID=e.USER_ID and e.CRT_TIME<=tc.crt_time
and u.user_id in (
select user_id from t_inner_stat_user
)
order by e.CRT_TIME desc
) t group by t.sn;


select * from (
select '用户提现',tc.sn,u.nick_name '用户昵称',u.ACCT_NUM '用户会员号',u2.nick_name '币商',tc.coins '提现金币',tc.crt_time '提现时间' ,e.*
from report.t_trans_user_withdraw tc 
inner join forum.t_user u on u.USER_ID=tc.user_id
inner join forum.t_user u2 on u2.USER_ID=tc.buyer 
inner join forum.t_user_event e on u.USER_ID=e.USER_ID and e.CRT_TIME<=tc.crt_time
and u.user_id in (
select user_id from t_inner_stat_user
)
 order by e.CRT_TIME desc
 ) t group by t.sn;