-- ������
select sum(ai.acct_balance)/100 from t_account_item_snap ai 
where 
ai.insert_time >= to_date('2016-08-08 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and ai.insert_time <= to_date('2016-08-08 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and ai.item_type = '1001'
and  ai.acc_name not in ('3472351858331386256','6149208545176280651','8270936710946839603')
order by ai.insert_time desc;

-- ��������
select sum(ai.acct_balance)/100 from t_account_item_snap ai 
where 
ai.insert_time >= to_date('2016-08-08 00:00:00','yyyy-mm-dd hh24:mi:ss')  
and ai.insert_time <= to_date('2016-08-08 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and ai.item_type = '1015'
and  ai.acc_name not in ('3472351858331386256','6149208545176280651','8270936710946839603')
order by ai.insert_time desc;


