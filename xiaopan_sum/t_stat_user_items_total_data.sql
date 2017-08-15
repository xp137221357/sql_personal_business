BEGIN     
	
	DECLARE cur_user_id BIGINT(19);
	DECLARE max_user_id BIGINT(19);
	DECLARE stat_time datetime;
	
	set stat_time=date('2017-07-21');
	set cur_user_id=3775842;	
	set max_user_id=11042400;

	WHILE cur_user_id<=max_user_id DO	
	
		
      
      insert into t_stat_user_items_total_data_20170724(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE)
		select ai.user_id,ai.ITEM_EVENT,ai.ACCT_TYPE,sum(ai.CHANGE_VALUE) CHANGE_VALUE 
		from forum.t_acct_items ai
		inner join forum.t_user u on ai.user_id =u.USER_ID and u.CLIENT_ID='byapp' and u.CRT_TIME<stat_time
		where ai.USER_ID = cur_user_id
		and ai.pay_time<stat_time
		group by ai.ITEM_EVENT,ai.ACCT_TYPE
		on duplicate key update 
		CHANGE_VALUE = values(CHANGE_VALUE);
		 
		
		set cur_user_id=cur_user_id+1;

	END WHILE;    
	
END