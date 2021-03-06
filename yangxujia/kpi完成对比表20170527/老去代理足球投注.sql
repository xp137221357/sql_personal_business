set @param0 = '2017-05-01'; 
set @param1 = '2017-06-01';
set @param2 = '5 月份';

select @param2 '时间','老去代理足球',count(distinct o.user_id) '投注人数',round(sum(o.COIN_BUY_MONEY)) '金币投注' 
from game.t_order_item o 
left join forum.t_user u on o.user_id =u.USER_CODE and u.CRT_TIME>=@param0 and u.CRT_TIME<@param1
left join (
		SELECT 
       u.user_code user_id,r1.CRT_TIME
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
) t on o.USER_ID=t.user_id
where o.PAY_TIME>=@param0
and o.PAY_TIME<@param1
and o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
and o.SPORT_TYPE='S' 
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and t.user_id is null
and u.user_id is null;



select round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) '返奖金币'
from game.t_order_item o 
left join forum.t_user u on o.user_id =u.USER_CODE and u.CRT_TIME>=@param0 and u.CRT_TIME<@param1
left join (
		SELECT 
       u.user_code user_id,r1.CRT_TIME
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
) t on o.USER_ID=t.user_id
where o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<@param1
and o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
and o.SPORT_TYPE='S' 
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and t.user_id is null
and u.user_id is null;



