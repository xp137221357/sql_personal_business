select '总',sum(ai.CHANGE_VALUE) FROM forum.t_acct_items ai
INNER JOIN forum.t_user_event ue 
ON ai.USER_ID = ue.USER_ID AND ue.EVENT_CODE = 'REG' 
where date(ai.PAY_TIME) >= '2017-05-22' 
and date(ai.PAY_TIME) <= '2017-05-22' 
AND ai.ITEM_EVENT = 'BUY_DIAMEND'
and ai.ITEM_STATUS=10
group by date(ai.PAY_TIME);



SELECT '钻石',sum(ai.CHANGE_VALUE)
FROM forum.t_acct_items ai
INNER JOIN forum.t_user_event ue 
ON ai.USER_ID = ue.USER_ID AND ue.EVENT_CODE = 'REG' 
AND ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.ITEM_STATUS = 10 AND 
(ai.COMMENTS NOT LIKE '%buy_coin":1%' and ai.COMMENTS not like '%underline%') 
where date(ai.PAY_TIME) >= '2017-05-22' 
and date(ai.PAY_TIME) <= '2017-05-22' 
group by date(ai.PAY_TIME);


SELECT '金币',sum(ai.CHANGE_VALUE)
  FROM forum.t_user u 
       LEFT JOIN forum.t_user_event e
          ON u.USER_ID = e.USER_ID 
			 AND e.EVENT_CODE = 'REG'
       INNER JOIN forum.t_acct_items ai
          ON     u.USER_ID = ai.USER_ID
             AND ai.ITEM_STATUS = 10
             AND ai.ITEM_EVENT = 'DIAMEND_TO_COIN'
             and date(ai.PAY_TIME) >= '2017-05-22' 
            and date(ai.PAY_TIME) <= '2017-05-22' 
 WHERE u.CLIENT_ID = 'BYAPP' and u.group_type != 1
 group by date(ai.PAY_TIME) ;