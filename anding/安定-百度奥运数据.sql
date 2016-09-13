set @beginTime = '2016-08-05 10:00:00';
set @endTime = '2016-08-25 11:00:00';

-- 绑定手机的数量
select count(distinct u.user_id) from forum.t_user_event t 
inner join forum.t_user u on t.USER_ID = u.USER_ID and t.EVENT_CODE='REG'
and u.`STATUS` = 10
and u.CLIENT_ID='BYAPP'
and u.USER_MOBILE is not null
and u.CRT_TIME>=@beginTime
and u.CRT_TIME<=@endTime
and t.CHANNEL_NO='baidu_olym';

-- 登录用户的数量
select count(distinct user_id) from forum.t_user_event t 
where t.CRT_TIME>=@beginTime
and t.CRT_TIME<=@endTime
and t.CHANNEL_NO='baidu_olym';

-- pv,uv
select CHANNEL_NAME,PROMOTE_POSITION,DEVICE_TYPE,sum(pv) pv,sum(uv) uv from t_rpt_h5_url_pv_uv tr 
where tr.PERIOD_TYPE = 4
and tr.CHANNEL_NAME='百度合作渠道'
and tr.PERIOD_NAME>='2016-08-05 10'
and tr.PERIOD_NAME<='2016-08-25 10'
group by tr.CHANNEL_NAME,tr.PROMOTE_POSITION,tr.DEVICE_TYPE



