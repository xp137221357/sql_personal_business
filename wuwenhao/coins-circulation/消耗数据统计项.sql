-- 8.8 00:00:00  - 8.14 23:59:59
-- 8.15 00:00:00 - 8.21 23:59:59
-- 8.22 00:00:00 - 8.28 23:59:59

set @beginTime='2016-08-01 00:00:00';
set @endTime = '2016-09-01 23:59:59';
-- 消耗
-- 答题消耗
select 'P','答题消耗',concat(@beginTime,'~',@endTime) '时间','all',
 -round(SUM(abs(ai.OFFER_TAX))) '金币' from game.t_offer ai
inner join forum.t_user u on u.USER_CODE = ai.USER_ID
where ai.CRT_TIME >= @beginTime and ai.CRT_TIME <= @endTime 

union all
  
-- 赠送消耗
select 'P','赠送消耗',concat(@beginTime,'~',@endTime) '时间','all',
 -round(SUM(ai.FEE_MONEY)) '金币' from forum.t_user_present ai
where  ai.STATUS = 10 AND ai.CRT_TIME >= @beginTime and ai.CRT_TIME <= @endTime 

union all

-- 兑换消耗
select 'P','兑换消耗',concat(@beginTime,'~',@endTime) '时间','all',
 -round(SUM(ifnull(ai.change_value,0))) '金币' from forum.t_acct_items ai
where  ai.ITEM_STATUS = 10 AND ai.ITEM_EVENT='COIN_REDEEM' 
and ai.ADD_TIME >= @beginTime and ai.ADD_TIME <= @endTime 


union all

  -- 广播消耗

SELECT 'P','金币广播消耗',concat(@beginTime,'~',@endTime) '时间','all',-ROUND(sum(ifnull(ai.CHANGE_VALUE,0))) '金币'
FROM game.t_msg ms
INNER JOIN forum.t_acct_items ai on cast(ms.MSG_ID as char)= ai.TRADE_NO
AND ms.USER_ID=ai.ACCT_ID 
AND ms.ADD_TIME>= @beginTime 
AND ms.ADD_TIME <= @endTime 
and ms.SEND_STATUS=1
AND ai.ITEM_EVENT='TRADE_COIN'
AND ai.ACCT_TYPE IN (1001)


union all

SELECT 'T','体验币广播消耗',concat(@beginTime,'~',@endTime) '时间','all',-ROUND(sum(ifnull(ai.CHANGE_VALUE,0))) '体验币'
FROM game.t_msg ms
INNER JOIN forum.t_acct_items ai ON cast(ms.MSG_ID as char)= ai.TRADE_NO
AND ms.USER_ID=ai.ACCT_ID 
AND ms.ADD_TIME>= @beginTime 
AND ms.ADD_TIME <= @endTime 
and ms.SEND_STATUS=1
AND ai.ITEM_EVENT='TRADE_COIN'
AND ai.ACCT_TYPE IN (1015);


-- 娱乐场消耗

select 
t1.stat_date,t1.coin_penalty_consume,t1.free_penalty_consume,
t2.coin_rotary_consume,t2.free_rotary_consume
from (
	select date_add(curdate(),interval -1 day) stat_date,
	sum(earn - pay) coin_penalty_consume,
	sum(pcoin_earn - pcoin_pay) free_penalty_consume  
	from h5game.t_pk_act tpk
	where create_time >= date_add(curdate(),interval -1 day) 
	and create_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59') 
	and `status` = 1
)t1
left join(
	select date_add(curdate(),interval -60 day) stat_date,
	sum(earn - pay) coin_rotary_consume,
	sum(pcoin_earn - pcoin_pay) free_rotary_consume  
	from h5game.t_roulette_act tra
	where create_time >=date_add(curdate(),interval -1 day) 
	and create_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59') 
	and `status` = 1
)t2 on t1.stat_date=t2.stat_date

  
 