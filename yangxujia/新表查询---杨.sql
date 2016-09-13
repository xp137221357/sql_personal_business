-- t_trans_user_recharge_coin  t_trans_user_recharge_diamond
set @beginTime:='2016-06-10 00:00:00';
set @endTime:='2016-07-11 23:59:59';
/*
select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,count(distinct tc.charge_user_id),sum(tc.rmb_value) from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID
inner join forum.t_user u on u.USER_ID = tc.charge_user_id and u.CRT_TIME >=@beginTime and u.CRT_TIME <=@endTime
where tc.CRT_TIME >=@beginTime
and tc.CRT_TIME <=@endTime
group by tu.SYSTEM_MODEL;


select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,count(distinct td.charge_user_id),sum(td.rmb_value) from test.t_trans_user_recharge_diamond td
inner join test.t_trans_user_attr tu on td.charge_user_id = tu.USER_ID 
inner join forum.t_user u on u.USER_ID = td.charge_user_id and u.CRT_TIME >=@beginTime and u.CRT_TIME <=@endTime
where td.CRT_TIME >=@beginTime
and td.CRT_TIME <=@endTime
group by tu.SYSTEM_MODEL;

*/



select ttt.SYSTEM_MODEL,count(distinct ttt.charge_user_id),sum(ttt.rmb_value) from (

select '金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from test.t_trans_user_recharge_coin tc
inner join test.t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID
inner join test.t_stat_first_recharge_coin ttc on ttc.USER_ID = tc.charge_user_id and ttc.CRT_TIME>=@beginTime and ttc.CRT_TIME <=@endTime
where 
tc.CRT_TIME >=@beginTime
and tc.CRT_TIME <=@endTime
and tc.charge_user_id not in (select user_id from test.t_user_merchant)
and tc.charge_user_id not in (select user_id from test.new_user_boss)
-- group by tu.SYSTEM_MODEL

union all

select '钻石',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY,td.charge_user_id,td.rmb_value from test.t_trans_user_recharge_diamond td
inner join test.t_trans_user_attr tu on td.charge_user_id = tu.USER_ID 
inner join test.t_stat_first_recharge_dmd ttd on ttd.USER_ID = td.charge_user_id and ttd.CRT_TIME>=@beginTime and ttd.CRT_TIME <=@endTime
where td.CRT_TIME >=@beginTime
and td.CRT_TIME <=@endTime
and td.charge_user_id not in (select user_id from test.t_user_merchant)
and td.charge_user_id not in (select user_id from test.new_user_boss)
-- group by tu.SYSTEM_MODEL

) ttt

group by ttt.SYSTEM_MODEL




-- select * from t_trans_user_recharge_coin t where t.charge_method!='答题' limit 1000