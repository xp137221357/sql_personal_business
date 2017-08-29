CREATE DEFINER=`report`@`%` PROCEDURE `pro_t_group_ref`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
DECLARE ssql VARCHAR(1000);

SET ssql=
   concat('create table t_group_ref_', date_format(date_add(curdate(),interval -1 day),'%Y%m%d'), 
	' select * from game.t_group_ref'
	);

SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT;
END