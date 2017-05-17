set @param0 = '2017-03-01'; 
set @param1 = '2017-03-31 23:59:59';
set @param2 = 'qq';


-- 红包明细表     
-- game.t_packet_item
-- pk场刷子      
-- game.t_clubs_order


select ai.ITEM_EVENT,ai.CHANGE_TYPE,count(distinct ai.user_id) '人数',count(1) '次数',round(sum(ai.CHANGE_VALUE))
from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS in (10,-10)
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
group by ai.ITEM_EVENT,ai.CHANGE_TYPE;

	
select * from (
select ai.USER_ID,ai.ITEM_ID,ai.PAY_TIME,ai.ITEM_EVENT,ai.CHANGE_VALUE,ai.AFTER_VALUE
from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS in (10,-10)
and ai.ITEM_EVENT in('ROOM_PACKET_TRADE','PK_TRADE_COIN_USER')
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
order by ai.ITEM_ID desc
) t 
where t.AFTER_VALUE<10
group by t.USER_ID;



select o.RECIVE_USER '接收人',round(sum(t.TOTAL_MONEY)) '接收金额',count(DISTINCT t.USER_ID) '发送人数',count(1) '发送次数' from game.t_packet_item o
inner join game.t_packets t on o.PACKET_ID=t.ID 
where o.CRT_TIME>=@param0
and o.CRT_TIME<=@param1
and t.USER_ID in(
   select ai.ACCT_ID
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
group by o.RECIVE_USER;


select ai.user_id,u.NICK_NAME
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('CP_TRADE')
and ai.ITEM_STATUS in (10,-10)
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
group by ai.user_id;


select sum(t.coins) from (
select u.NICK_NAME,count(1) '提现次数',sum(t.coins) coins from report.t_trans_user_withdraw t 
inner join forum.t_user u on t.USER_ID=u.USER_ID
and t.user_id in (
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
where t.crt_time>=@param0
group by t.user_id
) t;






