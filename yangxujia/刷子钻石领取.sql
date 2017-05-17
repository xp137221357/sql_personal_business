

set @param0 = '2017-03-06'; 
set @param1 = '2017-03-12 23:59:59';

select count(distinct ai.user_id),sum(ai.CHANGE_VALUE) from forum.t_user_event e 
inner join (
select e.DEVICE_CODE,count(1) counts from forum.t_user_event e
where e.EVENT_CODE='reg' and e.CRT_TIME>=@param0 and e.CRT_TIME<=@param1
and e.CHANNEL_NO='qq'
group by e.DEVICE_CODE
) t on e.CRT_TIME>=@param0 and e.CRT_TIME<=@param1 and t.counts>3 and e.DEVICE_CODE=t.DEVICE_CODE and e.EVENT_CODE='reg' and e.CHANNEL_NO='qq'
inner join forum.t_acct_items ai where ai.ADD_TIME>=@param0 and ai.ADD_TIME<=@param1 and ai.USER_ID=e.USER_ID
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT='get_free_coin'
and ai.ACCT_TYPE=1003;


select * from forum.t_


inner join forum.t_match_recom t 
inner join forum.t_user_match_recom tt on t.RECOM_ID=tt.RECOM_ID

select * from t_user_match_recom t limit 10;


select count(distinct user_id) from forum.t_user_event e 
where e.CRT_TIME>=@param0 and e.CRT_TIME<=@param1 
and e.EVENT_CODE='reg' and e.CHANNEL_NO='qq'


select u.NICK_NAME,tt.USER_ID,count(t.USER_ID) from forum.t_user_event e 
inner join forum.t_user_match_recom t on e.USER_ID=t.USER_ID and t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1
inner join forum.t_match_recom tt on t.RECOM_ID=tt.RECOM_ID 
inner join forum.t_user u on tt.user_id =u.USER_ID
where e.CRT_TIME>=@param0 and e.CRT_TIME<=@param1 
and e.EVENT_CODE='reg' and e.CHANNEL_NO='qq'
group by tt.USER_ID
;

-- 2074050,2084517,2153256,2237364

select * from t_match_recom t where t.USER_ID in (2074050,2084517,2153256,2237364);


select * from forum.t_match_recom t where t;



select * from forum.t_expert t where t.USER_ID in (2074050,2084517,2153256,2237364);


select * from t_expert_type_ref t where t.USER_ID in (2074050,2084517,2153256,2237364);


set @param0 = '2017-03-13'; 
set @param1 = '2017-03-13 23:59:59';

select count(distinct tu.USER_ID) '充值人数',sum(tc.coins) '金币',sum(tc.rmb_value) '人民币' from report.t_trans_user_recharge_coin tc
inner join report.t_trans_user_attr tu 
on tc.charge_user_id=tu.USER_ID
and tu.CHANNEL_NO='qq'
and tu.CRT_TIME>@param0
and tu.CRT_TIME<=@param1
and tc.CRT_TIME>@param0
and tc.CRT_TIME<=@param1;


select e.DEVICE_CODE,tc.* from report.t_trans_user_recharge_coin tc
inner join forum.t_user_event e on e.USER_ID=tc.charge_user_id and e.EVENT_CODE='reg' and e.CHANNEL_NO='qq'
and tc.CRT_TIME>@param0
and tc.CRT_TIME<=@param1
and tc.rmb_value=1;


-- 按渠道分类
select e.CHANNEL_NO,td.CHANNEL_NAME,count(ai.USER_ID) 
from forum.t_acct_items ai 
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg' -- and e.CHANNEL_NO='qq'
left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO 
inner join forum.t_third_pay_log t on ai.TRADE_NO=t.OUT_TRADE_NO 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
group by e.CHANNEL_NO;




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




select ai.USER_ID,t.appid,t.open_id
from forum.t_acct_items ai 
inner join forum.t_user_event e on e.USER_ID=ai.USER_ID and e.EVENT_CODE='reg' and e.CHANNEL_NO='qq'
left join report.t_device_channel td on td.CHANNEL_NO=e.CHANNEL_NO 
inner join forum.t_third_pay_log t on ai.TRADE_NO=t.OUT_TRADE_NO 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
;






2145771,2442297,2370717,1934421,3585804,2347785,2373636




set @param0 = '2016-12-01'; 
set @param1 = '2017-03-14 23:59:59';

select * from (
select u.status,u.NICK_NAME,ai.USER_ID,sum(ai.CHANGE_VALUE) coins,count(1),max(ai.CHANGE_VALUE),min(ai.CHANGE_VALUE)
from forum.t_acct_items ai 
inner join forum.t_user u on u.user_id=ai.USER_ID
where ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
and ai.ITEM_EVENT='PACKET_RECIVE'
group by ai.USER_ID
) t order by t.coins desc
;



set @param0 = '2017-03-08'; 
set @param1 = '2017-03-13 23:59:59';

select ai.user_id,ai.CHANGE_VALUE,ti.RECIVE_USER,u.NICK_NAME,u.USER_ID,ti.CRT_TIME from (
select ai.USER_ID
from forum.t_acct_items ai 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
) t 
inner join forum.t_acct_items ai on t.user_id =ai.USER_ID and ai.ADD_TIME>=@param0 and ai.ITEM_EVENT='ROOM_PACKET_TRADE'
left join game.t_packets tp on ai.ACCT_ID=tp.USER_ID and tp.CRT_TIME>=@param0
left join game.t_packet_item ti on tp.ID=ti.PACKET_ID and ti.CRT_TIME>=@param0
left join forum.t_user u on u.user_code=ti.RECIVE_USER;


-- 红包派发和领取

set @param0 = '2017-03-01'; 
set @param1 = '2017-03-13 23:59:59';

select ai.user_id,ti.RECIVE_USER,u.NICK_NAME,u.USER_ID from (
select ai.USER_ID
from forum.t_acct_items ai 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE=1
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%'
) t 
inner join forum.t_acct_items ai on t.user_id =ai.USER_ID and ai.ADD_TIME>=@param0 and ai.ITEM_EVENT='ROOM_PACKET_TRADE'
inner join game.t_packets tp on ai.ACCT_ID=tp.USER_ID and tp.CRT_TIME>=@param0
inner join game.t_packet_item ti on tp.ID=ti.PACKET_ID and ti.CRT_TIME>=@param0
inner join forum.t_user u on u.user_code=ti.RECIVE_USER
and ai.CHANGE_VALUE=2000;



-- yihuode

select u1.NICK_NAME,t1.ip,u2.NICK_NAME,t2.ip from (
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in (2145771,2442297,2370717,1934421,3585804,2347785,2373636)
group by e.USER_ID,e.IP
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in (2145771,2442297,2370717,1934421,3585804,2347785,2373636)
group by e.USER_ID,e.IP
) t2 on t1.user_id !=t2.user_id and substr(t1.IP,1,6) =substr(t2.IP,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id

group by u1.USER_ID,u2.USER_ID





