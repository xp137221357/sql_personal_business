CREATE TABLE `t_telephone_details` (
	`phone_num` VARCHAR(20) NOT NULL,
	`province` VARCHAR(20) NULL DEFAULT NULL,
	`city` VARCHAR(20) NULL DEFAULT NULL,
	`card_attribute` VARCHAR(50) NULL DEFAULT NULL,
	`area_code` VARCHAR(20) NULL DEFAULT NULL,
	`post_code` VARCHAR(20) NULL DEFAULT NULL,
	PRIMARY KEY (`phone_num`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;