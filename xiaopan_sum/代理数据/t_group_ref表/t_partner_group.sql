CREATE TABLE `t_partner_group` (
	`agent_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`apply` VARCHAR(50) NULL DEFAULT NULL,
	`agent` VARCHAR(50) NULL DEFAULT NULL,
	`monitor` VARCHAR(50) NULL DEFAULT NULL COMMENT '维护人员',
	`user_id` VARCHAR(50) NULL DEFAULT NULL,
	`agent_invite_code` VARCHAR(50) NULL DEFAULT NULL,
	`agent_acct_num` VARCHAR(50) NULL DEFAULT NULL,
	`rebates` VARCHAR(20) NULL DEFAULT '0',
	`dividend` VARCHAR(20) NULL DEFAULT '0',
	`payee` VARCHAR(50) NULL DEFAULT NULL,
	`account_info` VARCHAR(50) NULL DEFAULT NULL,
	`bank_no` VARCHAR(50) NULL DEFAULT NULL,
	`is_valid` INT(2) NULL DEFAULT '0' COMMENT '0有效，1无效',
	`cancel_time` TIMESTAMP NULL DEFAULT NULL,
	`crt_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`strategy` VARCHAR(10) NULL DEFAULT NULL,
	PRIMARY KEY (`agent_id`),
	UNIQUE INDEX `uniq_agent_acct_num` (`agent_acct_num`),
	INDEX `idx_user_id` (`user_id`)
)
COMMENT='代理用户表'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=225
;
