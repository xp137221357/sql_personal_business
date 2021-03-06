set @param0='2017-05-08 12:00:00';
set @param1='2017-05-15 12:00:00';
set @param2=concat(@param0,'~',@param1);
set @param3='上海';

select * from (
	select @param2,count(distinct u.USER_ID) '注册用户数' from forum.t_user u 
	inner join forum.t_mobile_location t on u.USER_MOBILE = t.MOBILE 
	inner join (
	
		SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	 
	) t on u.USER_ID=t.user_id
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
	inner join (
	
		SELECT 
		       u.user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	 
	) t on t1.USER_ID=t.user_id
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
		inner join (
	
		SELECT 
		       u.user_code
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	 
	  ) t1 on t1.USER_code=t.user_code
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
		inner join (
	
		SELECT 
		       u.user_code
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	 
	  ) t1 on t1.USER_code=t.user_code
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
	inner join (
	
		SELECT 
		       u.user_code
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id and r1.CRT_TIME<@param1
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	 
	  ) t2 on t.USER_ID=t2.user_code
	and t.`TYPE`=2
	where date(t.EXPECT)>=@param0 
	and date(t.EXPECT)<@param1
	
) t4 on 1=1;