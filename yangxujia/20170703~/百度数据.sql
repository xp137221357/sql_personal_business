-- 百度最近一个月的激活 的机型 IP  mac地址  时间


set @param0='2017-06-01';
set @param1='2017-07-11';
set @param2='tuia1'; -- baidu

select t.DEVICE_CODE '设备号',t.MOBILE_VERSION '机型',t.IMEI 'imei',t.IP 'ip地址',t.MAC 'mac地址',t.ADD_TIME '时间' 
from report.t_device_statistic t 
where t.ADD_TIME>=@param0
and t.ADD_TIME<@param1
and t.REG_CHANNEL=@param2
and t.STAT_TYPE=1
and t.USER_CODE is not null;

select tu.USER_ID '用户ID',sum(tc.rmb_value) '金额',tc.crt_time '首次充值时间',e.DEVICE_CODE '设备号',e.IP 'ip地址',e.SYSTEM_MODEL '终端类型',e.EVENT_PARAM '参数',t.MOBILE_VERSION '机型',t.MAC 'mac地址',t.IMEI 'imei' from report.t_trans_user_recharge_coin tc 
inner join report.t_trans_user_attr tu on tu.USER_ID=tc.charge_user_id and tc.charge_method='app' and tu.CHANNEL_NO=@param2
inner join forum.t_user_event e on tu.USER_ID=e.USER_ID and e.EVENT_CODE='reg'
left join forum.t_device_info t on t.DEVICE_CODE=e.DEVICE_CODE 
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<@param1
and tc.CRT_TIME>=@param0
and tc.CRT_TIME<@param1
and t.ADD_TIME>=@param0
and t.ADD_TIME<@param1
group by tu.USER_ID
;

