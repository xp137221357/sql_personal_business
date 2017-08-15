-- 帮我查一下上周 7~13号，苹果主包  apple 的激活用户的注册时间，激活时间，IP  IMEI 这些信息给我发下

set @param0='2017-08-07';
set @param1='2017-08-14';


select u.USER_ID '用户ID',u.NICK_NAME '用户昵称',u.USER_MOBILE '手机号码',u.ACCT_NUM '会员号',u.CRT_TIME '注册时间',
t.ADD_TIME '激活时间',t.IP 'ip地址',t.IMEI 'imei号'
 from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID
inner join forum.t_device_info t on e.DEVICE_CODE=t.DEVICE_CODE and e.EVENT_COD='reg'
and e.CRT_TIME>=@param0
and e.CRT_TIME<@param1
and e.CHANNEL_NO='apple';