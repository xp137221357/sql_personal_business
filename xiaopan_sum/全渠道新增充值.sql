set @beginTime='2017-01-09 00:00:00';
set @endTime = '2017-01-09 23:59:59';


select 
tc.charge_user_id,
sum(tc.coins) coin,
count(DISTINCT tfc.charge_user_id) new_recharge_counts
from t_trans_user_recharge_coin tc 
inner join (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
where tc.crt_time>=@beginTime
and tc.crt_time<=@endTime
and tfc.crt_time>=@beginTime
and tfc.crt_time<=@endTime
group by tc.charge_user_id;



select * from forum.t_user u where u.USER_ID='2312238';


select * from forum.t_user u where u.ACCT_NUM='13322238';


select * from forum.t_user_event e where e.EVENT_CODE='reg' and e.USER_ID='2312238';


select u.* from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID
where e.EVENT_CODE='reg' and e.DEVICE_CODE='F6082B94-5E99-4040-98E0-D7E8553123A4';


select * from (
select * from forum.t_acct_items ai 
where ai.USER_ID in ('2312229','2312238','2312244')
order by ai.ADD_TIME desc limit 100 
) t group by t.USER_ID;

select * from forum.t_acct_items ai where ai.USER_ID='2312238';




select * from game.t_order_item o where o.USER_ID='2341576042310526187';





-- 2312238





