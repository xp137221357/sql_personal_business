
set @param1='2017-09-09 00:00:00';
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



1055182495	95718427

select count(1),sum(t.coin_balance),sum(t.coin_freeze) from v_account_item0909 t;

select count(1),sum(t.coin_balance),sum(t.coin_freeze) from v_account_item090901 t;

select count(1),sum(t.coin_balance),sum(t.coin_freeze) from v_account_translog090901 t;






