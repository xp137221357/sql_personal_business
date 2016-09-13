###########	投注人数	###########
set @param0='2016-08-29';
set @param1='2016-09-04 23:59:59';

select '投注情况',concat(@param0,'~',@param1) '时间',count(distinct u.USER_ID) 投注人数, sum(oi.ITEM_MONEY) 投注金币数, sum(oi.PRIZE_MONEY) 返回金币数, sum(oi.COIN_BUY_MONEY) 投注普通金币数, sum(oi.COIN_PRIZE_MONEY) 投注返回普通金币数
 from forum.t_user u 
inner join game.t_order_item oi on u.USER_CODE = oi.USER_ID
 and oi.ITEM_STATUS not in (-5, -10, 210)
 and oi.CHANNEL_CODE in ('GAME')
 and oi.CRT_TIME >= @param0 and oi.CRT_TIME <= @param1;

#################官充人数与金额 #################
select '官方充值情况',concat(@param0,'~',@param1) '时间', 
count(distinct rc.charge_user_id) 官充人数,  
sum(rc.rmb_value) 官充金额, 
sum(rc.coins) 官充金币
 from t_trans_user_recharge_coin rc where rc.charge_method in ('APP')
 and rc.crt_time >= @param0 and rc.crt_time <= @param1;
 
 
 #################非官充人数与金额 #################
select '非官方充值情况',concat(@param0,'~',@param1) '时间',
count(distinct rc.charge_user_id) 非官充人数, 
sum(rc.rmb_value) 非官充金额, sum(rc.coins) 非官充金币
 from t_trans_user_recharge_coin rc where rc.charge_method not in ('APP') 
  and rc.crt_time >= @param0 and rc.crt_time <= @param1;
 
 
#################-- vip用户的投注情况 #################
  
-- vip用户的投注情况
select '投注情况',concat(@param0,'~',@param1) '时间',count(distinct v.USER_ID) 投注人数, sum(oi.ITEM_MONEY) 投注总币数,
 sum(oi.PRIZE_MONEY) 返回总币数, sum(oi.COIN_BUY_MONEY) 投注普通金币数, sum(oi.COIN_PRIZE_MONEY) 投注返回普通金币数
 from report.v_user_boss v 
inner join game.t_order_item oi on v.USER_CODE = oi.USER_ID
 and oi.ITEM_STATUS not in (-5, -10, 210)
 and oi.CHANNEL_CODE in ('GAME')
 and oi.CRT_TIME >= @param0 and oi.CRT_TIME <= @param1;
 
 
###########	新增投注人数	###########

select '新增投注',concat(@param0,'~',@param1) '时间',count(distinct u.USER_ID) 新增投注人数, sum(oi.COIN_BUY_MONEY)新增投注金币, sum(oi.COIN_PRIZE_MONEY - oi.COIN_BUY_MONEY) 新增投注人盈利金币数 from forum.t_user u 
inner join game.t_order_item oi on u.USER_CODE = oi.USER_ID
 and oi.ITEM_STATUS not in (-5, -10, 210)
 and oi.CHANNEL_CODE = 'GAME'
 and u.CRT_TIME > @param0
 and oi.CRT_TIME > @param0 and oi.CRT_TIME < @param1;


select '大户名单',concat(@param0,'~',@param1) '时间',rc.charge_user_id
 from t_trans_user_recharge_coin rc 
  group by rc.charge_user_id having sum(rc.coins) >= 280000;


 select '充值2000元以上的大户名单',t.user_id from (
 select user_id from (
 SELECT t.charge_user_id user_id,
        sum(t.rmb_value) rmb_value
 FROM   (SELECT tc.charge_user_id,
                tc.rmb_value
         FROM   t_trans_user_recharge_coin tc                                           
         UNION ALL
         SELECT td.charge_user_id,
                td.rmb_value
         FROM   t_trans_user_recharge_diamond td
         ) t
 GROUP  BY t.charge_user_id) tt WHERE tt.rmb_value>2000 )t



  #################盈亏金币数 #################

-- 总
select '总金币' type_,concat(@param0,'~',@param1) '时间',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0

where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1

) t1,(select 
sum(ifnull(oi.PRIZE_MONEY,0)) return_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0

where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @param0 and oi.BALANCE_TIME < @param1) t2

union all

-- 金币
select '金币' type_,concat(@param0,'~',@param1) '时间',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0

where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1) t1,(select 
sum(ifnull(oi.COIN_PRIZE_MONEY,0)) return_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0

where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @param0 and oi.BALANCE_TIME < @param1) t2

union all
-- 体验金币
select '体验金币' type_,concat(@param0,'~',@param1) '时间',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.P_COIN_BUY_MONEY)) bet_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0

where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.PAY_TIME >= @param0 and oi.PAY_TIME < @param1) t1,(select 
sum(ifnull(oi.P_COIN_PRIZE_MONEY,0)) return_coins
 from game.t_order_item oi
 inner join forum.t_user u on oi.USER_ID = u.USER_CODE and u.CRT_TIME >= @param0
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.BALANCE_TIME >= @param0 and oi.BALANCE_TIME < @param1) t2;



#################盈亏金币数 #################
  
  
  
#################任务赠送 #################



## 任务赠送
select 'P','金币任务赠送',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
				where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
				  and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
				  and ai.USER_ID not in (select user_id from forum.v_user_system)
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
					  
					  union all
					  
select 'T','体验币任务赠送',concat(@param0,'~',@param1) '时间','all', round( sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
				where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
				  and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
				  and ai.USER_ID not in (select user_id from forum.v_user_system)
				  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
				  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
					  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
					  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
					  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
					  
					  union all
					  
					  
## 邀请赠送
select 'P','金币邀请赠送',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			  
			  union all
			  
select 'T','体验币邀请赠送',concat(@param0,'~',@param1) '时间','all', round( sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
			  
			
			union all
					

## 活动赠送
select 'P','金币活动赠送',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where  ai.item_status = 10 and ai.ACCT_TYPE in (1001) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.USER_ID not in (select user_id from forum.v_user_system)
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			
			union all
			
			
select 'T','体验币活动赠送',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where  ai.item_status = 10 and ai.ACCT_TYPE in (1015) and (ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
		 	and ai.USER_ID not in (select user_id from forum.v_user_system)
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			
			union all

			
## 天天活动
select 'P','金币天天活动',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '金币'   from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
			  
			  union all
			  
			  
select 'T','体验币天天活动',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '体验币'   from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <=  @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
			  
			  union all
			
			  
## 代理返点(体验币没有代理返点，若有则为错误的)
select 'P','金币用户反水',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '金币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10
			  
			  union all
			  
			  
select 'T','体验币用户反水',concat(@param0,'~',@param1) '时间','all', round(sum(ai.change_value)) '体验币'  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1015)
			  and ai.ADD_TIME >= @param0  and ai.ADD_TIME <= @param1
			  and ai.USER_ID not in (select user_id from forum.v_user_system)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10;
			  

select 'P','系统账号派发',concat(@param0,'~',@param1) '时间',round(t1.MONEY + t3.OFFER_GRATUITY) '派发金币' from (
SELECT ifnull(Sum(p.money),0) MONEY
        FROM   forum.t_user_present p
        inner join forum.v_user_system vs on p.USER_ID = vs.USER_ID
               AND p.`status` = 10
               AND p.crt_time >= @param0
               AND p.crt_time < @param1
			   )t1, (
select '系统用户赏金答题赠送', concat(@param0,'~',@param1) '时间',ifnull(sum(gift_sum),0) OFFER_GRATUITY from (
## 三个系统大账号主动给用户派送金币
select oa.USER_ID receiver, o.OFFER_GRATUITY - o.OFFER_PRIZE gift_sum, o.USER_ID sender 
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join forum.v_user_system vus on o.USER_ID = vus.USER_CODE and oa.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME > @param0 and oa.OFFER_APPLY_TIME < @param1

union all 

select o.USER_ID, o.OFFER_PRIZE - o.OFFER_GRATUITY gift_sum, oa.USER_ID from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
inner join forum.v_user_system vus on oa.USER_ID = vus.USER_CODE and o.USER_ID != vus.USER_CODE 
and oa.OFFER_APPLY_TIME > @param0 and oa.OFFER_APPLY_TIME < @param1
)t2
) t3 ;