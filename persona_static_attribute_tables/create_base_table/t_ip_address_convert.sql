CREATE TABLE `t_ip_address_convert` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`start_ip_value` VARCHAR(20) NOT NULL,
	`end_ip_value` VARCHAR(20) NOT NULL,
	`ip_address` VARCHAR(100) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=42235
;

insert into t_ip_address_convert(id,start_ip_value,end_ip_value,ip_address)
select id,
round(SUBSTRING_INDEX(start_ip,'.',1)+
       SUBSTRING_INDEX(SUBSTRING_INDEX(start_ip,'.',2),'.',-1)/1000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(start_ip,'.',3),'.',-1)/1000000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(start_ip,'.',4),'.',-1)/1000000000,9)
		 start_ip,
		 round(SUBSTRING_INDEX(end_ip,'.',1)+
       SUBSTRING_INDEX(SUBSTRING_INDEX(end_ip,'.',2),'.',-1)/1000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(end_ip,'.',3),'.',-1)/1000000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(end_ip,'.',4),'.',-1)/1000000000,9) 
		 end_ip,
		 ip_address 
from t_ip_address