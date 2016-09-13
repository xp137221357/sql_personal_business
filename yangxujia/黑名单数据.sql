set @beginTime='2016-06-10';
set @endTime = '2016-07-09';

-- 余额
select '黑名单',tc.CHANNEL_NAME,t.CHANNEL_NO,count(distinct u.USER_ID),u.USER_ID,sum(ifnull(t2.AFTER_VALUE,0)) from forum.t_user u 
inner join forum.t_user_event t on u.USER_ID = t.USER_ID and t.EVENT_CODE = 'REG' and u.CLIENT_ID='BYAPP'
inner join (select * from (select AFTER_VALUE,user_id from forum.t_acct_items ti
where ti.item_status = 10
        AND ti.ACCT_TYPE = 1001
		  AND ti.ADD_TIME >= @beginTime
		  AND ti.ADD_TIME < @endTime
		  ORDER BY ti.ADD_TIME DESC) t1 GROUP BY t1.USER_ID) t2 on t2.user_id = u.user_id 
left join forum.t_device_channel tc on tc.CHANNEL_NO = t.CHANNEL_NO
where u.STATUS =11 
and u.crt_time>= @beginTime
and u.crt_time< @endTime
group by t.CHANNEL_NO;

-- 充值
select '黑名单',tc.CHANNEL_NAME,t.CHANNEL_NO,count(distinct u.USER_ID),sum(ifnull(ti.CHANGE_VALUE,0)) from forum.t_user u 
inner join forum.t_user_event t on u.USER_ID = t.USER_ID and t.EVENT_CODE = 'REG' and u.CLIENT_ID='BYAPP'
inner join forum.t_acct_items ti on u.USER_ID = ti.USER_ID
and ti.ITEM_STATUS = 10 
AND (ti.ITEM_EVENT = 'COIN_FROM_DIAMEND' or (ti.ITEM_EVENT = 'ADMIN_USER_OPT' and ti.COMMENTS like '%网银充值%'))
left join forum.t_device_channel tc on tc.CHANNEL_NO = t.CHANNEL_NO
where u.STATUS =11 
and u.crt_time>= @beginTime
and u.crt_time< @endTime
group by t.CHANNEL_NO;
