
-- 东方红天下 69E6FA36-5605-4A6C-AF9A-606C4A4EC648
-- 红赢大侠 69E6FA36-5605-4A6C-AF9A-606C4A4EC648


select u.NICK_NAME,u.USER_ID,ti.DEVICE_CODE,ti.CRT_TIME 
from forum.t_user_event ti
inner join forum.t_user u on ti.USER_ID = u.USER_ID
and u.NICK_NAME= '红赢大侠';

select * from forum.t_user_event e 
where e.DEVICE_CODE='69E6FA36-5605-4A6C-AF9A-606C4A4EC648'
group by e.USER_ID;
