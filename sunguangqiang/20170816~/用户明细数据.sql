



select u.NICK_NAME,u.ACCT_NUM,ai.USER_ID,ai.ITEM_EVENT,sum(ai.CHANGE_VALUE) 
		from forum.t_acct_items ai 
		inner join forum.t_user u on ai.USER_ID=u.USER_ID
		where ai.ITEM_STATUS=10
		and ai.ACCT_TYPE=1001
		and ai.PAY_TIME>=date_add(curdate(),interval -1 day)
		and ai.PAY_TIME<curdate()
		group by ai.USER_ID,ai.ITEM_EVENT;
		
		
		
		
		select ai.ITEM_EVENT
		from forum.t_acct_items ai 
		where ai.ITEM_STATUS=10
		and ai.ACCT_TYPE=1001
		and ai.PAY_TIME>=date_add(curdate(),interval -1 month)
		and ai.PAY_TIME<curdate()
		group by ai.ITEM_EVENT;
		
		