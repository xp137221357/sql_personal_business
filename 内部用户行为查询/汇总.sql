select u.USER_ID,u.NICK_NAME from forum.t_user u where u.ACCT_NUM in (
'11010347',
'13468818',
'13469055',
'13469064',
'13468995',
'11133239',
'12657149',
'12793811',
'13180578',
'13234098',
'12598085',
'12796487',
'13154904',
'12991293',
'13165038');

USER_ID IN (
'347',
'123239',
'1588085',
'1647149',
'1783811',
'1786487',
'1981293',
'2144904',
'2155038',
'2170578',
'2224098',
'2458818',
'2458995',
'2459055',
'2459064')




-- 汇总
-- 答题转账
set @user_id='347';

insert into t_inner_user(user_id,item_event,sender,receiver,coins)
select @user_id,'答题',t.sender,t.receiver,sum(t.coins) coins from (
-- 第三方出题，用户答题，用户给第三方金币
select '答题',u2.USER_ID sender,u.user_id receiver, IFNULL(o.OFFER_GRATUITY,0) - IFNULL(o.OFFER_PRIZE,0) coins
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
inner join forum.t_user u on oa.USER_ID = u.USER_CODE 
inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE and (u.user_id =@user_id or u2.user_id =@user_id)

union all 		 

-- 用户出题，第三方答题，用户给第三方金币
select '答题',u2.USER_ID sender,u.USER_ID receiver, IFNULL(o.OFFER_PRIZE,0) - IFNULL(o.OFFER_GRATUITY,0) coins
from game.t_offer_apply oa 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
inner join forum.t_user u on o.USER_ID = u.USER_CODE
inner join forum.t_user u2 on oa.USER_ID = u2.USER_CODE and (u.user_id =@user_id or u2.user_id =@user_id)
) t group by t.sender,t.receiver
on duplicate key update 
coins = values(coins);


-- 转账
insert into t_inner_user(user_id,item_event,sender,receiver,coins)
select @user_id,'转账',t.sender,t.receiver,sum(t.MONEY) coins from (
SELECT t.user_id sender,t.tuser_id receiver,t.MONEY
FROM forum.t_user_present t
inner join forum.t_user u on t.USER_ID=u.USER_ID and u.user_id =@user_id

union all 

SELECT t.user_id sender,t.tuser_id receiver,t.MONEY
FROM forum.t_user_present t
inner join forum.t_user u on t.TUSER_ID=u.USER_ID and u.user_id =@user_id
) t
group by t.sender,t.receiver
on duplicate key update 
coins = values(coins);

-- 红包
insert into t_inner_user(user_id,item_event,sender,receiver,coins)
select @user_id,'红包',u1.USER_ID sender,u2.USER_ID receiver,round(sum(t.TOTAL_MONEY)) coins from game.t_packet_item o
inner join game.t_packets t on o.PACKET_ID=t.ID 
inner join forum.t_user u1 on t.USER_ID=u1.USER_CODE and u1.user_id=@user_id
inner join forum.t_user u2 on o.RECIVE_USER=u2.USER_CODE 
group by o.RECIVE_USER
on duplicate key update 
coins = values(coins);

-- pk场
insert into t_inner_user(user_id,item_event,sender,receiver,coins)
select @user_id,'pk场',u1.USER_ID sender,u2.USER_ID receiver,ifnull(sum(t.PRIZE_MONEY),0)+ifnull(sum(t.RETURN_MONEY),0)-ifnull(sum(t.ITEM_MONEY),0) coins
from game.t_room_user tu
inner join forum.t_user u1 on tu.USER_ID=u1.USER_CODE and u1.user_id =@user_id
inner join game.t_clubs_order t on tu.ROOM_ID=t.CLUBS_INFO_ID
inner join forum.t_user u2 on t.USER_ID=u2.USER_CODE 
group by u2.USER_ID
on duplicate key update 
coins = values(coins);



