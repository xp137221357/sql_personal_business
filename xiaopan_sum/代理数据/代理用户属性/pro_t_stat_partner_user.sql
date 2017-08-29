CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_stat_partner_user`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN         
   DECLARE temp_last_id bigint(19);
	DECLARE temp_ref_id bigint(19);
	DECLARE cur_ref_id bigint(19);
	DECLARE max_ref_id bigint(19); 
	DECLARE refer_date date;
	
	-- *避免死循环影响效率，1000次纠正一次，提高效率
	DECLARE counts int(11);  
	DECLARE max_counts int(11);
	set counts=0;
	set max_ref_id=0;
	set max_counts=1000;
	 
	set cur_ref_id=1;
	set refer_date=curdate();

   select max(ref_id) into max_ref_id from game.t_group_ref where update_time<refer_date;

	WHILE cur_ref_id<=max_ref_id DO	
      
      set counts=0;
      set temp_ref_id=0;
      set temp_last_id=0;
      
      select t.REF_ID,t.LAST_ID into temp_ref_id,temp_last_id from game.t_group_ref t where  t.REF_ID=cur_ref_id;
		
		WHILE temp_last_id>0 and temp_ref_id>0 and counts<max_counts DO	
		 
		   insert into t_stat_partner_user(ref_id,child_ref_id,update_time)
			
			select t.LAST_ID,cur_ref_id,t.UPDATE_TIME from game.t_group_ref t where t.REF_ID=temp_ref_id and t.LAST_ID>0 and t.UPDATE_TIME<refer_date
			
			on duplicate key update 
			REF_ID = values(REF_ID),
			CHILD_REF_ID = values(CHILD_REF_ID),
			UPDATE_TIME = values(UPDATE_TIME);
			
			select t.LAST_ID into temp_ref_id from game.t_group_ref t where t.REF_ID =temp_ref_id;
			
		
		   set counts=counts+1;
		   
		END WHILE;  
		
		set cur_ref_id=cur_ref_id+1;

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