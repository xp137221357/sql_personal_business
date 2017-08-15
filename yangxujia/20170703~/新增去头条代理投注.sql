set @param0 = '2017-07-01'; 
set @param1 = '7月份';

select * from (
	select @param1 '时间',
	'新增去头条',
	count(distinct o.USER_ID) first_bet_counts,
	round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('game')
	and o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
) t1
left join (
	
	select 
	round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) first_prize_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('game')
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
)t2 on 1=1


union all



select * from (
	select @param1 '时间',
	'新增代理去头条',
	count(distinct o.USER_ID) first_bet_counts,
	round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
	inner join (
		SELECT 
	       u.user_code,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		union all
		
		select u.user_code,tg.crt_time from report.t_partner_group tg 
		inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
	) tt on tb.USER_CODE=tt.user_code 
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
-- 	and o.PAY_TIME>=tt.CRT_TIME
	and o.CHANNEL_CODE in ('game')
	and o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
) t1
left join (
	
	select 
	round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) first_prize_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID
	inner join (
		 SELECT 
	       u.user_code,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		union all
		
		select u.user_code,tg.crt_time from report.t_partner_group tg 
		inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0
	) tt on tb.USER_CODE=tt.user_code  
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('game')
-- 	and o.BALANCE_TIME>=tt.CRT_TIME
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
)t2 on 1=1

union all

select * from (
	select @param1 '时间',
	'新增头条',
	count(distinct o.USER_ID) first_bet_counts,
	round(sum(o.COIN_BUY_MONEY)) first_bet_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID 
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('jrtt-jingcai')
	and o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
) t1
left join (
	
	select 
	round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) first_prize_coins 
	from game.t_order_item o
	inner join report.t_stat_user_first_bet_time tb on tb.USER_CODE=o.USER_ID
	where tb.crt_time>=@param0 and tb.crt_time<date_add(@param0,interval 1 month)
	and o.CHANNEL_CODE in ('jrtt-jingcai')
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
)t2 on 1=1;

