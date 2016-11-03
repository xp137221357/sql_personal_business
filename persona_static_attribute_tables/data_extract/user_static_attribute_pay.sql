DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_pay_alipay`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,alipay)
		select ai.USER_ID,t.alipay from (
		select if(tg.PAY_TYPE=3,tg.open_id,null) 'alipay',
				 tg.OUT_TRADE_NO 
				 from forum.t_third_pay_log tg limit ?,1000
				 ) t
		inner join forum.t_acct_items ai on ai.TRADE_NO = t.OUT_TRADE_NO and t.alipay is not null
		group by ai.USER_ID
		on duplicate key update 
		alipay = values(alipay)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;   


DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_pay_wechat`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,wechat)
		select ai.USER_ID,t.wechat from (
		select if(tg.PAY_TYPE=4,tg.open_id,null) 'wechat',
				 tg.OUT_TRADE_NO 
				 from forum.t_third_pay_log tg limit ?,1000
				 ) t
		inner join forum.t_acct_items ai on ai.TRADE_NO = t.OUT_TRADE_NO and t.wechat is not null
		group by ai.USER_ID
		on duplicate key update 
		wechat = values(wechat)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ; 
