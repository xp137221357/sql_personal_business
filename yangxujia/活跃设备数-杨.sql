-- 活跃设备的7月25号~7月31号，8月1~8月7,8月8~8.15，我们的活跃设备有多少（汇总去重）；总体  安卓 IOS  能给我个数据吗


set @beginTime='2016-09-26 00:00:00';
set @endTime = '2016-10-02 23:59:59';

-- 活跃设备历史数据(区别创建时间和更新时间)
select concat(@beginTime,'~',@endTime) '时间',t.SYSTEM_MODEL ,COUNT(DISTINCT t.DEVICE_CODE) from report.t_device_statistic t 
   where t.STAT_TYPE=4
   and t.DEVICE_STATUS != -10 
   AND t.ACT_DATE >= @beginTime
   AND t.ACT_DATE <= @endTime
	group by t.SYSTEM_MODEL ;
   

-- 活跃设备实时数据(区别创建时间和更新时间)
SELECT concat(@beginTime,'~',@endTime) '时间',d.SYSTEM_MODEL ,COUNT(DISTINCT D.DEVICE_CODE)
  FROM forum.t_device_info d
 WHERE  d.DEVICE_STATUS != -10 
   -- AND D.SYSTEM_MODEL = 'ios'
   AND d.UPDATE_TIME >= @beginTime
   AND d.UPDATE_TIME <= @endTime
	group by d.SYSTEM_MODEL ;
   
   


-- 官方充值人数


select count(distinct t.user_id) from forum.t_acct_items t 
inner join forum.t_user u on t.USER_ID = u.USER_ID and u.CLIENT_ID = 'BYAPP'
inner join forum.t_user_event tu on u.USER_ID = tu.user_id and tu.EVENT_CODE='REG'  -- and tu.SYSTEM_MODEL='ios'
where 
t.ITEM_EVENT = 'BUY_DIAMEND'
and t.ITEM_STATUS = 10
and t.ADD_TIME>=@beginTime and t.ADD_TIME<= @endTime 
