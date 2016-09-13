-- select * from game.t_offer limit 100

set @beginTime = '2016-06-01';
set @endTime = '2016-06-20';
-- 赏金答题
select date(o.CRT_TIME) stat_time,
ifnull(count(distinct o.USER_ID),0) reward_person, 
ifnull(count(o.user_ID),0) reward_counts,
ifnull(count(distinct a.USER_ID),0) answer_person, 
ifnull(count(a.user_ID),0) answer_counts,
ifnull(round(sum(o.OFFER_GRATUITY)),0) reward_money,
ifnull(round(abs(sum(o.OFFER_TAX))),0) website_tax,
ifnull(round(sum(o.OFFER_PRIZE)),0) answer_money
from t_trans_user_attr u
inner join game.t_offer o on u.USER_CODE = o.USER_ID and u.SYSTEM_MODEL = 'android'
left join game.t_offer_apply a on o.OFFER_ID = a.OFFER_ID 
 where o.CRT_TIME >=@beginTime
 and o.CRT_TIME <=@endTime
 group by date(o.CRT_TIME)



-- 新手任务统计

 ## 新户邀请赠送
 -- 邀请赠送
 
 ## 六个任务
-- 购买服务 BUY_SRV
-- 关注圈子 FOLLOW_CIRCLE
-- 签到 SIGN_
-- 新手体验 NEWTASK1000_NEWTASK1000
-- 发表帖子 ADD_NOTE
-- 验证手机 BIND_BIND

select concat(@beginTime,'~',@endTime) '时间','新户邀请赠送', round( ifnull(sum(ai.change_value),0)) `邀请赠送` from forum.t_acct_items ai 
where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015) 
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime
  and ai.user_id in ( select user_id from forum.v_user_new where crt_time >=@beginTime and crt_time <@endTime) 
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and ai.TRADE_NO like '%USER_GJ-%' 
  

select 
t.stat_time,
ifnull(sum(t.buy_service_receiver_coins),0) buy_service_receiver_coins,
ifnull(sum(t.buy_service_receivers),0) buy_service_receivers,
ifnull(sum(t.sig_receiver_coins),0) sig_receiver_coins,
ifnull(sum(t.concern_receivers),0) concern_receivers,
ifnull(sum(t.post_receiver_coins),0) post_receiver_coins,
ifnull(sum(t.validate_receiver_coins),0) validate_receivers,
ifnull(sum(t.new_receiver_coins),0) new_receivers,
ifnull(sum(t.new_receivers),0) new_receivers,
ifnull(sum(t.invite_receiver_coins),0) invite_receiver_coins,
ifnull(sum(t.invite_receivers),0) invite_receivers,
tt.all_receivers,
tt.all_receiver_coins
from 
(
select date(ai.ADD_TIME) stat_time,
if(ai.TRADE_NO like '%BUY_SRV%' ,round(sum(ai.change_value)),0)  buy_service_receiver_coins,
if(ai.TRADE_NO like '%BUY_SRV%' ,count(distinct ai.user_id),0)  buy_service_receivers,
if(ai.TRADE_NO like '%SIGN_%' ,round(sum(ai.change_value)),0) sig_receiver_coins ,
if(ai.TRADE_NO like '%SIGN_%' ,count(distinct ai.user_id),0)  sig_receivers,
if(ai.TRADE_NO like '%FOLLOW_CIRCLE%' ,round(sum(ai.change_value)),0) concern_receiver_coins ,
if(ai.TRADE_NO like '%FOLLOW_CIRCLE%' ,count(distinct ai.user_id),0)  concern_receivers,
if(ai.TRADE_NO like '%ADD_NOTE_%' ,round(sum(ai.change_value)),0) post_receiver_coins	,
if(ai.TRADE_NO like '%ADD_NOTE_%' ,count(distinct ai.user_id),0)  post_receivers,
if(ai.TRADE_NO like '%BIND_BIND%' ,round(sum(ai.change_value)),0) validate_receiver_coins ,
if(ai.TRADE_NO like '%BIND_BIND%' ,count(distinct ai.user_id),0)  validate_receivers,
if(ai.TRADE_NO like '%NEWTASK1000_NEWTASK1000%' ,round(sum(ai.change_value)),0) new_receiver_coins ,
if(ai.TRADE_NO like '%NEWTASK1000_NEWTASK1000%' ,count(distinct ai.user_id),0)  new_receivers,
if(ai.TRADE_NO like '%USER_GJ-%' ,round(sum(ai.change_value)),0) invite_receiver_coins ,
if(ai.TRADE_NO like '%USER_GJ%' ,count(distinct ai.user_id),0)  invite_receivers
from t_trans_user_attr u
inner join forum.t_acct_items ai on u.USER_ID= ai.USER_ID  and u.SYSTEM_MODEL = 'android' 
where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)  
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or 
      ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
      ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND' 
      or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'
		or ai.TRADE_NO like 'USER_GJ-%' )
group by date(ai.ADD_TIME),ai.TRADE_NO
) t

left join 
(
select date(ai.ADD_TIME) stat_time,
round(sum(ai.change_value)) all_receiver_coins,
count(distinct ai.user_id) all_receivers
from t_trans_user_attr u
inner join forum.t_acct_items ai on u.USER_ID= ai.USER_ID  and u.SYSTEM_MODEL = 'android'  
where ai.item_status = 10 and ai.ACCT_TYPE in (1001,1015)  
  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10 
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or 
      ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
      ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND' 
      or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'
		or ai.TRADE_NO like 'USER_GJ-%' )
group by date(ai.ADD_TIME)
) tt on t.stat_time = tt.stat_time
group by t.stat_time


