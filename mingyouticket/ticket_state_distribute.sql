-- ÿ��Ʊ������״̬�ֲ���״ͼ

SELECT
         CASE
                  WHEN t.pd_status='0'THEN '��ʼ'
                  WHEN t.pd_status='10' THEN '�ɳ�Ʊ'
                  WHEN t.pd_status='20' THEN 'Ʊ̨����'
                  WHEN t.pd_status='30' THEN 'Ʊ̨����'
                  WHEN t.pd_status='-300' THEN 'h5�޺�ʧ��'
                  WHEN t.pd_status='-200' THEN 'Ʊ̨����'
                  WHEN t.pd_status='200' THEN '��Ʊ�ɹ�'
                  ELSE ����'other'
         end AS pd_status,
         count(t.pd_projectnumber)
FROM     v_ticket t
WHERE    t.pd_addtime>= to_date('2016-09-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
AND      t.pd_addtime<= to_date('2016-09-23 23:59:59','yyyy-mm-dd hh24:mi:ss')
GROUP BY t.pd_status




  
  
