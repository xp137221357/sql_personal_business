BEGIN     
	
	DECLARE CUR_REF_ID BIGINT(19);
	DECLARE TEMP_REF_ID BIGINT(19);
	DECLARE MAX_REF_ID BIGINT(19);

	set CUR_REF_ID=1;	
	
	select max(ref_id) into MAX_REF_ID from game.t_group_ref;

	WHILE CUR_REF_ID<=MAX_REF_ID DO	
      
      set TEMP_REF_ID=-1;
      select t.REF_ID into TEMP_REF_ID from game.t_group_ref t where t.REF_ID=CUR_REF_ID; 
      if TEMP_REF_ID>0 
      then
	      -- 投注结算
	      insert into t_stat_partner_order_info (STAT_TIME,TYPE,USER_ID,ITEM_ALL_MONEY,ITEM_MONEY,PRIZE_ALL_MONEY,PRIZE_MONEY,PROFIT_ALL_COIN,PROFIT_COIN,EFFECTIVE_MONEY,LAST_ORDER_TIME)
	      select * from (
				select 
				date_add(curdate(),interval -1 day) STAT_TIME,
				1,
				t.USER_ID,
				sum(t.ITEM_MONEY) ITEM_ALL_MONEY,
				sum(t.COIN_BUY_MONEY) ITEM_MONEY,
				sum(t.PRIZE_MONEY) PRIZE_ALL_MONEY,
				sum(t.COIN_PRIZE_MONEY) PRIZE_MONEY,
				sum(t.ITEM_MONEY - t.PRIZE_MONEY) PROFIT_ALL_COIN,
				sum(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) PROFIT_COIN,
				sum(case when t.pass_type = '1001' and t.MATCH_ODDS >= 1.5 then ABS(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) else 0 end ) EFFECTIVE_MONEY,
				max(t.PAY_TIME) LAST_ORDER_TIME
				from (
					select 
						o.item_id,
						o.USER_ID,
						o.PASS_TYPE,
						o.ITEM_STATUS,
						o.ITEM_MONEY,
						o.COIN_BUY_MONEY,
						IFNULL(o.PRIZE_MONEY,0) + ifnull(o.RETURN_MONEY,0) PRIZE_MONEY,
						IFNULL(o.COIN_PRIZE_MONEY,0) + IFNULL(o.COIN_RETURN_MONEY,0) COIN_PRIZE_MONEY,
						o.BALANCE_TIME,
						o.PAY_TIME,
						c.MATCH_ODDS
					from game.t_order_item o
					inner join game.t_group_ref tf on o.USER_ID=tf.USER_ID and tf.REF_ID=TEMP_REF_ID
					left join game.t_item_content c on c.ITEM_ID = o.item_id
					where o.crt_time >= tf.CRT_TIME
					and o.item_status not in (0,10,-5,-10,200,210)
					and o.BALANCE_TIME>=date_add(curdate(),interval -12 hour)
					and o.BALANCE_TIME< date_add(curdate(),interval 12 hour)
					group by o.item_id  
				) t
			)tt where tt.user_id is not null
			on duplicate key update  
			ITEM_ALL_MONEY = VALUES(ITEM_ALL_MONEY),
			ITEM_MONEY = VALUES(ITEM_MONEY),
			PRIZE_ALL_MONEY = VALUES(PRIZE_ALL_MONEY),
			PRIZE_MONEY = VALUES(PRIZE_MONEY),
			PROFIT_ALL_COIN = VALUES(PROFIT_ALL_COIN),
			PROFIT_COIN = VALUES(PROFIT_COIN),
			EFFECTIVE_MONEY = VALUES(EFFECTIVE_MONEY),
			LAST_ORDER_TIME = VALUES(LAST_ORDER_TIME);
			
			
			-- 充值情况
			insert into t_stat_partner_order_info (STAT_TIME,TYPE,USER_ID,OFFICIAL_PAY_NUMBER,OFFICIAL_PAY_MONEY,OTHER_PAY_NUMBER,OTHER_PAY_MONEY)
			select * from (
				select date_add(curdate(),interval -1 day) STAT_TIME,
				1,
				t.user_id,
				if(t.OFFICIAL_PAY_MONEY>0,1,0) OFFICIAL_PAY_NUMBER,
				t.OFFICIAL_PAY_MONEY,
				if(t.OTHER_PAY_MONEY>0,1,0) OTHER_PAY_NUMBER,
				t.OTHER_PAY_MONEY
				 from (
					select 
					tc.user_id,
					sum(if(tc.charge_method='app',tc.rmb_value,0)) OFFICIAL_PAY_MONEY,
					sum(if(tc.charge_method!='app',tc.rmb_value,0)) OTHER_PAY_MONEY
					from (
						select tf.user_id,tc.charge_method,tc.rmb_value from report.t_trans_user_recharge_coin tc 
						inner join forum.t_user u on tc.charge_user_id=u.USER_ID
						inner join game.t_group_ref tf on tf.USER_ID=u.USER_CODE and tf.REF_ID=TEMP_REF_ID
						and tc.crt_time>=date_add(curdate(),interval -12 hour)
						and tc.crt_time< date_add(curdate(),interval 12 hour)
						
						union all 
						
						select tf.user_id,tc.charge_method,tc.rmb_value from report.t_trans_user_recharge_diamond tc 
						inner join forum.t_user u on tc.charge_user_id=u.USER_ID
						inner join game.t_group_ref tf on tf.USER_ID=u.USER_CODE and tf.REF_ID=TEMP_REF_ID
						and tc.crt_time>=date_add(curdate(),interval -12 hour)
						and tc.crt_time< date_add(curdate(),interval 12 hour)
					) tc
				) t
			) t where t.USER_ID is not null
			on duplicate key UPDATE 
			OFFICIAL_PAY_NUMBER = VALUES(OFFICIAL_PAY_NUMBER),
			OFFICIAL_PAY_MONEY = VALUES(OFFICIAL_PAY_MONEY),
			OTHER_PAY_NUMBER = VALUES(OTHER_PAY_NUMBER),
			OTHER_PAY_MONEY = VALUES(OTHER_PAY_MONEY);
			
		end if;
		set CUR_REF_ID=CUR_REF_ID+1;

	END WHILE;    
	
	-- 刷充值人员的最后投注时间
	insert into t_stat_partner_order_info(STAT_TIME,TYPE,USER_ID,LAST_ORDER_TIME)
	select t.STAT_TIME,1,t.USER_ID,max(o.PAY_TIME) from t_stat_partner_order_info t 
	inner join game.t_order_item o on t.USER_ID=o.USER_ID and t.LAST_ORDER_TIME is null and t.STAT_TIME=date_add(curdate(),interval -1 day)
	and o.item_status not in (0,10,-5,-10,200,210)
	group by t.USER_ID
	on duplicate key update  
	LAST_ORDER_TIME = VALUES(LAST_ORDER_TIME);
	
	-- 更新ref_id,last_id
	
	insert into t_stat_partner_order_info(STAT_TIME,TYPE,USER_ID,USER_ADD_TIME,USER_CRT_TIME,REF_ID,LAST_ID,ROOT_ID)
	select t.STAT_TIME,1,t.USER_ID,tf.ADD_TIME,tf.CRT_TIME,tf.REF_ID,tf.LAST_ID,tf.ROOT_ID from t_stat_partner_order_info t 
	inner join game.t_group_ref tf on tf.USER_ID=t.USER_ID and t.`TYPE`=1 and t.REF_ID is null and t.STAT_TIME=date_add(curdate(),interval -1 day)
	on duplicate key update 
	USER_ADD_TIME = VALUES(USER_ADD_TIME), 
	USER_CRT_TIME = VALUES(USER_CRT_TIME), 
	REF_ID = VALUES(REF_ID),
	LAST_ID = VALUES(LAST_ID),
	ROOT_ID = VALUES(ROOT_ID);
	
	
END