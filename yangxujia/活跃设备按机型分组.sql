
set @param0='2016-01-01';
set @param1='2016-12-31 23:59:59';

select * from (
select concat(@param0,'~',@param1)'时间区间',ifnull(tu.MOBILE_VERSION,'其他') MOBILE_VERSION,count(distinct tu.user_code) active_num  
from t_device_statistic td 
inner join report.t_user_mobile_0215 tu on td.USER_CODE=tu.USER_CODE
inner join forum.t_user u on u.USER_ID=tu.USER_ID and u.CLIENT_ID='BYAPP' and u.`STATUS`=10
where td.STAT_TYPE=4 
and td.ACT_DATE>=@param0
and td.ACT_DATE<=@param1
group by tu.MOBILE_VERSION
)t order by t.active_num desc
