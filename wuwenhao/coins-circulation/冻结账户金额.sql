-- 冻结金币
select sum(ai.acct_balance)/100 from t_account_item_snap ai 
inner join t_user_forbidden fb on ai.acc_name = fb.user_code
and ai.insert_time >= to_date('2016-08-08 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and ai.insert_time <= to_date('2016-08-08 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and ai.item_type = '1001'
order by ai.insert_time desc;

-- 冻结体验币
select sum(ai.acct_balance)/100 from t_account_item_snap ai 
inner join t_user_forbidden fb on ai.acc_name = fb.user_code
and ai.insert_time >= to_date('2016-08-08 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and ai.insert_time <= to_date('2016-08-08 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and ai.item_type = '1015'
order by ai.insert_time desc;


-- 合并
select sum(t.fobidden_free_coins) fobidden_free_coins,
sum(t.fobidden_normal_coins)fobidden_normal_coins,
sum(t.fobidden_free_coins+t.fobidden_normal_coins) fobidden_coins from (
select count(distinct ai.ACC_NAME) fobidden_counts, 
sum(decode(ai.ITEM_TYPE,1015,ai.ACCT_BALANCE,0)) / 100 fobidden_free_coins,
sum(decode(ai.ITEM_TYPE,1001,ai.ACCT_BALANCE,0)) / 100 fobidden_normal_coins
  from t_user_forbidden d inner join v_account_item ai
on d.user_code = ai.ACC_NAME and ai.ITEM_TYPE in (1001,1015)
)t