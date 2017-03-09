
-- 缓存表

CREATE TABLE `t_stat_user_first_bet_time` (
	`USER_ID` BIGINT(19) NOT NULL DEFAULT '0',
	`USER_CODE` VARCHAR(500) NULL DEFAULT NULL COMMENT '用户暴露给外部时使用,全表唯一' COLLATE 'utf8_general_ci',
	`CRT_TIME` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`USER_ID`),
	INDEX `USER_CODE` (`USER_CODE`(255)),
	INDEX `CRT_TIME` (`CRT_TIME`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;

-- 刷数据

BEGIN
DECLARE ssql VARCHAR(10000);
SET @rownums=0;
SET ssql="
INSERT into report.t_stat_user_first_bet_time_temp(USER_ID, USER_CODE, CRT_TIME)
SELECT u.USER_ID, u.USER_CODE, MIN(oi.CRT_TIME) CRT_TIME
FROM game.t_order_item oi 
inner JOIN 
(select USER_ID,user_code from forum.t_user where CLIENT_ID = 'BYAPP' limit ?,1000) u 
ON u.USER_CODE = oi.USER_ID 
and oi.ITEM_STATUS not in (-5, -10 , 210) and oi.CHANNEL_CODE = 'GAME' 
and oi.COIN_BUY_MONEY>0 
GROUP BY u.USER_ID 
on duplicate key update 
USER_ID = values(USER_ID),
USER_CODE = values(USER_CODE),
CRT_TIME = values(CRT_TIME)
";
while @rownums<500000 do
SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT USING @rownums;
SET @rownums=@rownums+1000;
end while;
END

-- 更新数据

INSERT into t_stat_user_first_bet_time(USER_ID, USER_CODE, CRT_TIME)
SELECT u.USER_ID, u.USER_CODE, MIN(oi.CRT_TIME) CRT_TIME
FROM game.t_order_item oi 
inner JOIN forum.t_user u ON u.USER_CODE = oi.USER_ID and oi.ITEM_STATUS not in (-5, -10 , 210)
WHERE oi.CHANNEL_CODE = 'GAME' AND u.CLIENT_ID = 'BYAPP'
and oi.COIN_BUY_MONEY>0
and oi.CRT_TIME > date_add(curdate(), interval -1 day)
GROUP BY u.USER_ID
on duplicate key update 
USER_ID = values(USER_ID),
USER_CODE = values(USER_CODE),
CRT_TIME = values(CRT_TIME);



