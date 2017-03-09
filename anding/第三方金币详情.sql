-- set param=['2017-01-01','2017-01-01 23:59:59'];

set @param0='2017-01-01';
set @param1='2017-01-31 23:59:59';
 
 ## 第三方账号的官充
 
select date_format(t1.stat_date,'%Y-%m%-%d') '时间',
	 t2.coins '官充',
	 t3.coins '售币',
	 t4.coins '收币'
from(
	 select t.stat_date from report.t_stat_coin_operate t
	 where t.stat_date>=@param0
	 and t.stat_date<=@param1
) t1
 left join (
	select '第三方账号的官充',date_format(rc.crt_time,'%Y-%m-%d') stat_time,
	sum(rc.coins) coins
 	from t_trans_merchant_recharge_coin rc  
 	where rc.crt_time>=@param0
 	and rc.crt_time<=@param1
 	group by stat_time
) t2 on t1.stat_date=t2.stat_time
left join (
	select '第三方账号的售币',date_format(rc.crt_time,'%Y-%m-%d') stat_time,
	sum(rc.coins) coins
	from t_trans_user_recharge_coin rc 
	where rc.crt_time>=@param0
	and rc.crt_time<=@param1
	group by stat_time
)t3 on t1.stat_date=t3.stat_time
left join (
	select '第三方账号的收币',date_format(rc.crt_time,'%Y-%m-%d') stat_time,
	sum(rc.coins) coins
	from t_trans_user_withdraw rc 
	group by stat_time
)t4 on t1.stat_date=t4.stat_time
order by t1.stat_date asc


-- 第三方存币


select 
date(@param) stat_time,
round(sum(ai.AFTER_VALUE)) from (
select t.NICK_NAME,t.USER_ID,max(ai.ITEM_ID) ITEM_ID from report.t_user_merchant t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and ai.PAY_TIME<=@param
group by t.USER_ID
) t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and t.ITEM_ID=ai.ITEM_ID;


-- 刷数据

BEGIN

set @param = '2017-01-01 23:59:59';

label1: WHILE @param <='2017-03-06 23:59:59' Do

insert into t_third_after_value(stat_time,after_value)
select 
date(@param) stat_time,
round(sum(ai.AFTER_VALUE)) from (
select t.NICK_NAME,t.USER_ID,max(ai.ITEM_ID) ITEM_ID from report.t_user_merchant t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and ai.PAY_TIME<=@param
group by t.USER_ID
) t 
inner join forum.t_acct_items ai on t.USER_ID=ai.USER_ID and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001 and t.ITEM_ID=ai.ITEM_ID
on duplicate key update 
after_value = values(after_value)
;
		 
SET @param = date_add(@param,interval 1 day);
end while label1;

END


