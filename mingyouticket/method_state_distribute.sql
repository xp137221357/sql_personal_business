-- 每天方案数量按状态分布柱状图

SELECT
         CASE
                  WHEN t.p_status='0'THEN '初始'
                  WHEN t.p_status='10' THEN '可售'
                  WHEN t.p_status='90' THEN '已付款，可切票'
                  WHEN t.p_status='100' THEN '已切票'
                  WHEN t.p_status='-200' THEN '整体撤单'
                  WHEN t.p_status='200' THEN '出票成功'
                  WHEN t.p_status='210' THEN '部分出票成功'
                  ELSE 　　'other'
         end AS p_status,
         count(t.p_projectnumber)
FROM     v_project t
WHERE    t.p_addtime>= to_date('2016-09-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
AND      t.p_addtime<= to_date('2016-09-23 23:59:59','yyyy-mm-dd hh24:mi:ss')
GROUP BY t.p_status

