
/*
#记录山东用户
insert into T_USER_SHANGDONG
select u.user_id from t_mobile_location a
inner join t_user u on a.mobile=u.USER_MOBILE and a.province='山东'
where not exists (select 1 from T_USER_SHANGDONG s  where u.USER_ID=s.user_id) 
*/

##下注金额和人数
SELECT 
'下注金额和人数',
SUM(s.CHANGE_VALUE), COUNT(*), DATE(s.ADD_TIME)
FROM T_USER_SHANGDONG a
INNER JOIN t_user u ON a.USER_ID=u.user_id
INNER JOIN t_acct_items s ON u.USER_ID=s.USER_ID AND s.ITEM_STATUS=10 AND s.ITEM_EVENT='TRADE_COIN'
WHERE DATE(s.ADD_TIME)>='2016-06-01'
GROUP BY DATE(s.ADD_TIME);

##派奖金额和人数
SELECT
'派奖金额和人数',
SUM(s.CHANGE_VALUE), COUNT(*), DATE(s.ADD_TIME)
FROM T_USER_SHANGDONG a
INNER JOIN t_user u ON a.USER_ID=u.user_id
INNER JOIN t_acct_items s ON u.USER_ID=s.USER_ID AND s.ITEM_STATUS=10 AND s.ITEM_EVENT='PRIZE_COIN'
WHERE DATE(s.ADD_TIME)>='2016-06-01'
GROUP BY DATE(s.ADD_TIME);

##充值金额和人数
SELECT 
'充值金额和人数',
SUM(s.COST_VALUE), COUNT(*), DATE(s.ADD_TIME)
FROM T_USER_SHANGDONG a
INNER JOIN t_user u ON a.USER_ID=u.user_id
INNER JOIN t_acct_items s ON u.USER_ID=s.USER_ID AND s.ITEM_STATUS=10 AND s.ITEM_EVENT='BUY_DIAMEND'
WHERE DATE(s.ADD_TIME)>='2016-06-01'
GROUP BY DATE(s.ADD_TIME);
## 新注册
SELECT  
'新注册',
COUNT(*), DATE(u.CRT_TIME)
FROM T_USER_SHANGDONG a
INNER JOIN t_user u ON a.USER_ID=u.user_id
WHERE DATE(u.CRT_TIME)>='2016-06-01'
GROUP BY DATE(u.CRT_TIME);

