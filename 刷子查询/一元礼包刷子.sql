
set @param0 = '2017-03-27'; 
set @param1 = '2017-03-27 23:59:59';
-- set @param2 = 'qq';

select e.CHANNEL_NO,td.CHANNEL_NAME,count(ai.USER_ID) 
from forum.t_acct_items ai 
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg' 
left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO and td.SYSTEM_MODEL=e.SYSTEM_MODEL
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
group by e.CHANNEL_NO;


select ai.USER_ID
from forum.t_acct_items ai 
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg'  and e.CHANNEL_NO='qq'
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%';

select ai.* from (
select ai.USER_ID
from forum.t_acct_items ai 
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg'  and e.CHANNEL_NO='qq'
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
) t 
inner join forum.t_acct_items ai on t.user_id =ai.USER_ID and ai.ADD_TIME>=@param0
order by ai.user_id,pay_time asc;




-- 设备
select u1.NICK_NAME,t1.DEVICE_CODE,u2.NICK_NAME,t2.DEVICE_CODE from (
select e.USER_ID,e.DEVICE_CODE from forum.t_user_event e
where e.USER_ID in (
	select ai.USER_ID
	from forum.t_acct_items ai 
	where  ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.CHANGE_VALUE=1
	and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
)
group by e.USER_ID,e.DEVICE_CODE
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.DEVICE_CODE from forum.t_user_event e
where e.USER_ID in (
	select ai.USER_ID
	from forum.t_acct_items ai 
	where  ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.CHANGE_VALUE=1
	and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
)
group by e.USER_ID,e.DEVICE_CODE
) t2 on t1.user_id !=t2.user_id and substr(t1.DEVICE_CODE,1,6) =substr(t2.DEVICE_CODE,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id
group by u1.USER_ID,u2.USER_ID;

-- ip

select u1.NICK_NAME,t1.ip,u2.NICK_NAME,t2.ip from (
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in (
	select ai.USER_ID
	from forum.t_acct_items ai 
	where  ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.CHANGE_VALUE=1
	and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
)
group by e.USER_ID,e.IP
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in (
	select ai.USER_ID
	from forum.t_acct_items ai 
	where  ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.CHANGE_VALUE=1
	and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
	)
group by e.USER_ID,e.IP
) t2 on t1.user_id !=t2.user_id and substr(t1.IP,1,6) =substr(t2.IP,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id
group by u1.USER_ID,u2.USER_ID;




select td.CHANNEL_NAME '渠道名',e.CHANNEL_NO '渠道编码',u.NICK_NAME '用户昵称',u.USER_ID'用户ID',date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%S') '注册时间',e.DEVICE_CODE'设备号',e.IP'ip地址'
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg' 
and if(@param2='all',1=1,e.CHANNEL_NO=@param2)
left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO and td.SYSTEM_MODEL=e.SYSTEM_MODEL
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
order by e.CHANNEL_NO;



SELECT *
FROM report.t_sql_query t
WHERE t.sql_function LIKE '%杨%';



select u.NICK_NAME,u.USER_ID,e.DEVICE_CODE 
from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID 
where e.DEVICE_CODE='980ABB07-148C-4A58-B3BF-97705476AB6C'
group by e.USER_ID;



select ai.ITEM_EVENT,ai.CHANGE_TYPE,sum(ai.CHANGE_VALUE) from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.USER_ID in
(
	select ai.USER_ID
	from forum.t_acct_items ai 
	inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg' 
	left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO and td.SYSTEM_MODEL=e.SYSTEM_MODEL 
	where  ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and td.CHANNEL_NO=@param2
	and ai.CHANGE_VALUE=1
	and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
	group by ai.USER_ID
)
group by ai.ITEM_EVENT,ai.CHANGE_TYPE

