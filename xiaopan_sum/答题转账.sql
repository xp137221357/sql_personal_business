
-- 答题
-- t_offer        出题
-- t_offer_apply  答题

-- t_offer.OFFER_STATUS = 20 主动
-- t_offer.OFFER_STATUS = 80 被动

select u2.USER_ID sender, IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME,oa.OFFER_APPLY_ID 
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
and oa.USER_ID in ( '8780263189378442997')
inner join forum.t_user u on oa.USER_ID = u.USER_CODE
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE

union all 		 

-- 用户出题，第三方答题，第三方给用户金币
select u2.USER_ID sender, IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID receiver, oa.OFFER_APPLY_TIME,oa.OFFER_APPLY_ID 
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
and oa.USER_ID in ('8780263189378442997')
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE;




-- 转账
-- user_id 转账人
-- tuser_id 接收人


SELECT  '转账' , 
	tp.tuser_id , 
	tp.money , 
	tp.user_id, 
	tp.crt_time 
FROM   forum.t_user_present tp  
INNER JOIN forum.t_user u ON u.user_id = tp.tuser_id 
WHERE  tp.status = 10
       	







	
	