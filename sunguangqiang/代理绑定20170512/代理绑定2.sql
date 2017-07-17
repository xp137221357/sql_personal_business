set @param0='2017-01-01';
set @param1='2017-02-01';
set @param2='一月份';

-- 山东代理设备数关联其他用户（去自己）
select t1.user_id from (
select e.user_id from forum.t_user_event e 
inner join (
	select e.DEVICE_CODE from forum.t_user_event e 
	inner join (
	
		SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE and tg.user_id='5962840904510621262'
		
		union  
		
		select user_id from report.t_user_general_agent t where t.comments='shandong'
	 
	) t on e.USER_ID=t.user_id
	group by e.DEVICE_CODE
) tt on e.DEVICE_CODE=tt.DEVICE_CODE
group by e.USER_ID
) t1
left join (

		SELECT 
		       u.user_id
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

) t2 on t1.user_id =t2.user_id
where t2.user_id is null;


-- 山东代理设备数关联内部推广用户（去自己）
select t1.USER_ID from (
select e.user_id from forum.t_user_event e 
inner join (
	select e.DEVICE_CODE from forum.t_user_event e 
	inner join (
	
		SELECT 
		       u.user_id
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
	 
	) t on e.USER_ID=t.user_id
	group by e.DEVICE_CODE
) tt on e.DEVICE_CODE=tt.DEVICE_CODE
group by e.USER_ID
) t1 
inner join (
      SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
) t2 on t1.USER_ID=t2.user_id 
left join (

		SELECT 
		       u.user_id
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

) t3 on t1.user_id =t3.user_id
where t3.user_id is null;




