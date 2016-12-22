set @param0='2016-11-21';
set @param1='2016-11-23 23:59:59';

-- 2599
select count(1) from forum.t_user_event te 
where te.CRT_TIME<=@param1
and te.CRT_TIME>=@param0
and te.EVENT_CODE='REG'
and te.CHANNEL_NO='qq'

union all
-- 1200
select count(1) from forum.t_device_info t
where t.ADD_TIME>=@param0
and t.ADD_TIME<=@param1
and t.REG_CHANNEL='qq'

union all

-- 694
select count(1) from forum.t_device_info t
inner join forum.t_user_event te on t.DEVICE_CODE=te.DEVICE_CODE
and t.ADD_TIME>=@param0
and t.ADD_TIME<=@param1
and te.CRT_TIME>=@param0
and te.EVENT_CODE='REG'
and t.REG_CHANNEL='qq'
and te.CHANNEL_NO='qq'