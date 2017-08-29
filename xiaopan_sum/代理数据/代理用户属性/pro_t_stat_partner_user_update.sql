CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_stat_partner_user_update`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN     
	DECLARE counts int(11); 
	DECLARE indexs int(11);  
	DECLARE childs MEDIUMTEXT; 
	DECLARE is_new_user int(4); 
	DECLARE temp_ref_id int(11);
	DECLARE temp_last_id int(11);       
   
   select group_concat(t.REF_ID) ,count(1) into childs, counts from game.t_group_ref t 
	where t.UPDATE_TIME>(
	  select max(t.UPDATE_TIME) from report.t_stat_partner_user t 
	);
	
	set indexs=1;
   while indexs<=counts do
	      select convert(reverse(substring_index( reverse(substring_index(childs, ',', indexs)), ',', 1)),unsigned) into temp_ref_id;
	      
	   	select t.last_id,if(t.REF_STATUS=10,if(t.ADD_TIME=t.UPDATE_TIME,1,0),-1) into temp_last_id,is_new_user from game.t_group_ref t 
			where t.ref_id=temp_ref_id;
			
			-- 操作
			if is_new_user>0  -- 1.新增
			then 
					insert into report.t_stat_partner_user(ref_id,child_ref_id,update_time)
					select t.ref_id,temp_ref_id,t.update_time from report.t_stat_partner_user t where  t.child_ref_id=temp_last_id or t.ref_id=temp_last_id
					group by ref_id
					on duplicate key update 
					UPDATE_TIME = values(UPDATE_TIME);
					
			elseif is_new_user=-1  -- 2.删除
					then
					
					delete t from report.t_stat_partner_user t
					where t.ref_id in (
					   select ref_id from (
					   select t.ref_id from report.t_stat_partner_user t where t.child_ref_id=temp_ref_id
					   ) a
					)
					and t.child_ref_id in (
					   select child_ref_id from (
						select t.child_ref_id from report.t_stat_partner_user t where t.ref_id=temp_ref_id 
						union all
						select temp_ref_id from dual
						) b
					);
		
			else -- 3.修改
		
				   -- a.删除
				   
				   delete t from report.t_stat_partner_user t
					where t.ref_id in (
					   select ref_id from (
					   select t.ref_id from report.t_stat_partner_user t where t.child_ref_id=temp_ref_id
					   ) a
					)
					and t.child_ref_id in (
					   select child_ref_id from (
						select t.child_ref_id from report.t_stat_partner_user t where t.ref_id=temp_ref_id 
						union all
						select temp_ref_id from dual
						) b
					);
				
				
					-- b.增加
					insert into report.t_stat_partner_user(ref_id,child_ref_id,update_time)
					select t.ref_id,t1.child_ref_id,t1.update_time 
					from 
					(select t.ref_id from report.t_stat_partner_user t
					 where t.ref_id in (
						select ref_id from (
							select t.ref_id from report.t_stat_partner_user t where t.child_ref_id=temp_last_id
							union all
							select temp_last_id from dual
						) b
					 )
					 group by t.ref_id
					) t
					left join (
					   select child_ref_id,update_time from (
							select t.child_ref_id,t.update_time from report.t_stat_partner_user t where t.ref_id=temp_ref_id
							union all
							select t.ref_id,t.update_time from game.t_group_ref t where t.ref_id=temp_ref_id
						) a
					)t1 on 1=1
					on duplicate key update 
					UPDATE_TIME = values(UPDATE_TIME);
			end if ;
		
			set indexs=indexs+1;
			
	END WHILE; 
	
	update t_stat_partner_user t 
	inner join game.t_group_ref t1 on t.ref_id=t1.REF_ID 
	set t.user_id=t1.USER_ID
	where t.user_id is null;
	
	update t_stat_partner_user t 
	inner join game.t_group_ref t1 on t.child_ref_id=t1.REF_ID 
	set t.child_user_id=t1.USER_ID,
	t.crt_time=t1.CRT_TIME
	where t.child_user_id is null;
			
			
END