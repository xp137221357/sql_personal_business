##建表
create table t_trans_user_attr as
select u.USER_ID, u.USER_CODE, e.DEVICE_CODE,
 e.CHANNEL_NO, e.SYSTEM_MODEL, ch.CHANNEL_NAME, 
 ch.COMPANY_NAME as CHANNEL_COMPANY, g.USER_ID as ROOT_USER_CODE, 
 us.NICK_NAME as ROOT_USER_NAME 
from  forum.t_user u  
inner join forum.t_user_event e on (u.USER_ID = e.USER_ID and e.EVENT_CODE = 'REG' and u.CLIENT_ID = 'BYAPP' ) 
left join forum.t_device_channel ch on e.CHANNEL_NO = ch.CHANNEL_NO 
left join game.t_group_ref r on u.USER_CODE = r.USER_ID 
left join game.t_group_ref g on r.ROOT_ID = g.REF_ID 
left join forum.t_user us on g.USER_ID = us.USER_CODE;

#添加索引
alter table t_trans_user_attr add primary key(USER_ID);
alter table t_trans_user_attr add index unq_user_attr(USER_CODE);

#添加事件
CREATE EVENT `transform_user_attr_schedule`
	ON SCHEDULE
		EVERY 1 DAY STARTS '2016-07-10 04:20:00'
	ON COMPLETION PRESERVE
	ENABLE
	COMMENT '每天定时刷新用户属性表'
	DO BEGIN

INSERT into t_trans_user_attr
select u.USER_ID, u.USER_CODE, e.DEVICE_CODE,
 e.CHANNEL_NO, e.SYSTEM_MODEL, ch.CHANNEL_NAME, 
 ch.COMPANY_NAME AS CHANNEL_COMPANY, g.USER_ID as ROOT_USER_CODE, 
 us.NICK_NAME as ROOT_USER_NAME 
from  forum.t_user u  
inner join forum.t_user_event e on (u.USER_ID = e.USER_ID and e.EVENT_CODE = 'REG' and u.CLIENT_ID = 'BYAPP' 
and u.CRT_TIME > date_add(curdate(), interval -1 day)) 
left join forum.t_device_channel ch on e.CHANNEL_NO = ch.CHANNEL_NO 
left join game.t_group_ref r on u.USER_CODE = r.USER_ID 
left join game.t_group_ref g on r.ROOT_ID = g.REF_ID 
left join forum.t_user us on g.USER_ID = us.USER_CODE
on duplicate key update USER_CODE = values(USER_CODE),
DEVICE_CODE = values(DEVICE_CODE),
CHANNEL_NO = values(CHANNEL_NO),
SYSTEM_MODEL = values(SYSTEM_MODEL),
CHANNEL_NAME = values(CHANNEL_NAME),
CHANNEL_COMPANY = values(CHANNEL_COMPANY),
ROOT_USER_CODE = values(ROOT_USER_CODE),
ROOT_USER_NAME = values(ROOT_USER_NAME);
END
