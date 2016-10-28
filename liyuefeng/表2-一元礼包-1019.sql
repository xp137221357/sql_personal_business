## 8月31日-9月10日充值1元礼包的用户
set @bt:='2016-10-03';
set @et:='2016-10-09 23:59:59';

set @bt2:='2016-10-10';
set @et2:='2016-10-16 23:59:59';

# 目标用户(充值1元礼包人数)
select '目标用户',concat(@bt,'~',@et)  value1,count(distinct ai.USER_ID) value2 from forum.t_acct_items ai 
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME < @et


union all

# 启动过app的用户数
select '启动过app的用户数',concat(@bt,'~',@et)  value1,count(distinct ai.ACCT_ID) value2 from report.t_device_statistic di inner join 
forum.t_acct_items ai
on di.USER_CODE = ai.ACCT_ID
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME <= @et
and di.STAT_TYPE = 1
and di.ACT_DATE >= @bt2
and di.ACT_DATE <= @et2
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

# 充值金币金额以及人数（含第三方）
select '充值金币人数（含第三方）', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc inner join 
forum.t_acct_items ai
on urc.charge_user_id = ai.USER_ID
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME <= @et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

# 投注人数 & 投注金币
select '投注人数以及投注金币',count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) from game.t_order_item oi inner join 
forum.t_acct_items ai
on oi.USER_ID = ai.ACCT_ID
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME <= @et
and oi.PAY_TIME >= @bt2
and oi.PAY_TIME <= @et2
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null

union all

# 充值钻石人数与金额
select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from report.t_trans_user_recharge_diamond urc inner join 
forum.t_acct_items ai
on urc.charge_user_id = ai.USER_ID
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME <= @et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where T.USER_ID is null;

/*
# 充值金币人数与金额
select '充值金币人数与金额',sum(ai.CHANGE_VALUE), count(distinct urc.user_id) from report.t_stat_first_recharge_coin urc inner join 
forum.t_acct_items ai
on urc.user_id = ai.USER_ID
 where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME < @et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2;
*/