set @param0='2016-11-07';
set @param1='2016-11-13 23:59:59';
set @param2='2016-11-07';
set @param3='2016-11-13 23:59:59';

-- 新手任务
select tu.user_id '用户ID',tu.NICK_NAME '用户昵称',tu.USER_MOBILE '联系方式',tu.CRT_TIME '注册时间',
o.coin '投注金币',o.free_coin '投注体验币',ai.get_coupon_count '获得张数',
aii.use_coupon_count '使用张数', aii.add_time '使用时间',
t5.h_coins '历史充值金币',
t6.h_diamonds '历史充值钻石'
from (
select t1.user_id from (
	select user_id from forum.t_acct_items ai 
	where ai.ITEM_EVENT='USER_TASK' 
	and ai.ITEM_STATUS=10 
	and ai.ADD_TIME>=@param0 
	and ai.ADD_TIME<=@param1
	group by user_id
)t1 
inner join (
-- 免费专家券
	select user_id from forum.t_acct_items ai 
	where ai.ITEM_EVENT='FREE_EXPERT_COUPON' 
	and ai.ITEM_STATUS=10 
	and ai.ADD_TIME>=@param0 
	and ai.ADD_TIME<=@param1
	group by user_id
) t2 on t1.user_id = t2.user_id
left join (
-- 本周充值
	select charge_user_id user_id from (
	select tc.charge_user_id from report.t_trans_user_recharge_coin tc
	where tc.crt_time>=@param0
	and tc.crt_time<=@param1
	 union all 
	select td.charge_user_id from report.t_trans_user_recharge_diamond td
	where td.crt_time>=@param0
	and td.crt_time<=@param1
	) t group by charge_user_id
) t3 on t2.user_id = t3.user_id
where t3.user_id is null
) t
inner join forum.t_user tu on tu.USER_ID = t.user_id
left join (
   select user_id,sum(o.COIN_BUY_MONEY) coin,sum(o.P_COIN_BUY_MONEY) free_coin from game.t_order_item o 
	where o.ITEM_STATUS not in (-5,-10,210) 
	and o.CHANNEL_CODE ='GAME'
	and o.crt_time>=@param2
	and o.crt_time<=@param3
	group by user_id
	) o on o.user_id= tu.USER_CODE
left join (
   select user_id,sum(ai.CHANGE_VALUE) get_coupon_count from forum.t_acct_items ai 
	where ai.ITEM_EVENT='FREE_EXPERT_COUPON' 
	and ai.ITEM_STATUS=10 
	and ai.ADD_TIME>=@param2 
	and ai.ADD_TIME<=@param3
	group by user_id
	) ai on ai.user_id= tu.USER_ID
left join (
   select ai.ADD_TIME,user_id,ai.CHANGE_VALUE use_coupon_count 
	from forum.t_acct_items ai 
	where ai.item_event ='BUY_RECOM' 
 	and ai.ACCT_TYPE=103
	and ai.ITEM_STATUS=10 
	and ai.ADD_TIME>=@param2 
	and ai.ADD_TIME<=@param3
	) aii on aii.user_id= tu.USER_ID 
left join (
   select tc.charge_user_id user_id,sum(tc.coins) h_coins
	from report.t_trans_user_recharge_coin tc 
	group by tc.charge_user_id 
	) t5 on t5.user_id= tu.USER_ID 
left join (
   select td.charge_user_id user_id,sum(td.diamonds) h_diamonds
	from report.t_trans_user_recharge_diamond td 
	group by td.charge_user_id 
	) t6 on t6.user_id= tu.USER_ID 
ORDER BY TU.USER_ID ASC



