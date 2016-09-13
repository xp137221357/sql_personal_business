CREATE TABLE `t_stat_coin_operate` (
	`stat_date` DATE NOT NULL COMMENT '统计日期',
	`fore_asserts_free_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币的前总余额',
	`fore_asserts_normal_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '普通金币的前总余额',
	`fobidden_counts` DECIMAL(10,0) NULL DEFAULT NULL COMMENT '冻结账户',
	`fobidden_free_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '冻结体验币数',
	`fobidden_normal_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '冻结金币数',
	`recharge_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '官方及网银金币充值',
	`reward_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币赠送',   
	`reward_free_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币赠送',   
	`prize_coins_abnormal` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '异常派奖',
	`exchange_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币交易消耗',
	`basketball_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币篮球消耗',
	`football_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币足球消耗',
	`draw_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币抽奖消耗',
	`redeem_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币兑换消耗',
	`broadcast_coins_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '金币广播消耗',
	`exchange_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币交易消耗',
	`basketball_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币篮球消耗',
	`football_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币足球消耗',
	`draw_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币抽奖消耗',
	`redeem_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币兑换消耗',
	`broadcast_free_consume` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '体验币广播消耗',
	`t_new_recharge_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '官方及第三方充值金币',
	`t_recharge_coins` DECIMAL(14,2) NULL DEFAULT NULL COMMENT '官方及第三方新增充值金币',
	`add_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	`update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE INDEX `stat_date` (`stat_date`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;