insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
		select ai.user_id,ai.ITEM_EVENT,ai.ACCT_TYPE,sum(ai.CHANGE_VALUE) CHANGE_VALUE,min(ai.PAY_TIME) begin_time,max(ai.PAY_TIME) end_time
		from forum.t_acct_items ai
		inner join forum.t_user u on ai.user_id =u.USER_ID and u.CLIENT_ID='byapp' and u.CRT_TIME<stat_time
		where ai.USER_ID = cur_user_id
		and ai.pay_time<stat_time
		group by ai.ITEM_EVENT,ai.ACCT_TYPE
		on duplicate key update 
		CHANGE_VALUE = values(CHANGE_VALUE),
		begin_time = values(begin_time),
		end_time = values(end_time);


insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'ft_bet_coins',
	'1001',
	ifnull(sum(o.COIN_BUY_MONEY),0) bet_coins,
	min(o.PAY_TIME) begin_time,
	max(o.pay_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='S'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'ft_bet_coins',
	'1015',
	ifnull(sum(o.P_COIN_BUY_MONEY),0) bet_coins,
	min(o.PAY_TIME) begin_time,
	max(o.pay_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='S'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'ft_prize_coins',
	'1001',
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	min(o.BALANCE_TIME) begin_time,
	max(o.BALANCE_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='S'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'ft_prize_coins',
	'1015',
	ifnull(sum(o.P_COIN_PRIZE_MONEY),0)+ifnull(sum(o.P_COIN_RETURN_MONEY),0) prize_coins,
	min(o.BALANCE_TIME) begin_time,
	max(o.BALANCE_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='S'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	
	
	
	-- ------
insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'bk_bet_coins',
	'1001',
	ifnull(sum(o.COIN_BUY_MONEY),0) bet_coins,
	min(o.PAY_TIME) begin_time,
	max(o.pay_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='BB'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'bk_bet_coins',
	'1015',
	ifnull(sum(o.P_COIN_BUY_MONEY),0) bet_coins,
	min(o.PAY_TIME) begin_time,
	max(o.pay_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='BB'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'bk_prize_coins',
	'1001',
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	min(o.BALANCE_TIME) begin_time,
	max(o.BALANCE_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='BB'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	

insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE,begin_time,end_time)
	select 
	o.USER_ID,
	'bk_prize_coins',
	'1015',
	ifnull(sum(o.P_COIN_PRIZE_MONEY),0)+ifnull(sum(o.P_COIN_RETURN_MONEY),0) prize_coins,
	min(o.BALANCE_TIME) begin_time,
	max(o.BALANCE_TIME) end_time
	from game.t_order_item o 
	inner join forum.t_user u on o.USER_ID=u.USER_CODE and u.CRT_TIME<stat_time and u.USER_ID= cur_user_id
	where o.CHANNEL_CODE in ('game','jrtt-jingcai')
	and o.SPORT_TYPE='BB'
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE),
	begin_time = values(begin_time),
	end_time = values(end_time);
	