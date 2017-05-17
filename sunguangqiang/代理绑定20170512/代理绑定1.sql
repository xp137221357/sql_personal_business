set @param1='2017-06-01';
set @param2='一月份';

-- 用户数
select count(distinct t.user_code) from (
SELECT 
       u.user_id user_code
FROM   forum.t_user u
INNER JOIN game.t_group_ref r1
      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
INNER JOIN game.t_group_ref r2
      ON r1.root_id = r2.ref_id
INNER JOIN forum.t_user u2
      ON r2.user_id = u2.user_code
      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='shandong')
		and u.client_id = 'BYAPP'

union  

select user_code from report.t_user_general_agent t where t.comments='shandong'
) t 

union all
		
  
-- 山东代理设备数


select count(distinct e.DEVICE_CODE) from forum.t_user_event e 
inner join (

   SELECT 
          u.user_id user_id
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='shandong')
			and u.client_id = 'BYAPP'
	
	union  
	
	select user_code from report.t_user_general_agent t where t.comments='shandong'
 
) t1 on e.USER_ID=t1.user_id


union all

-- 关联山东代理设备数的用户数
select count(distinct e.user_id) from forum.t_user_event e 
inner join (
	select e.DEVICE_CODE from forum.t_user_event e 
	inner join (
	
	   SELECT 
	          u.user_id user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='shandong')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='shandong'
	 
	) t1 on e.USER_ID=t1.user_id
	group by e.DEVICE_CODE
) t1 on e.DEVICE_CODE=t1.DEVICE_CODE;
	
	
	


