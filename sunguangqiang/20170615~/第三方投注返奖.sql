set @param0='2017-06-19 12:00:00';
set @param1='2017-06-20 12:00:00';


-- 新用户投注
select count(distinct o.USER_ID) new_bet_counts,
round(sum(o.COIN_BUY_MONEY)) new_bet_coins ,
round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) new_prize_coins
from game.t_order_item o
inner join forum.t_user u on o.user_id=u.USER_CODE and u.crt_time>=@param0 and u.crt_time<=@param1
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
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.acct_num where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.ITEM_STATUS not in (-5,-10,210)
and o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<=@param1
and o.COIN_BUY_MONEY>0;



-- 老用户投注
select count(distinct o.USER_ID) old_bet_counts,
round(sum(o.COIN_BUY_MONEY)) old_bet_coins ,
round(IFNULL(sum(o.COIN_PRIZE_MONEY),0)+IFNULL(sum(o.COIN_RETURN_MONEY),0)) old_prize_coins
from game.t_order_item o
inner join forum.t_user u on o.user_id=u.USER_CODE and u.crt_time<@param0 
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
	inner join report.t_partner_group tg on tg.agent_acct_num=u2.acct_num  and tg.is_valid=0
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select u.user_id,tg.crt_time from report.t_partner_group tg 
	inner join forum.t_user u on tg.agent_acct_num=u.ACCT_NUM  where tg.is_valid=0

) tt on u.USER_ID=tt.user_id
and o.BALANCE_TIME>=tt.crt_time
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.ITEM_STATUS not in (-5,-10,210)
and o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<=@param1
and o.COIN_BUY_MONEY>0;