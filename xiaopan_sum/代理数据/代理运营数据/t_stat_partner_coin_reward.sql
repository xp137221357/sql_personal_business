CREATE TABLE `t_stat_partner_coin_reward` (
	`stat_date` DATE NOT NULL COMMENT '统计日期(12点统计)',
	`acct_num` VARCHAR(50) NOT NULL COMMENT '会员号',
	`reward_coins` INT(11) NOT NULL COMMENT '投注奖励金币数',
	UNIQUE INDEX `stat_date` (`stat_date`, `acct_num`),
	INDEX `acct_num` (`acct_num`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
