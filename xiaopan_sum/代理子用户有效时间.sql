set @param0='2017-01-01';
set @param1='2017-02-01';

-- 代理有效时间，加入代理组时间 

truncate t_group_partner20170607

insert into t_group_partner20170607(USER_ID,user_code,add_time,cancel_time,is_valid,CRT_TIME)
select u.USER_ID,t.* from (
SELECT 
    u.user_code,tg.crt_time add_time,tg.cancel_time,tg.is_valid,r1.CRT_TIME
FROM   forum.t_user u
INNER JOIN game.t_group_ref r1
      ON u.user_code = r1.user_id  
INNER JOIN game.t_group_ref r2
      ON r1.root_id = r2.ref_id
INNER JOIN forum.t_user u2
      ON r2.user_id = u2.user_code
inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  
      and u.client_id = 'BYAPP'
group by u.USER_ID

union

select tg.user_id,tg.crt_time,tg.cancel_time,tg.is_valid,tg.crt_time from report.t_partner_group tg
) t 
inner join forum.t_user u on t.user_code=u.USER_CODE 
group by u.USER_ID ;




update t_group_partner20170607 t set t.start_time=if(t.crt_time>t.add_time,t.crt_time,t.add_time);


update t_group_partner20170607 t set t.end_time=if(t.cancel_time is not null,t.cancel_time,'2017-06-01');











