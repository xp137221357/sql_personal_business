-- 11424347
-- 11039270

select * from (
   select 
	if(count(t.USER_ID)>0,date_add(curdate(),interval -1 day),null) STAT_TIME,
	'3167248269467305961',
	sum(t.ITEM_ALL_MONEY),
	sum(t.ITEM_MONEY),
	sum(t.PRIZE_ALL_MONEY),
	sum(t.PRIZE_MONEY),
	sum(t.PROFIT_ALL_COIN),
	sum(t.PROFIT_COIN),
	sum(t.EFFECTIVE_MONEY),
	sum(if(t.OFFICIAL_PAY_MONEY>0,1,0)),
	sum(t.OFFICIAL_PAY_MONEY),
	sum(if(t.OTHER_PAY_MONEY>0,1,0)),
	sum(t.OTHER_PAY_MONEY),
	count(distinct tu.child_user_id)-1 
	from 
	(select tu.child_user_id  from report.t_stat_partner_user tu where tu.USER_ID='13167248269467305961'
	 union all
	 select '13167248269467305961' from dual
	 )tu 
	left join report.t_partner_order_info t on t.USER_ID=tu.child_user_id and t.STAT_TIME=date_add(curdate(),interval -1 day)
	) t where t.STAT_TIME is not null;
	
	
	
select u.NICK_NAME,u.ACCT_NUM,ai.USER_ID,ai.ITEM_EVENT,sum(ai.CHANGE_VALUE) 
from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID
where ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1
and ai.PAY_TIME>=date_add(curdate(),interval -1 day)
and ai.PAY_TIME<curdate()
group by ai.USER_ID,ai.ITEM_EVENT;
		

		
		

		