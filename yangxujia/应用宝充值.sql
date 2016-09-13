
set @beginTime = '2016-07-22';
set @endTime = '2016-08-09 23:59:59';


-- 激活用户
select '激活用户',count(distinct t.USER_CODE) from forum.t_device_info t
inner join test.t_trans_user_attr ta on ta.USER_CODE = t.USER_CODE and ta.CHANNEL_NO='qq' 
where t.APP_STATUS!=-10 and t.ADD_TIME>=@beginTime and t.ADD_TIME<=@endTime 

union all

-- 注册用户

select '注册用户',count(distinct tu.USER_ID) from forum.t_user tu 
inner join test.t_trans_user_attr ta on ta.USER_ID = tu.USER_ID and ta.CHANNEL_NO='qq' 
where tu.CLIENT_ID='BYAPP' and tu.crt_time>=@beginTime and tu.crt_time<=@endTime ;


-- 官方新增充值人数以及金额

select '官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID and tu.CHANNEL_NO = 'qq'
inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime and u.crt_time<=@endTime
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
inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime and u.crt_time<=@endTime
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

) ttt


union all




-- 非官方新增充值人数以及金额


select '非官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID and tu.CHANNEL_NO = 'qq'
inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime and u.crt_time<=@endTime
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

) ttt;
