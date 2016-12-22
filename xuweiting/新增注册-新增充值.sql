set @param0='2016-12-04 00:00:00';
set @param1 = '2016-12-04 23:59:59';


select '新增注册',date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%S') '时间',
u.NICK_NAME '昵称',u.USER_ID '用户ID',u.ACCT_NUM '会员号',
if(u.`STATUS`=-10,'冻结','正常') '用户状态'
from forum.t_user u where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and u.CLIENT_ID='BYAPP';



select '新增充值金币',date_format(tt.CRT_TIME,'%Y-%m-%d %H:%i:%S') '时间',
u.NICK_NAME '昵称',u.USER_ID '用户ID',u.ACCT_NUM '会员号',
if(u.`STATUS`=-10,'冻结','正常') '用户状态'
from forum.t_user u
inner join 
(
   select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t group by t.charge_user_id  
)tt on u.USER_ID=tt.charge_user_id and tt.crt_time>=@param0 and tt.crt_time<=@param1 
 
