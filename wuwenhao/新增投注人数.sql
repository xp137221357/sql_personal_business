
-- 帮我查一下新增投注人数吧
set @beginTime='2016-06-01';
set @endTime = '2016-09-30 23:59:59';

select date_format(tt.CRT_TIME,'%Y-%m') '日期',count(user_id) '新增投注人数' from t_stat_user_first_bet_time tt 
where tt.CRT_TIME>=@beginTime
and tt.CRT_TIME<=@endTime
group by date_format(tt.CRT_TIME,'%Y-%m');


