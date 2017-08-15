-- 帮我导出21号应用宝注册用户的  IP IMEI 设备号 手机号 注册时间  注册方式 的数据

set @param0='2017-05-21';
set @param1='2017-05-21 23:59:59';
set @param2='qq';


select u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',e.IP '注册IP',e.DEVICE_CODE '注册设备',ti.IMEI,e.CRT_TIME '注册时间',if(e.DEVICE_CODE is null,'h5','app') '注册方式' 
from forum.t_user_event e 
inner join forum.t_device_info ti on e.DEVICE_CODE =ti.DEVICE_CODE
inner join forum.t_user u on e.USER_ID=u.USER_ID
where
e.EVENT_CODE='reg'
and u.CRT_TIME>= @param0
and u.CRT_TIME<= @param1
and e.CRT_TIME>= @param0
and e.CRT_TIME<= @param1
and ti.ADD_TIME>= @param0
and ti.ADD_TIME<= @param1
and e.CHANNEL_NO=@param2
group by u.USER_ID
;


