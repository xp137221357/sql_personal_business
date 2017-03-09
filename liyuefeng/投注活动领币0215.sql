-- set param=['2017-02-08','2017-02-14 23:59:59'];
set @param0='2017-02-08';
set @param1='2017-02-14 23:59:59';

select ta.`DESC` '事件',count(user_id) '参与人数',
case ta.ID
when 1 then count(user_id)*1000
when 4 then count(user_id)*1000
when 7 then count(user_id)*500
when 10 then count(user_id)*500
when 13 then count(user_id)*500
when 16 then count(user_id)*500
when 19 then count(user_id)*500
end as '领取金币'
from t_user_task t 
inner join t_task ta on t.TASK_ID=ta.ID and ta.ID in (1,4,7,10,13,16,19)
and t.PRIZE_TIME>=@param0 and t.PRIZE_TIME<=@param1
group by ta.ID;


