-- 发生行为时间
set @beginTime0 = '2016-06-10';
set @endTime0 = '2016-07-11 23:59:59';
-- 留存行为时间
set @beginTime1 = '2016-06-10';
set @endTime1 = '2016-07-11 23:59:59';


-- 激活用户
select '激活用户',count(distinct t.USER_CODE) from forum.t_device_info t
inner join t_trans_user_attr ta on ta.USER_CODE = t.USER_CODE and ta.CHANNEL_NO='qq' 
where t.APP_STATUS!=-10 and t.ADD_TIME>=@beginTime0 and t.ADD_TIME<=@endTime0 

;

-- 注册用户

select '注册用户',count(distinct tu.USER_ID) from forum.t_user tu 
inner join t_trans_user_attr ta on ta.USER_ID = tu.USER_ID and ta.CHANNEL_NO='qq' 
where tu.CLIENT_ID='BYAPP' and tu.crt_time>=@beginTime0 and tu.crt_time<=@endTime0 ;


-- 官方新增充值人数以及金额

select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@beginTime0,'~',@endTime0),'官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID -- and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime0 and u.crt_time<=@endTime0
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method ='APP'
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime0 and tt.crt_time<=@endTime0
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method='APP'
where 
tc.CRT_TIME >=@beginTime1
and tc.CRT_TIME <=@endTime1
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)

union all

select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID -- and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime0 and u.crt_time<=@endTime0
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method ='APP'
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime0 and tt.crt_time<=@endTime0
) tt on td.charge_user_id = tt.charge_user_id 
and td.charge_method='APP'
where td.CRT_TIME >=@beginTime1
and td.CRT_TIME <=@endTime1
and td.charge_user_id not in (select user_id from t_user_merchant)
and td.charge_user_id not in (select user_id from v_user_boss)

) ttt
group by ttt.CHANNEL_COMPANY,ttt.SYSTEM_MODEL

;


-- 非官方新增充值人数以及金额


select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@beginTime0,'~',@endTime0),'非官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID -- and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime0 and u.crt_time<=@endTime0
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method !='APP'
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime0 and tt.crt_time<=@endTime0
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method !='APP'
where 
tc.CRT_TIME >=@beginTime1
and tc.CRT_TIME <=@endTime1
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)
) ttt
group by CHANNEL_COMPANY,ttt.SYSTEM_MODEL
;

-- 总新增充值人数以及金额
select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@beginTime0,'~',@endTime0),'总新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID -- and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime0 and u.crt_time<=@endTime0
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime0 and tt.crt_time<=@endTime0
) tt on tc.charge_user_id = tt.charge_user_id 
where 
tc.CRT_TIME >=@beginTime1
and tc.CRT_TIME <=@endTime1
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)

union all

select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID -- and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@beginTime0 and u.crt_time<=@endTime0
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@beginTime0 and tt.crt_time<=@endTime0
) tt on td.charge_user_id = tt.charge_user_id 
where td.CRT_TIME >=@beginTime1
and td.CRT_TIME <=@endTime1
and td.charge_user_id not in (select user_id from t_user_merchant)
and td.charge_user_id not in (select user_id from v_user_boss)
) ttt
group by CHANNEL_COMPANY,ttt.SYSTEM_MODEL


