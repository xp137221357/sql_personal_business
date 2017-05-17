-- 留存
set @param0 = '2017-04-01'; 
set @param1 = '2017-05-01';
set @param2 = '2017-05-01'; 
set @param3 = '2017-06-01';
set @param4 = '2017.04-->2017.05';

-- 金币充值留存率
select @param4,'金币充值留存率',concat(round(count(t2.user_id)*100/count(t1.user_id),2),'%') '金币充值留存率' 
from (

	   select tc.charge_user_id user_id
		from report.t_trans_user_recharge_coin tc 
		where tc.crt_time>=@param0
		and  tc.crt_time<@param1
		group by tc.charge_user_id
) t1
left join (
		select tc.charge_user_id user_id 
		from report.t_trans_user_recharge_coin tc
		where tc.crt_time>=@param2
		and  tc.crt_time<@param3
		group by tc.charge_user_id
)t2 on t2.user_id=t1.user_id


union all


-- 钻石充值留存率
select @param4,'钻石充值留存率',concat(round(count(t2.user_id)*100/count(t1.user_id),2),'%') '钻石充值留存率' 
from (

	   select tc.charge_user_id user_id
		from report.t_trans_user_recharge_diamond tc 
		where tc.crt_time>=@param0
		and  tc.crt_time<@param1
		group by tc.charge_user_id
) t1
left join (
		select tc.charge_user_id user_id 
		from report.t_trans_user_recharge_diamond tc
		where tc.crt_time>=@param2
		and  tc.crt_time<@param3
		group by tc.charge_user_id
)t2 on t2.user_id=t1.user_id


union all


-- 购买推耗留存率
select @param4,'购买推荐留存率',concat(round(count(t2.user_id)*100/count(t1.user_id),2),'%') '购买推荐留存率' from (
	select ai.USER_ID from forum.t_acct_items ai 
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1003
	and ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM')
	group by ai.user_id
) t1
left join (
	select ai.USER_ID from forum.t_acct_items ai 
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1003
	and ai.PAY_TIME>=@param2
	and ai.PAY_TIME<@param3
	and ai.ITEM_EVENT in ('BUY_SERVICE', 'BUY_RECOM')
	group by ai.user_id
)t2 on t1.user_id=t2.user_id


union all


-- 球类竞猜留存
select @param4,'球类竞猜留存率',concat(round(count(t2.user_id)*100/count(t1.user_id),2),'%') '球类竞猜留存率' from (
	select ai.USER_ID from forum.t_acct_items ai 
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_EVENT in ('trade_coin', 'bk_trade_coin')
	group by ai.user_id
) t1
left join (
	select ai.USER_ID from forum.t_acct_items ai 
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.PAY_TIME>=@param2
	and ai.PAY_TIME<@param3
	and ai.ITEM_EVENT in ('trade_coin', 'bk_trade_coin')
	group by ai.user_id
)t2 on t1.user_id=t2.user_id;


