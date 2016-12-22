set @beginTime='2016-11-07 00:00:00';
set @endTime = '2016-11-13 23:59:59';	

select 
tc.charge_user_id '充值用户ID',
u.NICK_NAME '充值用户昵称',
tc.saler '卖家ID',
u1.NICK_NAME '卖家用户昵称',
tc.coins '充值金币',tc.crt_time '充值时间',
tc.charge_method
from t_trans_user_recharge_coin tc 
left join forum.t_user u on u.USER_ID=tc.charge_user_id
left join forum.t_user u1 on u1.USER_ID=tc.saler
where tc.crt_time>=@beginTime 
and tc.crt_time<=@endTime -- and tc.charge_user_id='1989606'
order by tc.crt_time asc


select 'P','线下充值',concat(@beginTime,'~',@endTime) '时间','all',
round(sum(ifnull(ai.CHANGE_VALUE,0))) '金币' from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
and ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%'
and ai.item_status = 10 



select * 
from t_trans_user_recharge_coin tc 
where tc.coins<0


select * from 
report.t_trans_user_recharge_coin t1
inner join report.t_trans_user_withdraw t2 on t1.sn=t2.sn



