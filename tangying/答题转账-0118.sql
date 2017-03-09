set @param0='小航航';

select '答题',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  '金额',date_format(oa.OFFER_APPLY_TIME,'%Y-%m-%d %H:%i:%S') '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and u2.NICK_NAME=@param0

union all 		 

select '答题',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) '金额', date_format(oa.OFFER_APPLY_TIME,'%Y-%m-%d %H:%i:%S') '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and u2.NICK_NAME=@param0

union all

SELECT  '转账' , 
   u2.NICK_NAME '发送者',
	u.NICK_NAME '接收者',
	tp.money '金额', 
	date_format(tp.crt_time,'%Y-%m-%d %H:%i:%S') '时间'
FROM   forum.t_user_present tp  
INNER JOIN forum.t_user u ON u.user_id = tp.tuser_id 
INNER JOIN forum.t_user u2 ON u2.user_id = tp.user_id and u2.NICK_NAME=@param0
WHERE  tp.status = 10;
       	







	
	