-- 每天票数量按状态分布柱状图

SELECT
         CASE
                  WHEN t.pd_status='0'THEN '初始'
                  WHEN t.pd_status='10' THEN '可出票'
                  WHEN t.pd_status='20' THEN '票台拒收'
                  WHEN t.pd_status='30' THEN '票台已收'
                  WHEN t.pd_status='-300' THEN 'h5限号失败'
                  WHEN t.pd_status='-200' THEN '票台撤单'
                  WHEN t.pd_status='200' THEN '出票成功'
                  ELSE 　　'other'
         end AS pd_status,
         count(t.pd_projectnumber)
FROM     v_ticket t
WHERE    t.pd_addtime>= to_date('2016-09-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
AND      t.pd_addtime<= to_date('2016-09-23 23:59:59','yyyy-mm-dd hh24:mi:ss')
GROUP BY t.pd_status




  
  
