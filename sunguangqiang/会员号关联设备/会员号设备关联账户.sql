

select t.ACCT_NUM '原始会员号',u.user_id '用户ID',u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',u.CRT_TIME '注册时间',e.DEVICE_CODE '设备号' 
from forum.t_user_event e 
inner join forum.t_user u on e.USER_ID=u.USER_ID
inner join (
	select u.ACCT_NUM,e.DEVICE_CODE from forum.t_user_event e 
	inner join forum.t_user u on e.USER_ID=u.USER_ID and u.ACCT_NUM in (
	'11123159',
	'12800498',
	'20984223',
	'11441327',
	'12188195',
	'18183543',
	'13231470'
	)
	group by u.ACCT_NUM,e.DEVICE_CODE
) t on e.DEVICE_CODE=t.DEVICE_CODE
group by t.ACCT_NUM,u.USER_ID,e.DEVICE_CODE