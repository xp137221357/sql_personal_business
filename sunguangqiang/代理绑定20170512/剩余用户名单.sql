set @param0='2017-05-29 12:00:00';
set @param1='2017-06-05 12:00:00';
set @param2=concat(@param0,'~',@param1);
set @param3='上海';



select concat(@param0,'~',@param1) '时间',@param3 '地区' ,t1.* from (
	select u.USER_ID,u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式' from forum.t_user u 
	inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
	and t.PROVINCE=@param3
	and u.CRT_TIME>=@param0
	and u.CRT_TIME<@param1
	and u.CLIENT_ID='byapp'
	group by u.user_id
)t1 
left join (
	select u.USER_ID from forum.t_user u 
	inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
	inner join (
	
			SELECT 
	       u.user_id,r1.CRT_TIME
			FROM   forum.t_user u
			INNER JOIN game.t_group_ref r1
			      ON u.user_code = r1.user_id  
			INNER JOIN game.t_group_ref r2
			      ON r1.root_id = r2.ref_id
			INNER JOIN forum.t_user u2
			      ON r2.user_id = u2.user_code
			inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
			      and u.client_id = 'BYAPP'
			group by u.USER_ID
			
			 union all
		
			select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0
	 
	) t on u.USER_ID=t.user_id
	and t.PROVINCE=@param3
	and u.CRT_TIME>=@param0
	and u.CRT_TIME<@param1
	and u.CLIENT_ID='byapp'
	group by u.user_id
)t2 on t2.user_id=t1.user_id
left join (
select u.USER_ID from forum.t_user u 
	inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
	inner join report.t_trans_user_attr tu on u.USER_ID=tu.user_id and tu.CHANNEL_NO in (
	
		select channel_no from report.t_device_channel t where t.channel_name like '%苹果%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%爱思%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%inmobi%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%猎豹游览器%%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%懒猫%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%华为%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%小米%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%oppo%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%创联%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%魅族%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%金立%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%360%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%百度%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%应用宝%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%今日头条%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%今日头条%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%陌陌%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%UC%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%广点通%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%百度SEM%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%迪信通%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%球场推广1%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%风拓劫持%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%乐糖%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%畅思%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%聚好玩%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%3G门户%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%聚丰网络%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%A8体育%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%百度彩票%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%淘宝%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%云之巅%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%骏伯网络%'
		union select channel_no from report.t_device_channel t where t.channel_name like '%简思网络%'
	
	)
	and t.PROVINCE=@param3
	and u.CRT_TIME>=@param0
	and u.CRT_TIME<@param1
	and u.CLIENT_ID='byapp'
	group by u.user_id
)t3 on t3.user_id=t1.user_id
where t2.user_id is null and t3.user_id is null