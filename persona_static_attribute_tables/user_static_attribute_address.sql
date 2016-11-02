DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_address`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,address)
		select t.USER_ID,concat(t.PROVINCE,'-',t.CITY,'-',t.DISTRICT,'-',t.ADDRESS) address 
		from forum.t_user_address t limit ?,1000
		on duplicate key update 
		address = values(address)";
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;