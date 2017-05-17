-- 设备
select t1.*,t2.* from (
select u.NICK_NAME '昵称',u.CRT_TIME '注册时间',e.USER_ID ,e.DEVICE_CODE 
from  forum.t_user_event e 
inner join forum.t_user u on u.user_id =e.user_id and u.NICK_NAME in ('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来','byzq2187669','byzq2131362','byzq2187669','痛快淋漓','西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
group by e.USER_ID,e.DEVICE_CODE
) t1 
left join (
select u.NICK_NAME '昵称',u.CRT_TIME '注册时间',e.USER_ID ,e.DEVICE_CODE 
from  forum.t_user_event e 
inner join forum.t_user u on u.user_id =e.user_id and u.NICK_NAME in ('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来','byzq2187669','byzq2131362','byzq2187669','痛快淋漓','西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
group by e.USER_ID,e.DEVICE_CODE
) t2 on t1.DEVICE_CODE = t2.DEVICE_CODE and t1.user_id !=t2.user_id
where t2.USER_ID is not null;


-- IP
select t1.*,t2.* from (
select u.NICK_NAME '昵称',u.CRT_TIME '注册时间',e.USER_ID ,e.IP 
from  forum.t_user_event e 
inner join forum.t_user u on u.user_id =e.user_id and u.NICK_NAME in ('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来','byzq2187669','byzq2131362','byzq2187669','痛快淋漓','西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
group by e.USER_ID,e.IP
) t1 
left join (
select u.NICK_NAME '昵称',u.CRT_TIME '注册时间',e.USER_ID ,e.IP 
from  forum.t_user_event e 
inner join forum.t_user u on u.user_id =e.user_id and u.NICK_NAME in ('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来','byzq2187669','byzq2131362','byzq2187669','痛快淋漓','西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
group by e.USER_ID,e.IP
) t2 on t1.user_id !=t2.user_id and substr(t1.IP,1,6) =substr(t2.IP,1,6)
where t2.USER_ID is not null;

-- 购买一元礼包
select u.NICK_NAME,ai.* from forum.t_acct_items ai
inner join forum.t_user u on u.user_id =ai.user_id and
u.NICK_NAME in ('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来','byzq2187669','byzq2131362','byzq2187669','痛快淋漓','西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
and ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%';

-- 开房投注


select t1.*,t2.* from 
(
select u.NICK_NAME '创建房间者',u.USER_ID,tu.ROOM_ID from game.t_room_user tu
inner join forum.t_user u
	on tu.USER_ID=u.USER_CODE and u.NICK_NAME in 
	('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来',
	'byzq2187669','byzq2131362','byzq2187669','痛快淋漓',
	'西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
)t1 
left join (
select u.NICK_NAME '在房间投注者',u.USER_ID,t.CLUBS_INFO_ID from game.t_clubs_order t 
inner join forum.t_user u
	on t.USER_ID=u.USER_CODE and t.ORDER_TYPE=2 and u.NICK_NAME in 
	('早啊压力','淖琥','赢出一个未来','日超通讯','王者荣耀归来',
	'byzq2187669','byzq2131362','byzq2187669','痛快淋漓',
	'西红','落幕\ue108','byzq2131362','byzq3585804','byzq2131362','赢得心态')
)t2 on t1.ROOM_ID=t2.CLUBS_INFO_ID
group by t1.user_id,t2.user_id;







