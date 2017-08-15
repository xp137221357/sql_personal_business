set @param0 = '2017-05-01'; 
set @param1 = '5月份';

select * from (
	select @param1 '时间','百盈足球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注'
	from game.t_order_item o 
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
) t2 on 1=1

union all

select * from (
	select @param1 '时间','代理',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注' 
	from game.t_order_item o 
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
) tt on o.user_id=tt.user_code
	where o.PAY_TIME>=@param0
	and o.PAY_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
)t1
left join(
	select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
	from game.t_order_item o 
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
	) tt on o.user_id=tt.user_code
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
)t2 on 1=1


