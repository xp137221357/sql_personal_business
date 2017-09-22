CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_partner_group`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
DECLARE ssql VARCHAR(1000);

SET ssql=
   concat('create table t_partner_group_', date_format(date_add(curdate(),interval -1 day),'%Y%m%d'), 
	' select * from t_partner_group'
	);

SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT;
END