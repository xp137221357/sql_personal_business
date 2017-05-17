
select t.sender,'答题',t.sender,t.sendername,t.receiver,t.receivername,sum(t.coins) coins,stat_time from (
-- 第三方出题，用户答题，用户给第三方金币
select '答题',u2.USER_ID sender,u2.NICK_NAME sendername,u.user_id receiver,u.NICK_NAME receivername, IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0) coins,oa.OFFER_APPLY_TIME stat_time
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and 
(u.USER_ID in (
select user_id from t_inner_stat_user
) or u2.USER_ID in (
select user_id from t_inner_stat_user
))

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '答题',u2.USER_ID sender,u2.NICK_NAME sendername,u.USER_ID receiver,u.NICK_NAME receivername, IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) coins,oa.OFFER_APPLY_TIME stat_time
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and (
u.USER_ID in (
select user_id from t_inner_stat_user
) or u2.USER_ID in (
select user_id from t_inner_stat_user
))
) t group by t.sender,t.receiver;

-- 转账
select sender,'转账',t.sender,t.sendername,t.receiver,t.receivername,sum(t.MONEY) coins,t.CRT_TIME from 
(
SELECT t.user_id sender ,u.NICK_NAME sendername,t.tuser_id receiver,u2.NICK_NAME receivername,t.MONEY,t.CRT_TIME
FROM forum.t_user_present t
inner join forum.t_user u2 on t.TUSER_ID=u2.USER_ID
inner join forum.t_user u on t.USER_ID=u.USER_ID and u.USER_ID in (

select user_id from t_inner_stat_user
)

union all 

SELECT t.user_id sender ,u2.NICK_NAME sendername,t.tuser_id receiver,u.NICK_NAME receivername,t.MONEY,t.CRT_TIME
FROM forum.t_user_present t
inner join forum.t_user u2 on t.USER_ID=u2.USER_ID
inner join forum.t_user u on t.TUSER_ID=u.USER_ID and u.USER_ID in (

select user_id from t_inner_stat_user
)
) t
group by t.sender,t.receiver;
