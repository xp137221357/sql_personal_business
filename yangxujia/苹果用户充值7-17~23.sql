set @beginTime0 = '2016-07-17 00:00:00';
set @endTime0 = '2016-07-23 23:59:59';

set @beginTime1 = '2016-07-17 00:00:00';
set @endTime1 = '2016-07-31 23:59:59';

select u.CRT_TIME 用户注册时间,u.NICK_NAME 用户名,u.USER_ID 用户id,t.ADD_TIME 充值时间,t.ITEM_SRC 充值方式,t.cost_VALUE 充值金额 from forum.t_acct_items t
inner join forum.t_user u on u.USER_ID = t.USER_ID and u.CLIENT_ID ='BYAPP' and u.CRT_TIME >= @beginTime0 and  u.CRT_TIME <= @endTime0 
inner join test.t_trans_user_attr ta on ta.USER_ID = t.USER_ID and ta.CHANNEL_NAME='苹果'
where t.ITEM_EVENT = 'BUY_DIAMEND' and t.ITEM_STATUS = 10 and t.ADD_TIME >= @beginTime1 and  t.ADD_TIME <= @endTime1 
order by t.ADD_TIME desc

-- group by t.ADD_TIME

set @beginTime = '2016-07-17 00:00:00';
set @endTime = '2016-07-23 23:59:59';

select * from forum.t_acct_items t where t.COST_VALUE>0 limit 1000

-- 激活用户
select count(distinct t.USER_CODE) from forum.t_device_info t
inner join test.t_trans_user_attr ta on ta.USER_CODE = t.USER_CODE and ta.CHANNEL_NO='qq' 
where t.APP_STATUS!=-10 and t.ADD_TIME>=@beginTime and t.ADD_TIME<=@endTime 

-- 激活设备
select count(distinct t.DEVICE_CODE) from forum.t_device_info t
inner join test.t_trans_user_attr ta on ta.USER_CODE = t.USER_CODE and ta.CHANNEL_NO='qq' 
where t.APP_STATUS!=-10 and t.ADD_TIME>=@beginTime and t.ADD_TIME<=@endTime

-- 注册用户

select count(distinct tu.USER_ID) from forum.t_user tu 
inner join test.t_trans_user_attr ta on ta.USER_ID = tu.USER_ID and ta.CHANNEL_NO='qq' 
where tu.CLIENT_ID='BYAPP' and tu.crt_time>=@beginTime and tu.crt_time<=@endTime 


-- 官方新增充值人数以及金额

select count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID and tu.CHANNEL_NO = 'qq'
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime and tt.crt_time<=@endTime
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method='APP'
where 
tc.CRT_TIME >=@beginTime
and tc.CRT_TIME <=@endTime
and tc.charge_user_id not in (select user_id from test.t_user_merchant)
and tc.charge_user_id not in (select user_id from test.new_user_boss)

union all

select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from test.t_trans_user_recharge_diamond td

inner join test.t_trans_user_attr tu on td.charge_user_id = tu.USER_ID and tu.CHANNEL_NO = 'qq'
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime and tt.crt_time<=@endTime
) tt on td.charge_user_id = tt.charge_user_id 
and td.charge_method='APP'
where td.CRT_TIME >=@beginTime
and td.CRT_TIME <=@endTime
and td.charge_user_id not in (select user_id from test.t_user_merchant)
and td.charge_user_id not in (select user_id from test.new_user_boss)

) ttt;




-- 非官方新增充值人数以及金额


select count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID and tu.CHANNEL_NO = 'qq'
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime and tt.crt_time<=@endTime
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method !='APP'
where 
tc.CRT_TIME >=@beginTime
and tc.CRT_TIME <=@endTime
and tc.charge_user_id not in (select user_id from test.t_user_merchant)
and tc.charge_user_id not in (select user_id from test.new_user_boss)

) ttt


