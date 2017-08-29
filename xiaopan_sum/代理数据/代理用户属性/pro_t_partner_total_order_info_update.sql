CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_partner_total_order_info_update`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN     
	
	DECLARE CUR_REF_ID BIGINT(19);
	DECLARE TEMP_REF_ID BIGINT(19);
	DECLARE MAX_REF_ID BIGINT(19);
	DECLARE STR_REF_ID MEDIUMTEXT;
	DECLARE CUR_USER_ID VARCHAR(50);
	DECLARE STAT_TIME DATETIME;
	DECLARE MAX_STAT_TIME DATETIME;

   set STAT_TIME='2017-08-01';
   set MAX_STAT_TIME='2017-08-27';
   
   WHILE STAT_TIME<=MAX_STAT_TIME DO
		set CUR_REF_ID=1;	
		
		select max(ref_id) into MAX_REF_ID from game.t_group_ref;
	
		WHILE CUR_REF_ID<=MAX_REF_ID DO	
	      
	      set TEMP_REF_ID=-1;
	      select t.REF_ID,t.USER_ID into TEMP_REF_ID,CUR_USER_ID from game.t_group_ref t where t.REF_ID=CUR_REF_ID; 
	      -- 投注结算
	      if TEMP_REF_ID>0 
	      then
		      insert into t_partner_total_order_info (STAT_TIME,USER_ID,ITEM_ALL_MONEY,ITEM_MONEY,PRIZE_ALL_MONEY,PRIZE_MONEY,PROFIT_ALL_COIN,PROFIT_COIN,EFFECTIVE_MONEY,
				OFFICIAL_PAY_NUMBER,OFFICIAL_PAY_MONEY,OTHER_PAY_NUMBER,OTHER_PAY_MONEY,SON_USER_NUMBER)
				select * from (
	         select 
				t.STAT_TIME,
				CUR_USER_ID,
				sum(t.ITEM_ALL_MONEY),
				sum(t.ITEM_MONEY),
				sum(t.PRIZE_ALL_MONEY),
				sum(t.PRIZE_MONEY),
				sum(t.PROFIT_ALL_COIN),
				sum(t.PROFIT_COIN),
				sum(t.EFFECTIVE_MONEY),
				sum(if(t.OFFICIAL_PAY_MONEY>0,1,0)),
				sum(t.OFFICIAL_PAY_MONEY),
				sum(if(t.OTHER_PAY_MONEY>0,1,0)),
				sum(t.OTHER_PAY_MONEY),
				count(distinct tu.child_user_id)-1 
				from 
				(select tu.child_user_id  from report.t_stat_partner_user tu where tu.USER_ID=CUR_USER_ID
				 union all
				 select CUR_USER_ID from dual
				 )tu 
				left join report.t_partner_order_info t on t.USER_ID=tu.child_user_id and t.STAT_TIME=date_add(STAT_TIME,interval -1 day)
				) t where t.STAT_TIME is not null
				on duplicate key update  
				ITEM_ALL_MONEY = VALUES(ITEM_ALL_MONEY),
				ITEM_MONEY = VALUES(ITEM_MONEY),
				PRIZE_ALL_MONEY = VALUES(PRIZE_ALL_MONEY),
				PRIZE_MONEY = VALUES(PRIZE_MONEY),
				PROFIT_ALL_COIN = VALUES(PROFIT_ALL_COIN),
				PROFIT_COIN = VALUES(PROFIT_COIN),
				EFFECTIVE_MONEY = VALUES(EFFECTIVE_MONEY),
				OFFICIAL_PAY_NUMBER = VALUES(OFFICIAL_PAY_NUMBER),
				OFFICIAL_PAY_MONEY = VALUES(OFFICIAL_PAY_MONEY),
				OTHER_PAY_NUMBER = VALUES(OTHER_PAY_NUMBER),
				OTHER_PAY_MONEY = VALUES(OTHER_PAY_MONEY),
				SON_USER_NUMBER = VALUES(SON_USER_NUMBER);
			   
			end if;		
			set CUR_REF_ID=CUR_REF_ID+1;
	
		END WHILE;  
		set  STAT_TIME=date_add(STAT_TIME,interval 1 day);	 
	END WHILE;  
END