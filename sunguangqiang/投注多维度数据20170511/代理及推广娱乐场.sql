set @param0 = '2017-05-01'; 
set @param1 = '2017-06-01';
set @param2 = '5月份';

select @param2 '时间','娱乐场总',t1.counts '人数',ifnull(t1.bets,0)-ifnull(t3.cancel,0) '投注',t2.prize '返奖' from (
	select count(distinct ai.USER_ID) counts,sum(ai.CHANGE_VALUE) bets from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=1
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade')
) t1
left join 
(
	select sum(ai.CHANGE_VALUE) prize from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('dp_prize','lp_prize','tb_bingo')
) t2 on 1=1
left join 
(
	select sum(ai.CHANGE_VALUE) cancel from forum.t_acct_items ai
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('tb_cancel')
) t3 on 1=1

union all


select @param2 '时间','山东代理',t1.counts '人数',ifnull(t1.bets,0)-ifnull(t3.cancel,0) '投注',t2.prize '返奖' from (
	select count(distinct ai.USER_ID) counts,sum(ai.CHANGE_VALUE) bets from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=1
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade')
) t1
left join 
(
	select sum(ai.CHANGE_VALUE) prize from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('dp_prize','lp_prize','tb_bingo')
) t2 on 1=1
left join 
(
	select sum(ai.CHANGE_VALUE) cancel from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('tb_cancel')
) t3 on 1=1

union all


select @param2 '时间','内部推广',t1.counts '人数',ifnull(t1.bets,0)-ifnull(t3.cancel,0) '投注',t2.prize '返奖' from (
	select count(distinct ai.USER_ID) counts,sum(ai.CHANGE_VALUE) bets from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id!='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id!='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=1
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade')
) t1
left join 
(
	select sum(ai.CHANGE_VALUE) prize from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id!='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id!='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('dp_prize','lp_prize','tb_bingo')
) t2 on 1=1
left join 
(
	select sum(ai.CHANGE_VALUE) cancel from forum.t_acct_items ai
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
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 and tg.user_id!='5962840904510621262'
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 and tg.user_id!='5962840904510621262'
	) t on ai.USER_ID=t.user_id
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<@param1
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1001
	and ai.CHANGE_TYPE=0
	and ai.ITEM_EVENT in ('tb_cancel')
) t3 on 1=1;


