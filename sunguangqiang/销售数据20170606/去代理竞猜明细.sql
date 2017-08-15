
set @param0 = '2017-07-01'; 
set @param1 = '2017-07';
set @param2 = '7月份';

select * from (
	select @param2 '时间','百盈足球去代理',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	left join (
		SELECT 
	    u.user_code,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_group_partner_detail td on td.user_id=u2.USER_ID and td.stat_time=@param1 
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		union all
		
		select td.user_code,'2017-01-01' from report.t_group_partner_detail td where td.stat_time=@param1
   ) tt on o.USER_ID=tt.user_code and o.PAY_TIME>=tt.CRT_TIME
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and tt.user_code is null
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	left join (
		SELECT 
	    u.user_code,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_group_partner_detail td on td.user_id=u2.USER_ID and td.stat_time=@param1 
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		union all
		
		select td.user_code,'2017-01-01' from report.t_group_partner_detail td where td.stat_time=@param1
   ) tt on o.USER_ID=tt.user_code and o.PAY_TIME>=tt.CRT_TIME
	where o.BALANCE_TIME>=@param0 	
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and tt.user_code is null
) t2 on 1=1;






