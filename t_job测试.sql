
-- 日
UPDATE `report`.`t_job` SET `cron_express`='0 39 04 * * ?' WHERE  `cron_express`='0 46 15 * * ?';

UPDATE `report`.`t_job` SET `next_time_execute`='2016-07-20 04:39:00' WHERE  `next_time_execute`='2016-07-22 15:46:00';

commit;

-- 周
UPDATE `report`.`t_job` SET `next_time_execute`='2016-07-08 08:00:00' WHERE  `next_time_execute`='2016-07-25 08:00:00';
commit;

-- 月
UPDATE `report`.`t_job` SET `next_time_execute`='2016-07-01 09:00:00' WHERE  `next_time_execute`='2016-08-01 09:00:00';

select * from t_job

show processlist;

kill 740616 


UPDATE `report`.`t_job` SET `job_name`= concat('[t_stat_user_life_cycle]',job_name)  WHERE job_name like '%月' and job_name not like '%t_stat_user_life_cycle%'