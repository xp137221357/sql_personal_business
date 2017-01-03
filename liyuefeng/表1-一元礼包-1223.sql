# select distinct ai.APP_TYPE from t_acct_items ai where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' limit 10;


## 激活设备数
set @param0:='2016-12-12';
set @param1:='2016-12-18 23:59:59';
select '激活设备数',null  value1,count(1) value2 from forum.t_device_info di 
inner join forum.t_user u on u.USER_CODE = di.USER_CODE
LEFT JOIN forum.t_user_freeze_log t  ON u.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null AND di.ADD_TIME >= @param0 and di.ADD_TIME < @param1 and di.DEVICE_STATUS != -10

union all

# 新增注册用户数
select '新增注册用户数',null  value1,count(distinct u.user_id) from forum.t_user u 
inner join forum.t_user_event ue on ue.USER_ID=u.USER_ID and ue.EVENT_PARAM like '%mobile_brand%' 
LEFT JOIN forum.t_user_freeze_log t  ON u.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null AND  u.CRT_TIME >= @param0 and u.CRT_TIME <= @param1

union all

# 充值1元礼包人数
select '充值1元礼包人数',null  value1,count(distinct ai.USER_ID) from forum.t_acct_items ai 
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1

union all

# 总充值人数及金额(含第三方）
select '总充值人数及金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
inner join 
forum.t_acct_items ai
on urc.charge_user_id = ai.USER_ID
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS not like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
and urc.crt_time >= @param0 and urc.crt_time <= @param1
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

# 投注人数以及投注金币
select '投注人数以及投注金币',count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) from game.t_order_item oi inner join 
forum.t_acct_items ai
on oi.USER_ID = ai.ACCT_ID
 and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

/*
-- 领取人数以及数量
select concat(@param0,'~',@param1)  '日期', count(t.user_id) '领取人数',count(t.user_id) '领取数量' 
from forum.t_acct_items t 
inner join report.t_trans_user_attr tu on t.USER_ID = tu.USER_ID
and t.item_event ='FREE_RECOM_COUPON' 
and t.ACCT_TYPE in (100,104)
and t.item_status=10
and t.add_time >= @param0
and t.add_time<= @param1
LEFT JOIN forum.t_user_freeze_log tt  ON t.USER_ID=tt.USER_ID AND tt.reason like '%一元活动(刷子)%' and tt.OPT_USER='sys'
where Tt.USER_ID is null
-- group by tu.SYSTEM_MODEL
;*/

-- 使用人数以及次数
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
-- group by tu.SYSTEM_MODEL
union all


# 充值钻石人数与金额
select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from report.t_trans_user_recharge_diamond urc inner join 
forum.t_acct_items ai
on urc.charge_user_id = ai.USER_ID
 and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
and urc.crt_time >= @param0 and urc.crt_time <= @param1
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null;




