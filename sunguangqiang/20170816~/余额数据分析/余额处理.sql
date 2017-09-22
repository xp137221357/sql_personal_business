set @param1='2017-09-11 00:00:00';
truncate v_account_item0909;
truncate v_account_item090901;
truncate v_account_item090902;
truncate v_account_item090903;
truncate v_account_item090904;
truncate v_account_translog090901;


insert into v_account_item0909
select * from v_account_item090901;


insert into v_account_item0909
select * from v_account_item090902;

insert into v_account_item0909
select * from v_account_item090903;

insert into v_account_item0909
select * from v_account_item090904;

insert into v_account_item0909
select * from v_account_translog090901;


update v_account_item0909 t
set t.user_code = replace(t.user_code,'_','');


select sum(t.coin_balance),sum(t.coin_freeze) from v_account_item0909 t 

select *
from v_account_item0909 t
left join forum.t_user u on t.user_code=u.USER_CODE;

select count(1),sum(t.coin_balance),sum(t.coin_freeze) from v_account_item090901 t;

select count(1),sum(t.coin_balance),sum(t.coin_freeze) from v_account_translog090901 t;

-- 充值用户 -- 
余额：431325651.58
冻结：187672410.00
select sum(v.coin_balance),sum(v.coin_freeze) from  report.v_account_item0909 v
inner join forum.t_user u on v.user_code=u.USER_CODE
inner join (
	select t.USER_ID from (
	select t.USER_ID from t_stat_app_recharge_user_app_20170911 t
	union all
	select t.USER_ID from t_stat_app_recharge_user_third_20170911 t
	) t group by t.user_id
) t on t.user_id=u.USER_ID;

-- 冻结用户
余额：124841151.43
冻结：44080.00
select sum(v.coin_balance),sum(v.coin_freeze) from forum.t_user u 
inner join report.v_account_item0909 v on u.USER_CODE=v.user_code
where u.`STATUS`!=10 and u.CLIENT_ID='BYAPP'
and u.CRT_TIME<@param1;

-- 未充值用户 
余额：157813027.81
冻结：118769.00
select sum(t.coin_balance),sum(t.coin_freeze) from t_no_recharge_user_balance20170911 t;

-- 系统用户 --
余额：23730308.25 
冻结： 0
select sum(v.coin_balance),sum(v.coin_freeze) from report.t_user_system t 
inner join report.v_account_item0909 v on t.USER_CODE=v.user_code;

-- 第三方用户 -- 
余额：327777894.69 
冻结：0
select sum(v.coin_balance),sum(v.coin_freeze) from report.t_user_merchant t 
inner join report.v_account_item0909 v on t.USER_CODE=v.user_code;

-- 非用户表用户 -- 
余额：829179.00
冻结：604548.00
select 
sum(v.coin_balance),sum(v.coin_freeze)
from v_account_item0909 v
left join forum.t_user u on v.user_code=u.USER_CODE
where u.USER_CODE is null; 


SELECT 431325651.58+124841151.43+157813027.81+23730308.25 +327777894.69 +829179.00;
SELECT 187672410.00+44080.00+118769.00+0+0+604548.00;


-- 账务-静态数据(2017.09.11 12点后账务未变动)
余额：839952827.4
冻结：92478805

-- 账务-动态数据(2017.09.11 12点后账务有变动)
余额：226364185.4
冻结：95961002

运营后台:1072666325

差额:839952827.4+226364185.4-1072666325=-6349312.2;






