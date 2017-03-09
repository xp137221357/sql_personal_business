CREATE TABLE `t_device_channel_balance` (
	`ID` INT(10) NOT NULL AUTO_INCREMENT,
	`CHANNEL_NAME` VARCHAR(50) NOT NULL COMMENT '渠道名称',
	`SYSTEM_MODEL` VARCHAR(20) NOT NULL COMMENT 'IOS|Android',
	`STATUS` INT(4) NULL DEFAULT '10' COMMENT '10-正常 11-无效',
	`first_activate_num` DOUBLE NULL DEFAULT '0',
	`reg_num` DOUBLE NULL DEFAULT '0',
	`new_recharge_num` DOUBLE NULL DEFAULT '0',
	`new_recharge_amount` DOUBLE NULL DEFAULT '0',
	`recharge_num` DOUBLE NULL DEFAULT '0',
	`recharge_amount` DOUBLE NULL DEFAULT '0',
	`new_buy_service_num` DOUBLE NULL DEFAULT '0',
	`new_buy_service_amount` DOUBLE NULL DEFAULT '0',
	`buy_service_num` DOUBLE NULL DEFAULT '0',
	`buy_service_amount` DOUBLE NULL DEFAULT '0',
	`bet_coin` DOUBLE NULL DEFAULT '0',
	`prize_coin` DOUBLE NULL DEFAULT '0',
	`profit_coin` DOUBLE NULL DEFAULT '0',
	`ctr_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`CHANNEL_NAME`, `SYSTEM_MODEL`),
	UNIQUE INDEX `ID` (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;




-- 投注

select 
tu.CHANNEL_NO,
sum(oi.COIN_BUY_MONEY) bet_coins
  from game.t_order_item oi
  inner join report.t_trans_user_attr tu on tu.USER_CODE=oi.USER_ID -- and tu.CHANNEL_NO in (?)
where  
oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210)
and oi.PAY_TIME >= @param0 and oi.PAY_TIME <= @param1
and oi.COIN_BUY_MONEY>0
group by tu.CHANNEL_NO;

-- 返奖
select 
 tu.CHANNEL_NO,
 sum(oi.COIN_PRIZE_MONEY) return_coins
 from game.t_order_item oi 
 inner join report.t_trans_user_attr tu on tu.USER_CODE=oi.USER_ID -- and tu.CHANNEL_NO in (?)
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 , 210) 
and oi.BALANCE_STATUS=20
and oi.COIN_PRIZE_MONEY>0
and oi.BALANCE_TIME >= @param0 
and oi.BALANCE_TIME <= @param1
group by tu.CHANNEL_NO;


-- 充值人数以及购买服务人数

select date(ai.ADD_TIME) stat_time,count(distinct ai.USER_ID),sum(ai.CHANGE_VALUE) 
from forum.t_acct_items ai 
inner join forum.t_user u on u.USER_ID= ai.USER_ID and u.CLIENT_ID='BYAPP' and u.group_type != 1 
left join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT='BUY_DIAMEND' 
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
group by stat_time;

select date(ai.ADD_TIME) stat_time,count(distinct ai.USER_ID),sum(ai.CHANGE_VALUE) 
from forum.t_acct_items ai 
inner join forum.t_user u on u.USER_ID= ai.USER_ID and u.CLIENT_ID='BYAPP' and u.group_type != 1 
left join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_SERVICE','BUY_RECOM') 
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
group by stat_time;

-- 整体运营数据

SELECT
Concat('2017-01-30', '~', '2017-02-06')
stat_time,
IF(tdc.company_name IS NULL
    OR tdc.company_name = '', 'other', tdc.company_name)
channel_company,
IF(tdc.channel_name IS NULL
    OR tdc.channel_name = '', 'other', tdc.channel_name)
channel_name,
IF(c.channel_no IS NULL
    OR c.channel_no = '', 'other', c.channel_no)
channel_no,
IF(c.device_type IS NULL
    OR c.device_type = '', 'other', c.device_type)
device_type,
c.first_dnum,
c.reg_unum,
c.first_buy_unum,
c.first_buy_amount,
-- cc.buy_unum,
c.buy_amount,
c.first_srv_unum,
c.first_srv_amount,
-- cc.srv_unum,
c.srv_amount
FROM   (SELECT channel_no,
               device_type,
               Sum(first_dnum)       AS first_dnum,
               Sum(second_dnum)      AS second_dnum,
               Sum(active_dnum)      AS active_dnum,
               Sum(reg_unum)         AS reg_unum,
               Sum(first_buy_unum)   AS first_buy_unum,
               Sum(first_buy_amount) AS first_buy_amount,
               -- Sum(buy_unum)         AS buy_unum,
               Sum(buy_amount)       AS buy_amount,
               Sum(first_srv_unum)         AS first_srv_unum,
               Sum(first_srv_amount)       AS first_srv_amount, 
               -- Sum(srv_unum)         AS srv_unum,
               Sum(srv_amount)       AS srv_amount
               
        FROM   t_rpt_overview t
        WHERE  period_type = '1'
               AND period_name >= '2017-01-30'
               AND period_name <= Concat('2017-02-06', ' 23:59:59')
               AND channel_no IN (SELECT channel_no
                                  FROM   t_device_channel
                                  WHERE  status = 10
                                         AND company_name IN (
                                             '(百盈)一元得宝' )
                                  GROUP  BY channel_no)
        GROUP  BY channel_no,
                  device_type) c
       LEFT JOIN report.t_device_channel tdc
              ON tdc.channel_no = c.channel_no
WHERE  ( c.first_dnum IS NOT NULL
          OR c.reg_unum IS NOT NULL
          OR c.first_buy_unum IS NOT NULL
          OR c.first_buy_amount IS NOT NULL
          OR c.buy_unum IS NOT NULL
          OR c.buy_amount IS NOT NULL )
ORDER  BY c.first_dnum DESC,
          c.reg_unum DESC,
          c.first_buy_unum DESC,
          c.first_buy_amount DESC 
