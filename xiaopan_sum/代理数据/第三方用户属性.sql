insert into t_partner_user_info (USER_ID,FORUM_USER_ID,NICK_NAME,ACCT_NUM,USER_MOBILE,CRT_TIME,INVITE_CODE,JOIN_GROUP_TIME)
		select u.USER_CODE,u.USER_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_MOBILE,u.CRT_TIME,e.INVITE_CODE,r.CRT_TIME  
		from game.t_group_ref r
		inner join forum.t_user u on r.user_id = u.USER_CODE
		left join game.t_user_ext e on e.USER_ID = u.USER_CODE
		on duplicate key UPDATE 
		USER_MOBILE = VALUES(USER_MOBILE),
		CRT_TIME = VALUES(CRT_TIME),
		INVITE_CODE=VALUES(INVITE_CODE),
		NICK_NAME = VALUES(NICK_NAME),
		FORUM_USER_ID = VALUES(FORUM_USER_ID),
		ACCT_NUM = VALUES(ACCT_NUM);

insert into t_partner_user_info (USER_ID,FORUM_USER_ID,NICK_NAME,ACCT_NUM,USER_MOBILE,CRT_TIME,INVITE_CODE,LAST_ORDER_TIME)
		select u.USER_CODE,u.USER_ID,u.NICK_NAME,u.ACCT_NUM,u.USER_MOBILE,u.CRT_TIME,e.INVITE_CODE,
		(select i.CRT_TIME from game.t_order_item i 
		 where i.user_id = #{value} 
		 order by i.crt_time desc limit 1) from forum.t_user u 
		 left join game.t_user_ext e on e.USER_ID = u.USER_CODE
		 where u.user_code = #{value}
		on duplicate key UPDATE USER_MOBILE = VALUES(USER_MOBILE),
		CRT_TIME = VALUES(CRT_TIME),INVITE_CODE=VALUES(INVITE_CODE),
		LAST_ORDER_TIME = VALUES(LAST_ORDER_TIME),
		NICK_NAME = VALUES(NICK_NAME),
		FORUM_USER_ID = VALUES(FORUM_USER_ID),
		ACCT_NUM = VALUES(ACCT_NUM);





BEGIN     
	
	DECLARE CUR_REF_ID BIGINT(19);
	DECLARE MAX_REF_ID BIGINT(19);

	set CUR_REF_ID=1;	
	
	select max(ref_id) into MAX_REF_ID from game.t_group_ref;

	WHILE CUR_REF_ID<=MAX_REF_ID DO	

		insert into t_partner_order_info (USER_ID,LAST_ORDER_TIME)
		select user_id,max(crt_time) 
		from game.t_order_item o
		inner join game.t_group_ref tf on o.USER_ID=tf.USER_ID and tf.REF_ID=CUR_REF_ID
		on duplicate key 
		UPDATE LAST_ORDER_TIME = VALUES(LAST_ORDER_TIME);
		
		insert into t_partner_order_info (USER_ID,OFFICIAL_PAY_NUMBER,OFFICIAL_PAY_MONEY,OTHER_PAY_NUMBER,OTHER_PAY_MONEY)
		select * from (
			select
			tf.USER_ID,
			1 OFFICIAL_PAY_NUMBER,
			1 OTHER_PAY_MONEY,
			sum(if(tc.charge_method='app',tc.coins,0)) OFFICIAL_PAY_MONEY,
			sum(if(tc.charge_method！='app',tc.coins,0)) OTHER_PAY_MONEY
			from report.t_trans_user_recharge_coin tc 
			inner join forum.t_user u on tc.charge_user_id=u.USER_ID
			inner join game.t_group_ref tf on tf.USER_ID=u.USER_CODE and tf.REF_ID=CUR_REF_ID
			and tc.crt_time>=date_add(curdate(),interval -12 hour)
			and tc.crt_time< date_add(curdate(),interval 12 hour)
		) t where t.USER_ID is not null
		on duplicate key UPDATE 
		OFFICIAL_PAY_NUMBER = VALUES(OFFICIAL_PAY_NUMBER),
		OFFICIAL_PAY_MONEY = VALUES(OFFICIAL_PAY_MONEY),
		OTHER_PAY_NUMBER = VALUES(OTHER_PAY_NUMBER),
		OTHER_PAY_MONEY = VALUES(OTHER_PAY_MONEY);
		 		
		set CUR_REF_ID=CUR_REF_ID+1;

	END WHILE;    
	
END