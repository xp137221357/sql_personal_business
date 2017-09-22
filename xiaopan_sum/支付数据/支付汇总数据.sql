-- 钻石
SELECT date_format(ai.pay_time, '%Y-%m-%d') stat_time,
       ai.item_src,
       CASE
         WHEN ai.item_src = 3 THEN '微信'
         WHEN ai.item_src = 4 THEN '支付宝'
         WHEN ai.item_src = 9 THEN '苹果'
         WHEN ai.item_src = 10 THEN '苹果沙箱'
         WHEN ai.item_src = 11 THEN '百度支付'
         WHEN ai.item_src = 0 THEN '系统'
         WHEN ai.item_src = 6 THEN '银行卡'
         ELSE ai.item_src
       end  as pay_method,
       Ifnull(Count(ai.item_id), 0) pay_counts,
       Ifnull(Round(Sum(ai.cost_value), 2), 0) pay_money,
       Ifnull(Sum(ai.change_value), 0) get_value
FROM   t_acct_items ai
INNER JOIN t_user u ON ai.user_id = u.user_id
INNER JOIN forum.t_user_event e on u.USER_ID=e.USER_ID and e.EVENT_CODE='REG' 
WHERE  ai.item_event = 'BUY_DIAMEND'
       AND ai.COMMENTS not like '%"buy_coin":1%'
       AND ai.PAY_TIME>=curdate()
GROUP  BY stat_time desc,ai.item_src desc;


-- 金币  
SELECT date_format(ai.pay_time, '%Y-%m-%d') stat_time,
       ai.item_src,
       CASE
         WHEN ai.item_src = 3 THEN '微信'
         WHEN ai.item_src = 4 THEN '支付宝'
         WHEN ai.item_src = 9 THEN '苹果'
         WHEN ai.item_src = 10 THEN '苹果沙箱'
         WHEN ai.item_src = 11 THEN '百度支付'
         WHEN ai.item_src = 0 THEN '系统'
         WHEN ai.item_src = 6 THEN '银行卡'
         ELSE ai.item_src
       end  as pay_method,
       Ifnull(Count(ai.item_id), 0) pay_counts,
       Ifnull(Round(Sum(ai.cost_value), 2), 0) pay_money,
       Ifnull(Sum(ai2.COST_VALUE), 0) get_value
FROM   t_acct_items ai
INNER JOIN t_acct_items ai2 ON ai.ITEM_ID=ai2.REF_ITEM_ID
INNER JOIN t_user u ON ai.user_id = u.user_id
INNER JOIN forum.t_user_event e on u.USER_ID=e.USER_ID and e.EVENT_CODE='REG' 
WHERE  ai.item_event = 'BUY_DIAMEND'
       AND ai.COMMENTS like '%"buy_coin":1%'
       AND ai.PAY_TIME>=curdate()
GROUP  BY stat_time desc,ai.item_src desc;








