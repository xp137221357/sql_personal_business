set @param0='收专家';

set @param1='2017-09-12 00:00:00';
set @param2='2017-09-13 23:59:59';

-- 答题
-- t_offer        出题
-- t_offer_apply  答题

-- t_offer.OFFER_STATUS = 20 主动
-- t_offer.OFFER_STATUS = 80 被动

-- 测试帐号,乌兰巴托的夜,活动账号


-- 第三方出题，用户答题，用户给第三方金币
select '出币人出题',u2.NICK_NAME '出币人',u.NICK_NAME '收币人', IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0)  '金额',oa.OFFER_APPLY_TIME '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 200 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and (u.NICK_NAME ='@param0' or u2.NICK_NAME ='@param0')
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<=@param2

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '收币人出题',u2.NICK_NAME '出币人',u.NICK_NAME '收币人', IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) '金额', oa.OFFER_APPLY_TIME '时间'
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 800 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and (u.NICK_NAME ='@param0' or u2.NICK_NAME ='@param0')
and oa.OFFER_APPLY_TIME>=@param1
and oa.OFFER_APPLY_TIME<=@param2

union all


-- 转账
SELECT  '转账' , 
   u2.NICK_NAME '发送者',
	u.NICK_NAME '接收者',
	tp.money '金额', 
	tp.crt_time '时间'
FROM   forum.t_user_present tp  
INNER JOIN forum.t_user u ON u.user_id = tp.tuser_id 
INNER JOIN forum.t_user u2 ON u2.user_id = tp.user_id 
and (u.NICK_NAME ='@param0' or u2.NICK_NAME ='@param0')
WHERE  tp.status = 10
and tp.crt_time>=@param1
and tp.crt_time<=@param2;



-- select * from forum.t_user u where u.ACCT_NUM='13472478'


-- 2462478
-- 3469511860935110808