

insert into report.t_stat_user_online(stat_time,user_id)
select date(u.LAST_ONLINE_TIME) stat_time,user_id
from forum.t_user u 
where u.LAST_ONLINE_TIME>=curdate()
and u.LAST_ONLINE_TIME<=date_add(curdate(),interval 1 day)
on duplicate key update 
stat_time = values(stat_time);


-- 当天
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select date(u.LAST_ONLINE_TIME) stat_time,'1',count(1),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'') 
from forum.t_user u 
inner join forum.t_user_event e on u.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where u.LAST_ONLINE_TIME>=curdate()
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);

-- 前一天
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select ts.stat_time,'1',count(1),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'') 
from report.t_stat_user_online ts 
inner join forum.t_user_event e on ts.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where ts.STAT_TIME>=date_add(curdate(),interval -1 day)
and ts.STAT_TIME<curdate()
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);


-- 上周
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select date_format(ts.stat_time,'%x%v'),'2',count(distinct ts.user_id),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'') 
from report.t_stat_user_online ts 
inner join forum.t_user_event e on ts.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where ts.STAT_TIME>=date_add(curdate(), interval -5-dayofweek(curdate()) day)
and ts.STAT_TIME<date_add(curdate(), interval 2-dayofweek(curdate()) day)
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);

-- 当周
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select date_format(ts.stat_time,'%x%v'),'2',count(distinct ts.user_id),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'')  
from report.t_stat_user_online ts 
inner join forum.t_user_event e on ts.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where ts.STAT_TIME>=date_add(curdate(), interval 2-dayofweek(curdate()) day)
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);

-- 上月
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select date_format(ts.stat_time,'%Y-%m'),'3',count(distinct ts.user_id),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'') 
from report.t_stat_user_online ts 
inner join forum.t_user_event e on ts.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where ts.STAT_TIME>=date_add(date_add(last_day(curdate()),interval -2 month),interval 1 day)
and ts.STAT_TIME<=concat(date_add(last_day(curdate()),interval -1 month),' 23:59:59')
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);

-- 当月
insert into report.t_rpt_overview(period_name,period_type,active_unum,channel_no,device_type,app_version)
select date_format(ts.stat_time,'%Y-%m'),'3',count(distinct ts.user_id),ifnull(e.CHANNEL_NO,''),ifnull(e.SYSTEM_MODEL,''),ifnull(e.APP_VERSION,'') 
from report.t_stat_user_online ts 
inner join forum.t_user_event e on ts.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
where ts.STAT_TIME>=date_add(date_add(last_day(curdate()),interval -1 month),interval 1 day)
group by e.CHANNEL_NO
on duplicate key update 
active_unum = values(active_unum);


