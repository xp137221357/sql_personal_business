

set @param0='2017-01-07';

INSERT INTO t_user_silent_20170207
select oi.USER_ID from game.t_order_item oi 
where oi.CRT_TIME>=@param0
group by oi.USER_ID
;


CREATE TABLE `t_user_silent_20170207_temp` (
	`USER_ID` VARCHAR(50) NOT NULL,
	UNIQUE INDEX `USER_ID` (`USER_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


insert into t_user_silent_20170207_temp
select u.USER_ID from forum.t_user u 
left join test.t_user_silent_20170207 ts on u.USER_CODE=ts.USER_CODE
where ts.USER_CODE is null
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10;

CREATE TABLE `t_user_silent_aftervalue_20170207` (
	`USER_ID` bigint(19) NOT NULL,
	`after_value` DOUBLE NOT NULL,
	UNIQUE INDEX `USER_ID` (`USER_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

insert into t_user_silent_aftervalue_20170207
select 
t.USER_ID,t.AFTER_VALUE 
from (
select ai.USER_ID,ai.AFTER_VALUE
from forum.t_acct_items ai 
inner join test.t_user_silent_20170207_temp ts on ai.USER_ID=ts.USER_ID
where ai.ACCT_TYPE=1001 
and ai.ITEM_STATUS=10
order by ai.ADD_TIME desc 
)t group by t.USER_ID 
;


select sum(tt.after_value) from t_user_silent_aftervalue_20170207 tt;