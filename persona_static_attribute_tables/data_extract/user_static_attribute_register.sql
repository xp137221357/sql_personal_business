DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_register`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,reg_device_code,reg_mobile_os,
			reg_app_version,reg_ip,reg_channel_no,reg_mobile_name,reg_mobile_os_version,
			reg_mobile_brand)
select 
tu.USER_ID,
tu.DEVICE_CODE,
tu.SYSTEM_MODEL,
tu.APP_VERSION,
tu.IP,
tu.CHANNEL_NO,
tf.MOBILE_VERSION,
tf.SYSTEM_VERSION,
tf.MOBILE_BRAND
from forum.t_user_event tu 
left join forum.t_device_info tf on tf.DEVICE_CODE = tu.DEVICE_CODE 
where tu.EVENT_CODE='REG'
       limit ?,1000
       
on duplicate key update 
			reg_device_code = values(reg_device_code),
			reg_mobile_os = values(reg_mobile_os),
			reg_app_version = values(reg_app_version),
			reg_ip = values(reg_ip),
			reg_channel_no = values(reg_channel_no),
			reg_mobile_name = values(reg_mobile_name),
			reg_mobile_os = values(reg_mobile_os),
			reg_mobile_brand = values(reg_mobile_brand)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

-- ip
DELIMITER //
CREATE DEFINER=`report`@`%` PROCEDURE `procedure_ip_address`()
    COMMENT ' '
BEGIN
   set @rownums=0;
	SET @select_sql = "insert into report.t_user_tag_static(user_id,reg_ip_address)
select 
tu.USER_ID,
ti.ip_address
from (select user_id,reg_ip ip from report.t_user_tag_static limit ?,1000 )tu  
inner join report.t_ip_address_convert ti on
       round(SUBSTRING_INDEX(tu.IP,'.',1)+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',2),'.',-1)/1000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',3),'.',-1)/1000000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',4),'.',-1)/1000000000,9) >=ti.start_ip_value 
       and 
       round(SUBSTRING_INDEX(tu.IP,'.',1)+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',2),'.',-1)/1000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',3),'.',-1)/1000000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(tu.IP,'.',4),'.',-1)/1000000000,9) <=ti.end_ip_value  
on duplicate key update 
			reg_ip_address = values(reg_ip_address)";
	
   PREPARE stmt FROM @select_sql;
   
   while @rownums<700000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+1000; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;