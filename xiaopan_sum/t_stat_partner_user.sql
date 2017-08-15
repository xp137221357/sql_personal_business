BEGIN     
	DECLARE temp_ref_id bigint(19);      
	DECLARE temp_last_id bigint(19);
	DECLARE cur_ref_id bigint(19);
	DECLARE max_ref_id bigint(19); 
	DECLARE refer_date date;
	DECLARE start_size bigint(11);  -- 避免死循环,手动时去掉，严重影响效率
	DECLARE end_size bigint(11); -- 避免死循环，手动时去掉，严重影响效率
	
	set cur_ref_id=1;
	set refer_date='2017-07-20';

   select max(ref_id) into max_ref_id from game.t_group_ref where update_time<refer_date;

	WHILE cur_ref_id<=max_ref_id DO	
      
      set temp_ref_id=0;
      set start_size=0;
      set end_size=1;
      
       select ifnull(t.REF_ID,0),ifnull(t.LAST_ID,0) into temp_ref_id,temp_last_id from 
		 (select 1 from dual) t1
		 left join game.t_group_ref t on 1=1 and  t.REF_ID=cur_ref_id;
		 
	   -- WHILE temp_last_id>0 DO
		 WHILE temp_last_id>0 and end_size>start_size  DO	
		 
		   set start_size=end_size; 
		   
			insert into t_stat_partner_user(stat_date,ref_id,child_ref_id,update_time)
		
			select refer_date,t.LAST_ID,cur_ref_id,t.UPDATE_TIME from game.t_group_ref t where t.REF_ID=temp_ref_id and t.LAST_ID>0 and t.UPDATE_TIME<refer_date
			
			on duplicate key update 
			REF_ID = values(REF_ID),
			CHILD_REF_ID = values(CHILD_REF_ID),
			UPDATE_TIME = values(UPDATE_TIME);
			
			select t.LAST_ID into temp_ref_id from game.t_group_ref t where t.REF_ID =temp_ref_id;
			
			select count(1) into end_size from t_stat_partner_user t where t.stat_date=refer_date;
			
			
		END WHILE;  
		
		set cur_ref_id=cur_ref_id+1;

	END WHILE;    
	
END