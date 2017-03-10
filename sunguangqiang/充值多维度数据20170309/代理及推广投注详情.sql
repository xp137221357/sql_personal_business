set @param0 = '2017-02-01'; 
set @param1 = '2017-03-01';


select * from (
	select '百盈',concat(@param0,'~',@param1) stat_time,count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
) t2 on 1=1

union all

select * from (
	select '山东代理',concat(@param0,'~',@param1) stat_time,count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注' 
	from game.t_order_item o 
	inner join (
		SELECT 
		       u.user_code user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='shandong')
				and u.client_id = 'BYAPP'
		
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='shandong'
	) t on o.USER_ID=t.user_id
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	inner join (
		SELECT 
		       u.user_code user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='shandong')
				and u.client_id = 'BYAPP'
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='shandong'
	) t on o.USER_ID=t.user_id
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
)t2 on 1=1


union all


select * from (
	select '内部推广',concat(@param0,'~',@param1) stat_time,count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注' 
	from game.t_order_item o 
	inner join (
		SELECT 
		       u.user_code user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	) t on o.USER_ID=t.user_id
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	inner join (
		SELECT 
		       u.user_code user_id
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		      AND u2.USER_ID in (select user_id from report.t_user_general_agent t where t.comments='inner')
				and u.client_id = 'BYAPP'
		union  
		
		select user_code from report.t_user_general_agent t where t.comments='inner'
	) t on o.USER_ID=t.user_id
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE='game'
)t2 on 1=1;

