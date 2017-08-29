CREATE TABLE `t_partner_total_order_info` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`USER_ID` VARCHAR(50) NOT NULL COMMENT '用户ID',
	`STAT_TIME` DATE NOT NULL COMMENT '时间',
	`ITEM_ALL_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '所有投注金额,包含体验币',
	`ITEM_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '投注金币',
	`PRIZE_ALL_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '所有返奖金额,包含体验币',
	`PRIZE_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '返奖金币',
	`EFFECTIVE_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '有效金币',
	`PROFIT_COIN` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '余额盈亏',
	`PROFIT_ALL_COIN` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '余额盈亏,包含体验币',
	`OFFICIAL_PAY_NUMBER` INT(11) NULL DEFAULT '0' COMMENT '官充人数',
	`OFFICIAL_PAY_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '官充金额',
	`OTHER_PAY_MONEY` DECIMAL(20,4) NULL DEFAULT '0.0000' COMMENT '第三方充值金额',
	`OTHER_PAY_NUMBER` INT(11) NULL DEFAULT '0' COMMENT '第三方充值人数',
	`SON_USER_NUMBER` INT(11) NULL DEFAULT '0' COMMENT '子用户数',
	`CRT_TIME` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`UPDATE_TIME` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `unq_userid_type_expect` (`USER_ID`, `STAT_TIME`),
	INDEX `UPDATE_TIME` (`UPDATE_TIME`),
	INDEX `STAT_TIME` (`STAT_TIME`),
	INDEX `CRT_TIME` (`CRT_TIME`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=13058
;
