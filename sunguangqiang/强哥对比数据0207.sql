set @param0='2017-01-20 00:00:00';
set @param1='2017-01-30 23:59:59';

select date(ai.ADD_TIME) stat_time,count(distinct ai.USER_ID),sum(ai.CHANGE_VALUE) 
from forum.t_acct_items ai 
left join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID 
inner join forum.t_user u on u.USER_ID= tu.USER_ID and u.CLIENT_ID='BYAPP' and u.group_type != 1 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT='BUY_DIAMEND' 
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
group by stat_time;

select date(ai.ADD_TIME) stat_time,count(distinct ai.USER_ID),sum(ai.CHANGE_VALUE) 
from forum.t_acct_items ai 
left join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID 
inner join forum.t_user u on u.USER_ID= ai.USER_ID and u.CLIENT_ID='BYAPP' and u.group_type != 1 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('BUY_SERVICE','BUY_RECOM') 
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<=@param1
group by stat_time;



set @param0='2017-01-08';
select 
	@param0 stat_date, 
	sum(b.coins) - sum(a.coins) coins,
	sum(b.free_coins) - sum(a.free_coins) free_coins
	 from (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		from forum.t_acct_items ai 
		where ai.ITEM_EVENT = 'CP_TRADE' 
		AND ai.ADD_TIME >= @param0
		and ai.ADD_TIME <= concat(@param0,' 23:59:59')
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001, 1015)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) a , (
		select sum(if(ai.ACCT_TYPE = 1001, ai.CHANGE_VALUE, 0)) coins, 
		sum(if(ai.ACCT_TYPE = 1015, ai.CHANGE_VALUE, 0)) free_coins
		 from forum.t_acct_items ai 
		where ai.ITEM_EVENT in ('CP_PRIZE' , 'CP_TRADE-REFUND')
		AND ai.ADD_TIME >= @param0
		and ai.ADD_TIME <= concat(@param0,' 23:59:59')
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001, 1015)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	) b
	

set @param0='2017-01-01';
select u.NICK_NAME,ai.CHANGE_VALUE,ai.CHANGE_TYPE,ai.ITEM_EVENT,ai.COMMENTS
		from forum.t_acct_items ai 
		inner join forum.t_user u on u.USER_ID=ai.USER_ID
		where ai.ITEM_EVENT in ('CP_PRIZE' , 'CP_TRADE-REFUND','CP_TRADE')
		AND ai.ADD_TIME >= @param0
		and ai.ADD_TIME <= concat(@param0,' 23:59:59')
		and ai.ITEM_STATUS in (10, -10)
		and ai.ACCT_TYPE in (1001)
		and ai.USER_ID not in (
		select u.user_id from report.v_user_system u
		)
	
	

	
	
	



