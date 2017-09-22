
set @param1='2017-09-04';
set @param2='2017-09-11';


select '悬赏',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  '金额',o.CRT_TIME '出题时间',oa.OFFER_APPLY_TIME '答题时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE 
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<@param2

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '答题',u2.NICK_NAME '发送者',u.NICK_NAME '接收者', IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) '金额',o.CRT_TIME '出题时间',oa.OFFER_APPLY_TIME '答题时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE 
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<@param2;


-- TRADE_DREAMLIVE_COIN