set @param1='2017-09-14';
set @param2='2017-09-15';

set @param3='出币人';
set @param4='收币人';

select '出币人出题',u2.NICK_NAME '出币人',u2.USER_ID '出币人ID',u.NICK_NAME '收币人',u.USER_ID '收币人ID', IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  '金额',o.CRT_TIME '出题时间',oa.OFFER_APPLY_TIME '答题时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE 
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<@param2

union all 		 

select '收币人出题',u2.NICK_NAME '出币人',u2.USER_ID '出币人ID',u.NICK_NAME '收币人',u.USER_ID '收币人ID', IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) '金额',o.CRT_TIME '出题时间',oa.OFFER_APPLY_TIME '答题时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE 
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<@param2;

