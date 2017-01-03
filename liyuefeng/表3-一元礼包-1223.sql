## 8月31日-9月10日充值1元礼包的用户
set @param0='2016-12-12';
set @param1='2016-12-18 23:59:59';

set @param2='2016-12-19';
set @param3='2016-12-25 23:59:59';

# 目标用户(未充值1元礼包人数)
select '目标用户',null  value1,
count(distinct u.USER_ID) value2 
from forum.t_user u
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null

union all

# 启动过app的用户数
select '启动过app的用户数',null  value1,count(distinct u.USER_ID) value2 from report.t_device_statistic di 
inner join forum.t_user u on di.USER_CODE=u.USER_CODE
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
and di.STAT_TYPE = 1
and di.ACT_DATE >= @param2
and di.ACT_DATE <= @param3

union all

# 充值金币金额以及人数（含第三方）
select '充值金币人数（含第三方）', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
inner join forum.t_user u on urc.charge_user_id=u.USER_ID
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
and urc.crt_time >= @param2
and urc.crt_time <= @param3

union all

# 投注人数 & 投注金币
select '投注人数以及投注金币',count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) from game.t_order_item oi 
inner join forum.t_user u on oi.USER_ID=u.USER_CODE
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
and oi.PAY_TIME >= @param2
and oi.PAY_TIME <= @param3

union all

# 充值钻石人数与金额
select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from report.t_trans_user_recharge_diamond urc 
inner join forum.t_user u on urc.charge_user_id=u.USER_ID
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
and urc.crt_time >= @param2
and urc.crt_time <= @param3

/*
# 充值金币人数与金额
select '充值金币人数与金额',sum(ai.CHANGE_VALUE), count(distinct urc.user_id) from report.t_stat_first_recharge_coin urc inner join 
forum.t_acct_items ai
on urc.user_id = ai.USER_ID
 where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME < @param1
and urc.crt_time >= @param2
and urc.crt_time <= @param3;
*/