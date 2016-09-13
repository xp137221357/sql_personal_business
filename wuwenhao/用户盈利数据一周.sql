set @beginTime='2016-07-18 10:00:00';
set @endTime = '2016-07-25 10:00:00';
/*
CASE
WHEN ai.item_src = 3 THEN '微信'
WHEN ai.item_src = 4 THEN '支付宝'
WHEN ai.item_src = 9 THEN '苹果'
WHEN ai.item_src = 10 THEN '苹果沙箱'
WHEN ai.item_src = 11 THEN '百度支付'
WHEN ai.item_src = 0 THEN '系统'
WHEN ai.item_src = 6 THEN '银行卡'
ELSE ai.item_src
END
*/

       

-- 所有用户全部盈利数据
select '所有用户全部盈利数据',t.* from (
select count(o.USER_ID) bet_counts,u.nick_name,sum(o.PRIZE_MONEY)-sum(o.item_money) p_money ,u.USER_MOBILE from game.t_order_item o
inner join forum.t_user u ON o.USER_ID = u.user_code 
where o.CRT_TIME>=@beginTime
and o.CRT_TIME<=@endTime
group by o.USER_ID
) t order by t.p_money desc limit 20;


select tb.job_name sql_name,tb.sql_excuted sql_content,tb.work_status sql_database from t_job tb where tb.job_name like '%t%'

select tb.job_name sql_name,tb.sql_excuted sql_content,tb.work_status sql_database from t_job tb where tb.job_name like '%device%' limit 0, 5


-- 所有用户滚球盈利数据
select '所有用户滚球盈利数据',t.* from (
select count(o.USER_ID) bet_counts,u.nick_name,sum(o.PRIZE_MONEY)-sum(o.item_money) p_money ,u.USER_MOBILE from game.t_order_item o
inner join forum.t_user u ON o.USER_ID = u.user_code 
where o.CRT_TIME>=@beginTime
and o.CRT_TIME<=@endTime
and o.IS_INPLAY = 0
group by o.USER_ID
) t order by t.p_money desc limit 20;

-- 新用户全部盈利数据
select '新用户全部盈利数据',t.* from (
select count(o.USER_ID) bet_counts,u.nick_name,sum(o.PRIZE_MONEY)-sum(o.item_money) p_money ,u.USER_MOBILE from game.t_order_item o
inner join forum.t_user u ON o.USER_ID = u.user_code and (u.CRT_TIME>='2016-06-18' and u.CRT_TIME<=@endTime)
where o.CRT_TIME>=@beginTime
and o.CRT_TIME<=@endTime
group by o.USER_ID
) t order by t.p_money desc limit 20;


-- 新用户滚球盈利数据
select '新用户滚球盈利数据',t.* from (
select (o.USER_ID) bet_counts,u.nick_name,sum(o.PRIZE_MONEY)-sum(o.item_money) p_money ,u.USER_MOBILE from game.t_order_item o
inner join forum.t_user u ON o.USER_ID = u.user_code and (u.CRT_TIME>='2016-06-18' and u.CRT_TIME<=@endTime)
where o.CRT_TIME>=@beginTime
and o.CRT_TIME<=@endTime
and o.IS_INPLAY = 0
group by o.USER_ID
) t order by t.p_money desc limit 20;

select tb.job_name sql_name,tb.sql_excuted sql_content,tb.work_status sql_database from t_job tb  limit 25, 6;

select tb.job_name sql_name,tb.sql_excuted sql_content,tb.work_status sql_database,tb.work_status sql_comments from t_job tb  limit 30, 5


select * from t_job tb


