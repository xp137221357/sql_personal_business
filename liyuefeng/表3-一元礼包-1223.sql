set @param0='2017-01-02';
set @param1='2017-01-08 23:59:59';

set @param2='2017-01-09';
set @param3='2017-01-15 23:59:59';

-- set param=['2017-01-02','2017-01-08 23:59:59','2017-01-09','2017-01-15 23:59:59'];

# 目标用户(未充值1元礼包人数)
select '目标用户',null  value1,
count(distinct u.USER_ID) value2 
from forum.t_user u
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null

union all

# 启动过app的用户数
select '启动过app的用户数',null  value1,count(distinct u.USER_CODE) value2 from report.t_device_statistic di 
inner join 
(
select u.USER_CODE from forum.t_user u 
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
group by u.USER_CODE
) u on di.USER_CODE=u.USER_CODE
and di.STAT_TYPE = 1
and di.ACT_DATE >= @param2
and di.ACT_DATE <= @param3

union all

# 充值金币金额以及人数（含第三方）
select '充值金币人数（含第三方）', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
inner join 
(select u.USER_ID from forum.t_user u 
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
group by u.USER_ID
) u on urc.charge_user_id=u.USER_ID
and urc.crt_time >= @param2
and urc.crt_time <= @param3

union all

# 投注人数 & 投注金币
select '投注人数以及投注金币',count(distinct oi.USER_ID), round(sum(oi.COIN_BUY_MONEY)) from game.t_order_item oi 
inner join 
( select u.USER_CODE from forum.t_user u 
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
group by u.USER_CODE
) u on oi.USER_ID=u.USER_CODE
and oi.PAY_TIME >= @param2
and oi.PAY_TIME <= @param3

union all

# 充值钻石人数与金额
select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from report.t_trans_user_recharge_diamond urc 
inner join 
(select u.USER_ID from forum.t_user u 
LEFT JOIN forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' and ai.ITEM_STATUS=10
LEFT JOIN forum.t_user_freeze_log t  ON ai.USER_ID=T.USER_ID AND t.reason like '%一元活动(刷子)%' and t.OPT_USER='sys'
where u.CRT_TIME>=@param0 and u.CRT_TIME<=@param1 and t.USER_ID is null and ai.USER_ID is null
group by u.USER_ID
) u on urc.charge_user_id=u.USER_ID
and urc.crt_time >= @param2
and urc.crt_time <= @param3
