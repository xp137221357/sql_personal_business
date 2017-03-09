set @param0='2017-01-09';
set @param1='2017-01-15 23:59:59';

-- set param=['2017-01-09','2017-01-15 23:59:59'];

select '激活设备数',null  value1,count(1) value2 from forum.t_device_info di 
inner join forum.t_user u on u.USER_CODE = di.USER_CODE
LEFT JOIN forum.t_user_freeze_log t  ON u.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null AND di.ADD_TIME >= @param0 and di.ADD_TIME < @param1 and di.DEVICE_STATUS != -10

union all

select '新增注册用户数',null  value1,count(distinct u.user_id) from forum.t_user u 
inner join forum.t_user_event ue on ue.USER_ID=u.USER_ID and ue.EVENT_CODE='REG' and ue.DEVICE_CODE is not null
LEFT JOIN forum.t_user_freeze_log t  ON u.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null AND  u.CRT_TIME >= @param0 and u.CRT_TIME <= @param1

union all

select '充值1元礼包人数',null  value1,count(distinct ai.USER_ID) from forum.t_acct_items ai 
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1

union all

select '充值一元礼包并充值其他方式人数及金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
left join 
(select ai.USER_ID from 
forum.t_acct_items ai
where 
ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS like '%ACT_YYLB%' and ai.ITEM_STATUS=10
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
group  by ai.USER_ID
) ai on urc.charge_user_id = ai.USER_ID 
left join 
(select ai.USER_ID from 
forum.t_acct_items ai
where 
ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS not like '%ACT_YYLB%' and ai.ITEM_STATUS=10
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
group  by ai.USER_ID
) aii on urc.charge_user_id = aii.USER_ID 
LEFT JOIN 
forum.t_user_freeze_log t  ON urc.charge_user_id=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where urc.crt_time >= @param0 and urc.crt_time <= @param1 
and ai.USER_ID is not null and aii.USER_ID is not null and t.USER_ID is null

union all


select '非充值一元礼包但充值其他方式人数及金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
left join 
(select ai.USER_ID from 
forum.t_acct_items ai
where 
ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS like '%ACT_YYLB%' and ai.ITEM_STATUS=10
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
group  by ai.USER_ID
) ai on urc.charge_user_id = ai.USER_ID 
LEFT JOIN 
forum.t_user_freeze_log t  ON urc.charge_user_id=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where urc.crt_time >= @param0 and urc.crt_time <= @param1 
and ai.USER_ID is null and t.USER_ID is null

union all

select '投注人数以及投注金币',count(distinct oi.USER_ID), round(sum(oi.COIN_BUY_MONEY)) from game.t_order_item oi 
inner join 
(select ai.ACCT_ID,ai.USER_ID from  forum.t_acct_items ai
where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
group by ai.USER_ID
) ai on oi.USER_ID = ai.ACCT_ID
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

select '使用人数以及次数', count(distinct t.user_id) '使用人数' ,count(t.user_id) '使用次数' 
from forum.t_acct_items t 
inner join report.t_trans_user_attr tu on t.USER_ID = tu.USER_ID
and t.item_event ='BUY_RECOM' 
and t.ACCT_TYPE in (100,104)
and t.item_status=10
and t.add_time >=@param0
and t.add_time<= @param1
LEFT JOIN forum.t_user_freeze_log tt  ON tt.USER_ID=T.USER_ID AND tt.reason like '%一元活动(刷子)%' and tt.OPT_USER='sys'
where Tt.USER_ID is null

union all

select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from report.t_trans_user_recharge_diamond urc 
inner join 
(select ai.USER_ID from forum.t_acct_items ai
where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
group by ai.USER_ID
) ai on urc.charge_user_id = ai.USER_ID
and urc.crt_time >= @param0 and urc.crt_time <= @param1
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null