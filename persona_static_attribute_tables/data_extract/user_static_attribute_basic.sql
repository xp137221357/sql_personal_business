DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_basic`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,user_code,reg_mobile_no,
			gender,reg_time,user_level,nick_name,user_sign,user_type,usage_status,expert_level) 
			select user_id,user_code,user_mobile,user_sex,crt_time,user_level,
			if(nick_name like 'byzq%',null,nick_name) nick_name,
			if(user_sign='最足球，跟我一起玩儿吧！',null,user_sign) user_sign,
			case 
			   when group_type in (0,1,2) then group_type
			   else 
			      user_type
			   end as user_type,
			   if(STATUS=11,-1,0) as usage_status,
			   if(is_expert=0,0,expert_level) expert_level
			from forum.t_user u where u.client_id='byapp' 
			limit ?,1000
			on duplicate key update 
			user_code = values(user_code),
			nick_name = values(nick_name),
			reg_mobile_no = values(reg_mobile_no),
			gender = values(gender),
			reg_time = values(reg_time),
			user_level = values(user_level),
			user_type = values(user_type),
			user_sign = values(user_sign),
			usage_status = values(usage_status),
			expert_level = values(expert_level)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;