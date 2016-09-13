
##下注金额和人数

select 
t1.stat_time,
ifnull(sum(t1.recharge_counts),0) recharge_counts,
ifnull(sum(t1.recharge_coins),0) recharge_coins,
ifnull(sum(t1.bet_counts),0) bet_counts,
ifnull(sum(t1.bet_oders),0) bet_oders,
ifnull(sum(t1.bet_coins),0) bet_coins,
ifnull(sum(t1.prize_counts),0) prize_counts,
ifnull(sum(t1.prize_oders),0) prize_oders,
ifnull(sum(t1.prize_coins),0) prize_coins,
t2.reg_counts
from
(
SELECT 
DATE(s.ADD_TIME) stat_time,
if(s.ITEM_EVENT='BUY_DIAMEND',COUNT(distinct u.USER_ID),0) recharge_counts,
if(s.ITEM_EVENT='BUY_DIAMEND',round(SUM(s.CHANGE_VALUE)),0) recharge_coins,
if(s.ITEM_EVENT='TRADE_COIN',COUNT(distinct u.USER_ID),0) bet_counts,
if(s.ITEM_EVENT='TRADE_COIN',COUNT(u.USER_ID),0) bet_oders,
if(s.ITEM_EVENT='TRADE_COIN',round(SUM(s.CHANGE_VALUE)),0) bet_coins,
if(s.ITEM_EVENT='PRIZE_COIN',COUNT(distinct u.USER_ID),0) prize_counts,
if(s.ITEM_EVENT='PRIZE_COIN',COUNT(u.USER_ID),0) prize_oders,
if(s.ITEM_EVENT='PRIZE_COIN',round(SUM(s.CHANGE_VALUE)),0) prize_coins
FROM T_USER_SHANGDONG ts
INNER JOIN forum.t_user u ON ts.USER_ID=u.user_id
INNER JOIN forum.t_acct_items s 
ON u.USER_ID=s.USER_ID 
AND s.ITEM_STATUS=10 
AND s.ITEM_EVENT in ('TRADE_COIN','PRIZE_COIN','BUY_DIAMEND')
INNER JOIN t_trans_user_attr tu on u.user_id=tu.USER_ID and tu.CHANNEL_NO 
not in ('BY','TD','baidu','qq','jrtt','jrtt1','jrtt2','jrtt3','jrtt4','jrtt5','jrtt6','jrtt7','jrtt8','jrtt9','jrtt10','jrtt11')
WHERE DATE(s.ADD_TIME)>=@beginTime
AND DATE(s.ADD_TIME)<@endTime
GROUP BY DATE(s.ADD_TIME),s.ITEM_EVENT
) t1
left join (
SELECT  
DATE(u.CRT_TIME) stat_time, 
COUNT(DISTINCT(u.USER_ID)) reg_counts
FROM T_USER_SHANGDONG ts
INNER JOIN forum.t_user u ON ts.USER_ID=u.user_id and u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime
INNER JOIN t_trans_user_attr tu on u.user_id=tu.USER_ID and tu.CHANNEL_NO 
not in ('BY','TD','baidu','qq','jrtt','jrtt1','jrtt2','jrtt3','jrtt4','jrtt5','jrtt6','jrtt7','jrtt8','jrtt9','jrtt10','jrtt11')
GROUP BY DATE(u.CRT_TIME)
) t2 on t1.stat_time=t2.stat_time
group by t1.stat_time;

##派奖金额和人数
SELECT
'派奖金额和人数',
DATE(s.ADD_TIME) '日期', 
COUNT(distinct(u.USER_ID)) '中奖人数',
COUNT(*) '中奖单数',
round(SUM(s.CHANGE_VALUE))'派奖金额'
FROM test.T_USER_SHANGDONG a
INNER JOIN forum.t_user u ON a.USER_ID=u.user_id
INNER JOIN forum.t_acct_items s ON u.USER_ID=s.USER_ID AND s.ITEM_STATUS=10 AND s.ITEM_EVENT='PRIZE_COIN'
INNER JOIN forum.t_user_event e on u.user_id=e.USER_ID and e.EVENT_CODE ='REG' and e.CHANNEL_NO not in ('BY','TD','baidu','qq','jrtt','jrtt1','jrtt2','jrtt3','jrtt4','jrtt5','jrtt6','jrtt7','jrtt8','jrtt9','jrtt10','jrtt11')
WHERE DATE(s.ADD_TIME)>=@beginTime
AND DATE(s.ADD_TIME)<@endTime
GROUP BY DATE(s.ADD_TIME);

##充值金额和人数
SELECT 
'充值金额和人数',
DATE(s.ADD_TIME) '日期', 
COUNT(distinct u.USER_ID) '充值人数',
COUNT(*) '充值次数',
round(SUM(s.COST_VALUE)) '充值金额'
FROM test.T_USER_SHANGDONG a
INNER JOIN forum.t_user u ON a.USER_ID=u.user_id
INNER JOIN forum.t_acct_items s ON u.USER_ID=s.USER_ID AND s.ITEM_STATUS=10 AND s.ITEM_EVENT='BUY_DIAMEND'
INNER JOIN forum.t_user_event e on u.user_id=e.USER_ID and e.EVENT_CODE ='REG' and e.CHANNEL_NO not in ('BY','TD','baidu','qq','jrtt','jrtt1','jrtt2','jrtt3','jrtt4','jrtt5','jrtt6','jrtt7','jrtt8','jrtt9','jrtt10','jrtt11')
WHERE DATE(s.ADD_TIME)>=@beginTime
AND DATE(s.ADD_TIME)<@endTime
GROUP BY DATE(s.ADD_TIME);
## 新注册
SELECT  
'新注册人数',
DATE(u.CRT_TIME) '日期', 
COUNT(DISTINCT(A.USER_ID)) '注册人数'
FROM test.T_USER_SHANGDONG a
INNER JOIN forum.t_user u ON a.USER_ID=u.user_id
INNER JOIN forum.t_user_event e on u.user_id=e.USER_ID and e.EVENT_CODE ='REG' and e.CHANNEL_NO not in ('BY','TD','baidu','qq','jrtt','jrtt1','jrtt2','jrtt3','jrtt4','jrtt5','jrtt6','jrtt7','jrtt8','jrtt9','jrtt10','jrtt11')
WHERE DATE(u.CRT_TIME)>=@beginTime
AND DATE(u.CRT_TIME)<@endTime and u.`STATUS` =10
GROUP BY DATE(u.CRT_TIME);
