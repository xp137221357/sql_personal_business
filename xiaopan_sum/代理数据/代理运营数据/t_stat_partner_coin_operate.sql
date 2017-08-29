CREATE TABLE `t_stat_partner_coin_operate` (
	`stat_date` VARCHAR(50) NOT NULL COMMENT '统计日期(12点统计)',
	`stat_type` INT(2) NOT NULL DEFAULT '1' COMMENT '1:日,2:周,3:月',
	`new_recharge_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '新用户充值人数',
	`new_recharge_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '新用户充值金币',
	`old_recharge_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '老用户充值人数',
	`old_recharge_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '老用户充值金币',
	`new_withdraw_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '新用户出币人数',
	`new_withdraw_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '新用户出币金额',
	`old_withdraw_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '老用户出币人数',
	`old_withdraw_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '老用户出币金额',
	`new_bet_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '新用户投注人数',
	`new_bet_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '新用户投注金币',
	`new_prize_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '新用户返奖金币',
	`old_bet_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '老用户投注人数',
	`old_bet_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '老用户投注金币',
	`old_prize_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '老用户返奖金币',
	`new_user_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '新增用户人数',
	`first_recharge_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '首充人数',
	`first_recharge_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '首充金额',
	`first_app_recharge_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '官方首充人数',
	`first_app_recharge_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '官方首充金额',
	`first_third_recharge_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '第三方首充人数',
	`first_third_recharge_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '第三方首充金额',
	`first_bet_counts` INT(11) NOT NULL DEFAULT '0' COMMENT '首次投注人数',
	`first_bet_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '首次投注金币',
	`effective_flow_coins` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '有效流水',
	`handicap_inner_rebate` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '盘内返水',
	`handicap_outside_rebate` DECIMAL(19,2) NOT NULL DEFAULT '0.00' COMMENT '盘外返水',
	`crt_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
	UNIQUE INDEX `stat_date` (`stat_date`),
	INDEX `stat_type` (`stat_type`)
)
COMMENT='-- 日周月数据完全独立\r\n-- 不管是人数还是金额\r\n-- 两个时间是否在同一时间区间发生'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
