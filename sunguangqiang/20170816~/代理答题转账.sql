
set @param1='2017-07-01';
set @param2='2017-08-18';


select '答题',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  '金额',oa.OFFER_APPLY_TIME '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and (

	u.user_code in (
	
	select t1.user_id from game.t_group_ref t1
	inner join  game.t_group_ref t2 on t1.ROOT_ID=t2.REF_ID
	inner join report.t_partner_group tg on t2.user_id=tg.user_id and tg.is_valid=0
	
	)
	
	or 
	
	u2.user_code in (
	
	select t1.user_id from game.t_group_ref t1
	inner join  game.t_group_ref t2 on t1.ROOT_ID=t2.REF_ID
	inner join report.t_partner_group tg on t2.user_id=tg.user_id and tg.is_valid=0
	
	)

)
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<=@param2

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '答题',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) '金额', oa.OFFER_APPLY_TIME '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and (


	u.user_code in (
	
	select t1.user_id from game.t_group_ref t1
	inner join  game.t_group_ref t2 on t1.ROOT_ID=t2.REF_ID
	inner join report.t_partner_group tg on t2.user_id=tg.user_id and tg.is_valid=0
	
	)
	
	or 
	
	u2.user_code in (
	
	select t1.user_id from game.t_group_ref t1
	inner join  game.t_group_ref t2 on t1.ROOT_ID=t2.REF_ID
	inner join report.t_partner_group tg on t2.user_id=tg.user_id and tg.is_valid=0
	
	)

)
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<=@param2