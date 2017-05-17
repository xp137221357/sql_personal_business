
-- 答题转账
set @nick_name='风中追风';

select '答题',t.sender,t.receiver,sum(t.coins) coins from (
-- 第三方出题，用户答题，用户给第三方金币
select '答题',u2.NICK_NAME sender,u.NICK_NAME receiver, IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0) coins
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and (u.NICK_NAME =@nick_name or u2.NICK_NAME =@nick_name)

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '答题',u2.NICK_NAME sender,u.NICK_NAME receiver, IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) coins
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and (u.NICK_NAME =@nick_name or u2.NICK_NAME =@nick_name)
) t group by t.sender,t.receiver

union all

-- 转账

select '转账',u.NICK_NAME,t.USER_ID,t.nick_name,sum(in_),sum(out_) from (
SELECT t.user_id admin_user,u.NICK_NAME,u.user_id,u.ACCT_NUM,t.MONEY out_, 0 in_
FROM forum.t_user_present t
inner join forum.t_user u on t.TUSER_ID=u.USER_ID
WHERE t.USER_ID ='347' 

union all 

SELECT t.tuser_id admin_user,u.NICK_NAME,u.user_id,u.ACCT_NUM,0 out_,t.MONEY in_
FROM forum.t_user_present t
inner join forum.t_user u on t.USER_ID=u.USER_ID
WHERE t.TUSER_ID ='347' 
) t
inner join forum.t_user u on t.admin_user=u.USER_ID 
group by t.user_id;
