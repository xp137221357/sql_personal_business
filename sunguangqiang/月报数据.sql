set @beginTime='2016-05-01 00:00:00';
set @endTime = '2016-06-01 00:00:00';

-- 整体数据

-- 访问uv


SELECT 
      Sum(pv)     AS device_pv,
      Sum(uv)     AS device_uv
FROM   t_rpt_channel_pv_uv
WHERE  period_type = '1'
      AND period_name >= @beginTime
      AND period_name < @endTime;
        

select sum(DEVICE_UV) from report.t_rpt_overview t 
where t.PERIOD_TYPE=1 and t.PERIOD_NAME>= @beginTime 
and t.PERIOD_NAME<@endTime


select * from report.t_rpt_overview t where t.DEVICE_UV>0 limit 100