




select t2.num,t1.* from (select * from forum.t_user u limit 100) t1,(select count(1) num from forum.t_user u ) t2;


select * from forum.t_user u 
  left join (select count(1) num,user_id from forum.t_user u ) t2 on t2.user_id=u.USER_ID and t2.user_id=41 
  limit 100;