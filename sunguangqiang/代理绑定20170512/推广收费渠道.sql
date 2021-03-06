set @param0='2017-05-15 12:00:00';
set @param1='2017-05-22 12:00:00';
set @param2=concat(@param0,'~',@param1);
set @param3='上海';

select * from (
	select @param2,count(distinct u.USER_ID) '注册用户数' from forum.t_user u 
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
)t1 
left join (
	
-- 充值人数
	select count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数' from report.t_trans_user_recharge_coin tc
	inner join (
		select distinct u.user_id from forum.t_user u 
		inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
		and t.PROVINCE=@param3
		and u.CRT_TIME>=@param0
		and u.CRT_TIME<@param1
		and u.CLIENT_ID='byapp'
	) t1 on t1.user_id=tc.charge_user_id
	inner join report.t_trans_user_attr tu on t1.USER_ID=tu.user_id and tu.CHANNEL_NO in (
	
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
	where tc.crt_time>=@param0
	and tc.crt_time<@param1
) t2 on 1=1
left join (
-- 投注返奖
	select * from (
		select count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注' 
		from game.t_order_item o 
		inner join (
			select distinct u.user_code from forum.t_user u 
			inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
			and t.PROVINCE=@param3
			and u.CRT_TIME>=@param0
			and u.CRT_TIME<@param1
			and u.CLIENT_ID='byapp'
		) t on o.USER_ID=t.user_code
		inner join report.t_trans_user_attr tu on o.USER_ID=tu.USER_CODE and tu.CHANNEL_NO in (
	
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
		where o.PAY_TIME>=@param0
		and o.PAY_TIME<@param1
		and o.ITEM_STATUS not in (-5,-10,210)
		and o.COIN_BUY_MONEY>0
		and o.SPORT_TYPE='S' 
		and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	)t1
	left join(
		select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
		from game.t_order_item o 
		inner join (
			select distinct u.user_code from forum.t_user u 
			inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
			and t.PROVINCE=@param3
			and u.CRT_TIME>=@param0
			and u.CRT_TIME<@param1
			and u.CLIENT_ID='byapp'
		) t on o.USER_ID=t.user_code
		inner join report.t_trans_user_attr tu on o.USER_ID=tu.USER_CODE and tu.CHANNEL_NO in (
	
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
		where o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<@param1
		and o.ITEM_STATUS not in (-5,-10,210)
		and o.COIN_BUY_MONEY>0
		and o.SPORT_TYPE='S' 
		and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	)t2 on 1=1
) t3 on 1=1
left join (
	
-- 有效流水
	select sum(t.EFFECTIVE_MONEY) '有效流水' from game.t_partner_order_info t 
	inner join (
	   select distinct u.user_code from forum.t_user u 
			inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
			and t.PROVINCE=@param3
			and u.CRT_TIME>=@param0
			and u.CRT_TIME<@param1
			and u.CLIENT_ID='byapp'
	) t1 on t.USER_ID=t1.user_code
	inner join report.t_trans_user_attr tu on t.USER_ID=tu.USER_CODE and tu.CHANNEL_NO in (
	
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
	and t.`TYPE`=2
	where date(t.EXPECT)>=@param0 
	and date(t.EXPECT)<@param1
	
) t4 on 1=1;