set @param0 = '2017-06-26 12:00:00';
set @param1 = '2017-07-24 12:00:00';


select sum(t.ITEM_MONEY) from game.t_partner_order_info t 
where t.USER_ID in (select user_id from game.t_group_ref tt where tt.REF_ID=426093)
and date(t.EXPECT)>='2017-06-26' and date(t.EXPECT)<'2017-07-24'
and t.`TYPE`=2;


select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins
	from game.t_order_item o 
	inner join (
		select t.USER_ID,t.CRT_TIME from game.t_group_ref t where t.REF_ID in (
		426093,426141,426222,426249,426885,426888,426909,427428
		)
	) t on o.USER_ID=t.USER_ID
	-- left join game.t_item_content c on c.ITEM_ID = o.item_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<@param1
	and o.CRT_TIME>t.CRT_TIME;
	
	

select sum(t.ITEM_MONEY) from (
select * from (
	select date_format(DATE_SUB(t.balance_time,interval 12 hour), '%Y%m%d') EXPECT,
	sum(t.ITEM_MONEY) ITEM_ALL_MONEY,
	SUM(t.COIN_BUY_MONEY) ITEM_MONEY,
	sum(t.PRIZE_MONEY) PRIZE_ALL_MONEY,
	sum(t.COIN_PRIZE_MONEY) PRIZE_MONEY,
	sum(t.ITEM_MONEY - t.PRIZE_MONEY) PROFIT_ALL_COIN,
	sum(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) PROFIT_COIN,
	sum(case when t.pass_type = '1001' and t.item_status not in (0,10,-5,-10,120,210) and t.MATCH_ODDS >= 1.5 then ABS(t.COIN_BUY_MONEY - t.COIN_PRIZE_MONEY) else 0 end ) EFFECTIVE_MONEY
	from (
	select i.item_id,i.PASS_TYPE,i.ITEM_STATUS,i.ITEM_MONEY,i.COIN_BUY_MONEY,IFNULL(i.PRIZE_MONEY,0) + ifnull(i.RETURN_MONEY,0) PRIZE_MONEY,
	IFNULL(i.COIN_PRIZE_MONEY,0) + IFNULL(i.COIN_RETURN_MONEY,0) COIN_PRIZE_MONEY,i.BALANCE_TIME,c.MATCH_ODDS
	from t_order_item i
	inner join (
		select t.USER_ID,t.CRT_TIME from game.t_group_ref t where t.REF_ID in (
		426093,426141,426222,426249,426885,426888,426909,427428
		)
   ) t on i.USER_ID=t.USER_ID
   and i.BALANCE_TIME>t.crt_time
	left join t_item_content c on c.ITEM_ID = i.item_id
	where i.BALANCE_TIME is not null
	group by i.item_id  
	) t group by date_format(DATE_SUB(t.balance_time,interval 12 hour), '%Y%m%d')
	) ts where 1=1 
	order by ts.EXPECT
) t where date(t.EXPECT)>='2017-06-26' and date(t.EXPECT)<'2017-07-24';



