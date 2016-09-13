set @beginTime='2016-09-06 00:00:00';
set @endTime = '2016-09-06 23:59:59';
select u.CRT_TIME '时间',u.NICK_NAME '昵称',u.USER_MOBILE '用户联系方式',td.DEVICE_CODE '设备号',td.IP 'IP地址' 
from forum.t_user u 
inner join report.t_device_statistic td on td.USER_CODE = u.USER_CODE 
where u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime
group by u.user_id
