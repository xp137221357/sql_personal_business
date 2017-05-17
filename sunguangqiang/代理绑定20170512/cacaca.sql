CREATE TABLE `t_agent0_20170516_01` (
	`user_id` BIGINT(19) NOT NULL DEFAULT '1',
	PRIMARY KEY (`user_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


insert into t_agent0_20170516
select * from (
select t1.user_id from  t_agent0_20170512_01 t1
inner join forum.t_user u on u.USER_ID=t1.user_id and u.CLIENT_ID='byapp' and u.`STATUS`=10

union all

select t1.user_id from  t_agent0_20170512_02 t1
inner join forum.t_user u on u.USER_ID=t1.user_id and u.CLIENT_ID='byapp' and u.`STATUS`=10

union all

select t1.user_id from  t_agent0_20170512_03 t1
inner join forum.t_user u on u.USER_ID=t1.user_id and u.CLIENT_ID='byapp' and u.`STATUS`=10

union all

select t1.user_id from  t_agent0_20170512_04 t1
inner join forum.t_user u on u.USER_ID=t1.user_id and u.CLIENT_ID='byapp' and u.`STATUS`=10

) t group by t.user_id
;



select count(distinct t.user_id) from (
select t1.user_id from  t_agent1_20170512_01 t1
union all
select t1.user_id from  t_agent1_20170512_02 t1
union all
select t1.user_id from  t_agent1_20170512_03 t1
union all
select t1.user_id from  t_agent1_20170512_04 t1
) t 


set @param0='2017-01-01';
set @param1='2017-05-01';
set @param2='2017-05-01';
set @param3='2017-05-16';

insert into t_agent0_20170516_01
select t1.user_id from (
select t.user_id from t_agent0_20170516 t 
left join t_agent1_20170512_01 t1 on t.user_id = t1.user_id
where t1.user_id is null
) t1
inner join forum.t_acct_items ai on ai.USER_ID=t1.user_id
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
group by t1.user_id



select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.ACCT_NUM '会员号' from t_agent0_20170516_01 t1 
inner join forum.t_user u on t1.user_id=u.USER_ID
left join forum.t_acct_items ai on ai.USER_ID=t1.user_id
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
and ai.PAY_TIME>=@param2
and ai.PAY_TIME<@param3
where ai.USER_ID is null;





