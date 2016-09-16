set @beginTime='2016-08-26 06';
set @endTime = '2016-08-26 08';
set @crt_time = '2016-08-26 06:59:59';
set @num = '1';

select floor(TIMESTAMPDIFF(hour,date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@beginTime,@endTime))*@num hour),@crt_time)/(TIMESTAMPDIFF(hour,@beginTime,@endTime)));


select TIMESTAMPDIFF(hour,@beginTime,@endTime); 


select date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@beginTime,@endTime))*@num hour);

-- ------------------------

when 0 then concat(date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*@num hour),'~',
date_add(date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*@num hour),interval TIMESTAMPDIFF(hour,@endTime,@beginTime) hour))
when 1 then concat(date_add(date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*@num hour),interval (TIMESTAMPDIFF(hour,@endTime,@beginTime)+1) hour),'~',
date_add(date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*@num hour),interval (TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*2-1 hour))

select concat(date_add(@beginTime,interval -(TIMESTAMPDIFF(hour,@endTime,@beginTime)+1)*@num hour)