CREATE TABLE `t_stat_partner_user` (
	`ref_id` BIGINT(19) NULL DEFAULT NULL,
	`child_ref_id` BIGINT(19) NULL DEFAULT NULL,
	`user_id` VARCHAR(50) NULL DEFAULT NULL,
	`child_user_id` VARCHAR(50) NULL DEFAULT NULL,
	`crt_time` DATETIME NULL DEFAULT NULL COMMENT '原表',
	`update_time` DATETIME NULL DEFAULT NULL COMMENT '原表',
	UNIQUE INDEX `uniq_ref_id` (`ref_id`, `child_ref_id`),
	INDEX `crt_time` (`crt_time`),
	INDEX `update_time` (`update_time`),
	INDEX `user_id` (`user_id`),
	INDEX `child_user_id` (`child_user_id`),
	INDEX `child_ref_id` (`child_ref_id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
