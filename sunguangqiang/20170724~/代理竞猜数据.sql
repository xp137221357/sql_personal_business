set @param0='2017-06-01 00:00:00';
set @param1='2017-08-01 00:00:00';

set @param2=concat(@param0,'~',@param1);

select 
@param2 '时间',
sum(o.COIN_BUY_MONEY) '投注', 
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) '返奖',
sum(
    if(o.pass_type = '1001' 
	 and o.item_status not in (0,10,-5,-10,120,210) 
	 and o.MATCH_ODDS >= 1.5,
	 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
	 0 )) '有效流水'
from (
	select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
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
		inner join (select tg.user_id,tg.crt_time from report.t_partner_group_detail tg where tg.stat_time in ('2017-05') group by user_id) tr
		      on u2.USER_ID=tr.user_id and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		union all
		
		select tg.user_code,tg.crt_time from report.t_partner_group_detail tg where tg.stat_time in ('2017-05') group by user_id
	) t on o.USER_ID=t.user_code
	left join game.t_item_content c on c.ITEM_ID = o.item_id
	where o.CHANNEL_CODE = 'game'
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.CRT_TIME>t.CRT_TIME
	group by o.ITEM_ID
) o;
   
   
   -- 347,1588085,1647149,1659929,1783811

select  @param2 '时间','代理任务投注任务赠送',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID =u.USER_ID
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
	inner join (select tg.user_id,tg.crt_time from report.t_partner_group_detail tg where tg.stat_time in ('2017-05') group by user_id) tr
	      on u2.USER_ID=tr.user_id and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select tg.user_id,tg.crt_time from report.t_partner_group_detail tg where tg.stat_time in ('2017-05') group by user_id
) tt on ai.user_id=tt.user_id
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME>=tt.CRT_TIME
and ai.PAY_TIME<=@param1
and ai.CHANGE_VALUE>=2500
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';




