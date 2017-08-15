
-- 冷刀.山东”"慕容.广东
create table t_stat_inner_ip_address
select * from (
select substring(e.ip,1,length(e.ip)-locate('.',reverse(e.ip))) inner_ip,count(1) counts from forum.t_user_event e 
where e.USER_ID in (select user_id from forum.t_user u where u.NICK_NAME in ('冷刀·山东','慕容·广东'))
group by inner_ip ) t where t.counts>10
;


-- 去公司内网ip
update t_user_bets20170605 t 
inner join forum.t_user_event e on t.USER_ID=e.USER_ID and t.user_status=10
and (e.IP like '218.17%' or e.IP like '158.239%')
set t.user_status=-11 ;

