set @nick_name='风中追风';


select u1.NICK_NAME '创建房间者',u2.NICK_NAME '投注参与者',u1.USER_ID,tu.ROOM_ID 
from game.t_room_user tu
inner join forum.t_user u1 on tu.USER_ID=u1.USER_CODE and u1.NICK_NAME =@nick_name
inner join game.t_clubs_order t on tu.ROOM_ID=t.CLUBS_INFO_ID
inner join forum.t_user u2 on t.USER_ID=u2.USER_CODE
group by u2.USER_ID 


