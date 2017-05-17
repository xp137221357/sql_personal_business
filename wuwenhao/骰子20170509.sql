--
-- 没有玩过骰子，且金币余额大于1万，且第三方充值大于1000元，且近五天没有任何投注行为的用户。

select * from forum.t_acct_items ai 
inner join (
	select t.user_id from (
	select charge_user_id user_id,sum(tc.rmb_value) rmb from report.t_trans_user_recharge_coin tc 
	where tc.charge_method!='app'
	group by tc.charge_user_id
	) t where t.rmb>1000
) t on ai.USER_ID=t.user_id and ai;




CREATE TABLE `t_dice_20170509` (
	`ID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`USER_ID` VARCHAR(50) NULL DEFAULT NULL,
	`STATUS` INT(4) NULL DEFAULT '0',
	`AFTER_VALUE` VARCHAR(50) NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	UNIQUE INDEX `USER_ID` (`USER_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=197284
;



INSERT into t_dice_20170509(user_id)
select t.user_id from (
	select charge_user_id user_id,sum(tc.rmb_value) rmb from report.t_trans_user_recharge_coin tc 
	where tc.charge_method!='app'
	group by tc.charge_user_id
) t where t.rmb>1000
group by t.user_id
on duplicate key update 
user_id = values(user_id);

INSERT into t_dice_20170509(user_id,AFTER_VALUE)
select t.USER_ID,t.AFTER_VALUE from(
select ai.USER_ID,ai.AFTER_VALUE from forum.t_acct_items ai 
inner join t_dice_20170509 t on ai.USER_ID=t.USER_ID
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
order by ai.PAY_TIME desc 
) t
group by t.USER_ID
on duplicate key update 
AFTER_VALUE = values(AFTER_VALUE);

-- 投过骰子
update t_dice_20170509 t 
inner join (
	select ai.user_id from forum.t_acct_items ai 
	inner join t_dice_20170509 t on ai.USER_ID=t.USER_ID
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.ITEM_EVENT='TB_TRADE'
	group by ai.user_id
)tt on tt.user_id = t.USER_ID
set t.`STATUS`=1;

-- 近五天没有投注
update t_dice_20170509 t 
inner join (
	select ai.user_id from forum.t_acct_items ai 
	inner join t_dice_20170509 t on ai.USER_ID=t.USER_ID
	where ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.ITEM_EVENT='TRADE_COIN'
   and ai.PAY_TIME>=date_add(curdate(),interval -5 day)
	group by ai.user_id
)tt on tt.user_id = t.USER_ID
set t.`STATUS`=1


