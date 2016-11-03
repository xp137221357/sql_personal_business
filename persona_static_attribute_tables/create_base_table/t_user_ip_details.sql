CREATE TABLE `t_user_ip_details` (
	`user_id` BIGINT(19) NOT NULL AUTO_INCREMENT,
	`ip` VARCHAR(50) NOT NULL,
	`country` VARCHAR(50) NULL DEFAULT NULL,
	`province` VARCHAR(50) NULL DEFAULT NULL,
	`city` VARCHAR(50) NULL DEFAULT NULL,
	`operators` VARCHAR(50) NULL DEFAULT NULL,
	UNIQUE INDEX `user_id` (`user_id`),
	INDEX `ip` (`ip`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6908
;