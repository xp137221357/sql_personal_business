
-- 当天
select * from report.t_job t where t.job_name like '%t_rpt_overview%' AND  t.job_name like '%兑换游戏币%';

insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 1 period_type,
       DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= curdate()
             AND tc.CRT_TIME < date_add(curdate(), INTERVAL 1 DAY)     
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= curdate()
             AND ai.PAY_TIME < date_add(curdate(), INTERVAL 1 DAY)                 
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;


-- 前一天
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 1 period_type,
       DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(curdate(), INTERVAL -1 DAY) 
             AND tc.CRT_TIME < curdate()  
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(curdate(), INTERVAL -1 DAY) 
             AND ai.PAY_TIME < curdate()                 
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;

-- 当周
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 2 period_type,
       DATE_FORMAT(ai.PAY_TIME, '%x%v'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(curdate(),interval -weekday(curdate()) day)
             AND tc.CRT_TIME < date_add(curdate(),interval -weekday(curdate())+7 day)
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(curdate(),interval -weekday(curdate()) day)
             AND ai.PAY_TIME < date_add(curdate(),interval -weekday(curdate())+7 day)              
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;


-- 上一周
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 2 period_type,
       DATE_FORMAT(ai.PAY_TIME, '%x%v'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(curdate(),interval -weekday(curdate())-7 day)
             AND tc.CRT_TIME < date_add(curdate(),interval -weekday(curdate()) day)
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(curdate(),interval -weekday(curdate())-7 day)
             AND ai.PAY_TIME < date_add(curdate(),interval -weekday(curdate()) day)              
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;


-- 当月
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 3 period_type,
       DATE_FORMAT(date_add(now(), interval 0-(date_format(now(),'%i'))%10 minute), '%Y-%m-%d %H:%i:00'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(date_add(last_day(curdate()),interval 1 day),interval -1 month)
             AND tc.CRT_TIME < date_add(last_day(curdate()),interval 1 day)
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(date_add(last_day(curdate()),interval 1 day),interval -1 month)
             AND ai.PAY_TIME < date_add(last_day(curdate()),interval 1 day)           
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;


-- 上一个月
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 3 period_type,
       DATE_FORMAT(date_add(now(), interval 0-(date_format(now(),'%i'))%10 minute), '%Y-%m-%d %H:%i:00'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(date_add(last_day(curdate()),interval 1 day),interval -2 month)
             AND tc.CRT_TIME < date_add(date_add(last_day(curdate()),interval 1 day),interval -1 month)
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(date_add(last_day(curdate()),interval 1 day),interval -2 month)
             AND ai.PAY_TIME < date_add(date_add(last_day(curdate()),interval 1 day),interval -1 month)        
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;


-- 当前10分钟
insert into t_rpt_overview (period_type,period_name,device_type,channel_no,app_version,first_bdiamond_unum,first_bdiamond_amount) 
SELECT 4 period_type,
       DATE_FORMAT(date_add(now(), interval 0-(date_format(now(),'%i'))%10 minute), '%Y-%m-%d %H:%i:00'),
       IFNULL(e.SYSTEM_MODEL, '') device_type,
       IFNULL(e.CHANNEL_NO, '') channel_no,
       IFNULL(e.APP_VERSION, '') app_version,
       count(DISTINCT u.user_id) first_bdiamond_unum,
       ifnull(sum(ai.COST_VALUE), 0) AS first_bdiamond_amount
  FROM forum.t_user u
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID AND e.EVENT_CODE = 'REG'
       INNER JOIN report.t_stat_first_recharge_dmd tc on u.user_id =tc.user_id
             AND tc.CRT_TIME >= date_add(now(), interval 0-(date_format(now(),'%i'))%10 - 10 minute)
             AND tc.CRT_TIME < date_add(now(), interval 0-(date_format(now(),'%i'))%10 minute)
       INNER JOIN forum.t_acct_items ai
             ON  ai.USER_ID = tc.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'BUY_DIAMEND'
             AND ai.ACCT_TYPE=1003
             AND ai.COMMENTS not like '%"buy_coin":1%'
             AND ai.ITEM_SRC!=10
             AND ai.PAY_TIME >= date_add(now(), interval 0-(date_format(now(),'%i'))%10 - 10 minute)
             AND ai.PAY_TIME < date_add(now(), interval 0-(date_format(now(),'%i'))%10 minute)          
 WHERE u.CLIENT_ID = 'BYAPP' 
GROUP BY DATE_FORMAT(ai.PAY_TIME, '%Y-%m-%d'),
         IFNULL(e.SYSTEM_MODEL, ''),
         IFNULL(e.CHANNEL_NO, ''),
         IFNULL(e.APP_VERSION, '') 
ON DUPLICATE KEY UPDATE 
period_type=VALUES(period_type) ,
period_name=VALUES(period_name) ,
device_type=VALUES(device_type) ,
channel_no=VALUES(channel_no) ,
app_version=VALUES(app_version) ,
first_bdiamond_unum=VALUES(first_bdiamond_unum) ,
first_bdiamond_amount=VALUES(first_bdiamond_amount) ;




