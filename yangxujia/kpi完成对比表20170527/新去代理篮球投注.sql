set @param0 = '2017-05-01'; 
set @param1 = '2017-06-01';
set @param2 = '5月份';

select max(o.CRT_TIME) from wwgame_bk.t_ww_order_item o 

select 
@param2 '时间','新去代理篮球',
count(distinct o.user_id) '投注人数',
round(sum(t.ITEM_MONEY)) '金币投注'
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
inner join forum.t_user u on o.user_id =u.USER_CODE and u.CRT_TIME>=@param0 and u.CRT_TIME<@param1
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
) tt on o.USER_ID=tt.user_id
where t.CRT_TIME>=@param0
and t.CRT_TIME<=@param1
and t.COST_TYPE=1001
and tt.user_id is null;



select 
@param2 '时间','新去代理篮球',
round(ifnull(sum(t.PRIZE_MONEY),0)+ifnull(sum(t.RETURN_MONEY),0)) '金币返奖'
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
inner join forum.t_user u on o.user_id =u.USER_CODE and u.CRT_TIME>=@param0 and u.CRT_TIME<@param1
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
) tt on o.USER_ID=tt.user_id
where t.BALANCE_TIME>=@param0
and t.BALANCE_TIME<=@param1
and t.BALANCE_STATUS=20
and t.COST_TYPE=1001
and tt.user_id is null;