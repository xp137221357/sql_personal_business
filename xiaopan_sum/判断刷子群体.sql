select u.NICK_NAME,t.DEVICE_CODE from forum.t_user_event t 
inner join forum.t_user u on t.USER_ID = u.USER_ID 
and u.NICK_NAME in('一刀决胜','大战皇家赌场')
group by u.NICK_NAME,t.DEVICE_CODE

select u1.NICK_NAME,t1.ip,u2.NICK_NAME,t2.ip from (
select e.USER_ID,e.IP from forum.t_user_event e
inner join forum.t_user u on e.USER_ID = u.USER_ID 
and u.NICK_NAME in('BangBang爆','大强168','依心而行')
group by e.USER_ID,e.IP
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.IP from forum.t_user_event e
inner join forum.t_user u on e.USER_ID = u.USER_ID 
and u.NICK_NAME in('BangBang爆','大强168','依心而行')
group by e.USER_ID,e.IP
) t2 on t1.user_id !=t2.user_id and substr(t1.IP,1,6) =substr(t2.IP,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id
group by u1.USER_ID,u2.USER_ID;