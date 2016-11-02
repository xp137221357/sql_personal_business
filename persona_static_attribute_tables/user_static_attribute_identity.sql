DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_identity`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,real_name,email,
			bank_type,bank_no,bank_branch,id_code,id_age,id_area)
			select t.user_id,t.realname,t.email,t.bank_type,t.bank_acct,t.bank_branch,t.IDENTIFICATION,t.age,ifnull(t.address,(select tt.address from report.t_identity_authentication tt where tt.id=substr(t.IDENTIFICATION,1,2))) address from 
			(
			select ta.USER_ID,ta.REALNAME,ta.bank_type,replace(ta.BANK_ACCT,' ','') BANK_ACCT,replace(ta.IDENTIFICATION,' ','') IDENTIFICATION,ta.BANK_BRANCH,ta.EMAIL,
			FLOOR(TIMESTAMPDIFF(MONTH,substr(replace(ta.IDENTIFICATION,' ',''),7,8),curdate())/12) age,
			(select address 
			from report.t_identity_authentication t where t.id=substr(ta.IDENTIFICATION,1,6) ) address
			from forum.t_expert_apply ta limit ?,1000
			) t 
			on duplicate key update 
			real_name = values(real_name),
			email = values(email),
			bank_type = values(bank_type),
			bank_no = values(bank_no),
			bank_branch = values(bank_branch),
			id_code = values(id_code),
			id_age = values(id_age),
			id_area = values(id_area)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;