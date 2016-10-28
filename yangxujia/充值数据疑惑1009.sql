-- set params=['2016-09-01','2016-09-30 23:59:59','2016-09-01','2016-09-30 23:59:59'];
-- 前两个参数为发生行为起始时间，后两个参数为留存行为起始时间
-- 因为 两个 分新增 必定 大于 合集的新增

set @param0='2016-09-01';

set @param1='2016-09-30 23:59:59';

set @param2='2016-09-01';

set @param3='2016-09-30 23:59:59';

set @channel_company = '苹果';

select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@param0,'~',@param1),'非官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  -- and tu.CHANNEL_COMPANY=@channel_company
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method !='APP'
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method !='APP'
where 
tc.CRT_TIME >=@param2
and tc.CRT_TIME <=@param3
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)
) ttt
group by CHANNEL_COMPANY,ttt.SYSTEM_MODEL

;

-- 59 733051

-- set params=['2016-09-01','2016-09-30 23:59:59','2016-09-01','2016-09-30 23:59:59'];
-- 前两个参数为发生行为起始时间，后两个参数为留存行为起始时间
select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@param0,'~',@param1),'官方新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t where t.charge_method ='APP'
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method='APP'
where 
tc.CRT_TIME >=@param2
and tc.CRT_TIME <=@param3
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)
union all
select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
-- inner join forum.t_user u on u.USER_ID= tu.user_id and u.CLIENT_ID='BYAPP' and u.crt_time>=@param0 and u.crt_time<=@param1
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t -- where t.charge_method ='APP'
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
) tt on td.charge_user_id = tt.charge_user_id 
and td.charge_method='APP'
where td.CRT_TIME >=@param2
and td.CRT_TIME <=@param3
and td.charge_user_id not in (select user_id from t_user_merchant)
and td.charge_user_id not in (select user_id from v_user_boss)

) ttt
group by ttt.CHANNEL_COMPANY,ttt.SYSTEM_MODEL
;

-- 461 101947
-- set params=['2016-09-01','2016-09-30 23:59:59','2016-09-01','2016-09-30 23:59:59'];
-- 前两个参数为发生行为起始时间，后两个参数为留存行为起始时间
select ttt.channel_company,ttt.SYSTEM_MODEL,concat(@param0,'~',@param1),'总新增充值人数以及金额',count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
) tt on tc.charge_user_id = tt.charge_user_id 
where 
tc.CRT_TIME >=@param2
and tc.CRT_TIME <=@param3
and tc.charge_user_id not in (select user_id from t_user_merchant)
and tc.charge_user_id not in (select user_id from v_user_boss)

union all

select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from t_trans_user_recharge_diamond td
inner join t_trans_user_attr tu on td.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
inner join (
select * from (
select * from (
select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
union all
select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t
) tt order by tt.crt_time asc ) t
group by t.charge_user_id ) tt where tt.crt_time>=@param0 and tt.crt_time<=@param1
) tt on td.charge_user_id = tt.charge_user_id 
where td.CRT_TIME >=@param2
and td.CRT_TIME <=@param3
and td.charge_user_id not in (select user_id from t_user_merchant)
and td.charge_user_id not in (select user_id from v_user_boss)
) ttt
group by CHANNEL_COMPANY,ttt.SYSTEM_MODEL;

-- 498 798061



