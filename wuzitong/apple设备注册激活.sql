set @param0='2017-05-08';
set @param1='2017-05-15';


select count(distinct e.DEVICE_CODE) from forum.t_user_event e 
where e.CRT_TIME>=@param0 
and e.CRT_TIME<@param1
and e.EVENT_CODE='reg'
and e.CHANNEL_NO='apple';


select count(distinct t.DEVICE_CODE) from forum.t_device_info t 
left join forum.t_user_event e on t.DEVICE_CODE=e.DEVICE_CODE and e.CRT_TIME>=@param0 
and e.CRT_TIME<@param1
and e.EVENT_CODE='reg'
and e.CHANNEL_NO='apple'
where t.ADD_TIME>=@param0 
and @param1
and e.DEVICE_CODE is null
and t.CHANNEL_NO='apple';




select * from report.t_device_channel t where t.CHANNEL_NAME=''