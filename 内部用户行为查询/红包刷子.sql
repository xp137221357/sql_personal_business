-- 红包刷子

set @nick_name='风中追风';

select u1.nick_name '发送人',u2.NICK_NAME '接收人',round(sum(t.TOTAL_MONEY)) '接收金额',count(DISTINCT t.USER_ID) '发送人数',count(1) '发送次数' from game.t_packet_item o
inner join game.t_packets t on o.PACKET_ID=t.ID 
inner join forum.t_user u1 on t.USER_ID=u1.USER_CODE and u1.NICK_NAME=@nick_name
inner join forum.t_user u2 on o.RECIVE_USER=u2.USER_CODE 
group by o.RECIVE_USER;