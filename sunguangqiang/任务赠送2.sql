
-- 任务赠送

set @param0 = '2017-05-01'; 
set @param1 = '2017-06-01';
set @param2 = '5月份';

select  @param2 '时间','总任务赠送',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';


select  @param2 '时间','代理务赠送',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
inner join t_group_partner20170607 tt on ai.user_id=tt.user_id
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';


BEGIN

set @num = 1;

label1: WHILE @num <=12000 Do

insert into t_group_partner20170607(user_id,task_coins)
select  ai.user_id,sum(ai.CHANGE_VALUE) task_coins 
from forum.t_acct_items ai 
inner join t_group_partner20170607 t on ai.user_id=t.user_id and t.ID=@num
and ai.PAY_TIME>=@param0 
and ai.PAY_TIME<@param1
and ai.PAY_TIME>=t.start_time
and ai.PAY_TIME<=t.end_time
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
on duplicate key update 
task_coins = values(task_coins);

SET @num = @num+1;
end while label1;

END


insert into t_group_partner20170607(user_id,task_coins)
select  ai.user_id,sum(ai.CHANGE_VALUE) task_coins 
from forum.t_acct_items ai 
inner join t_group_partner20170607 t on ai.user_id=t.user_id and t.ID=1
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<@param1
and ai.PAY_TIME>=t.start_time
and ai.PAY_TIME<=t.end_time
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
group by ai.USER_ID
on duplicate key update 
task_coins = values(task_coins);


insert into t_group_partner20170607(user_id,task_coins)
select  ai.user_id,sum(ai.CHANGE_VALUE) task_coins 
from forum.t_acct_items ai 
inner join t_group_partner20170607 t on ai.user_id=t.user_id and t.ID=@num
and ai.PAY_TIME>=@param0 
and ai.PAY_TIME<@param1
and ai.PAY_TIME>=t.start_time
and ai.PAY_TIME<=t.end_time
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task'
on duplicate key update 
task_coins = values(task_coins);



update t_group_partner20170607 t 
inner join (
	select  ai.user_id,sum(ai.CHANGE_VALUE) task_coins 
	from forum.t_acct_items ai 
	inner join t_group_partner20170607 t on ai.user_id=t.user_id and t.ID=0
	and ai.PAY_TIME>=@param0 
	and ai.PAY_TIME<@param1
	and ai.PAY_TIME>=t.start_time
	and ai.PAY_TIME<=t.end_time
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.ITEM_EVENT='user_task'
)tt on t.user_id = tt.user_id
set t.task_coins=tt.task_coins
