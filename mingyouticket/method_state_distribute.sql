-- ÿ�췽��������״̬�ֲ���״ͼ

SELECT
         CASE
                  WHEN t.p_status='0'THEN '��ʼ'
                  WHEN t.p_status='10' THEN '����'
                  WHEN t.p_status='90' THEN '�Ѹ������Ʊ'
                  WHEN t.p_status='100' THEN '����Ʊ'
                  WHEN t.p_status='-200' THEN '���峷��'
                  WHEN t.p_status='200' THEN '��Ʊ�ɹ�'
                  WHEN t.p_status='210' THEN '���ֳ�Ʊ�ɹ�'
                  ELSE ����'other'
         end AS p_status,
         count(t.p_projectnumber)
FROM     v_project t
WHERE    t.p_addtime>= to_date('2016-09-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
AND      t.p_addtime<= to_date('2016-09-23 23:59:59','yyyy-mm-dd hh24:mi:ss')
GROUP BY t.p_status

