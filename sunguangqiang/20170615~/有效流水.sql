
BEGIN

set @param0 = '2017-06-01 12:00:00';

label1: WHILE @param0 <='2017-07-08 12:00:00' Do



INSERT into t_bet_coins_20170709(stat_date,counts1,bet_coins1,prize_coins1,effective_coins1)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts1,
sum(bet_coins) bet_coins1,
sum(prize_coins) prize_coins1,
sum(effective_coins) effective_coins1
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins<10000
on duplicate key update 
counts1 = values(counts1),
bet_coins1 = values(bet_coins1),
prize_coins1 = values(prize_coins1),
effective_coins1 = values(effective_coins1);


INSERT into t_bet_coins_20170709(stat_date,counts2,bet_coins2,prize_coins2,effective_coins2)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts2,
sum(bet_coins) bet_coins2,
sum(prize_coins) prize_coins2,
sum(effective_coins) effective_coins2
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=10000 and t.bet_coins<50000
on duplicate key update 
counts2 = values(counts2),
bet_coins2 = values(bet_coins2),
prize_coins2 = values(prize_coins2),
effective_coins2 = values(effective_coins2);


INSERT into t_bet_coins_20170709(stat_date,counts3,bet_coins3,prize_coins3,effective_coins3)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts3,
sum(bet_coins) bet_coins3,
sum(prize_coins) prize_coins3,
sum(effective_coins) effective_coins3
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=50000 and t.bet_coins<100000
on duplicate key update 
counts3 = values(counts3),
bet_coins3 = values(bet_coins3),
prize_coins3 = values(prize_coins3),
effective_coins3 = values(effective_coins3);

INSERT into t_bet_coins_20170709(stat_date,counts4,bet_coins4,prize_coins4,effective_coins4)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts4,
sum(bet_coins) bet_coins4,
sum(prize_coins) prize_coins4,
sum(effective_coins) effective_coins4
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=100000 and t.bet_coins<500000
on duplicate key update 
counts4 = values(counts4),
bet_coins4 = values(bet_coins4),
prize_coins4 = values(prize_coins4),
effective_coins4 = values(effective_coins4);

INSERT into t_bet_coins_20170709(stat_date,counts5,bet_coins5,prize_coins5,effective_coins5)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts5,
sum(bet_coins) bet_coins5,
sum(prize_coins) prize_coins5,
sum(effective_coins) effective_coins5
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=500000 and t.bet_coins<1000000
on duplicate key update 
counts5 = values(counts5),
bet_coins5 = values(bet_coins5),
prize_coins5 = values(prize_coins5),
effective_coins5 = values(effective_coins5);

INSERT into t_bet_coins_20170709(stat_date,counts6,bet_coins6,prize_coins6,effective_coins6)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts6,
sum(bet_coins) bet_coins6,
sum(prize_coins) prize_coins6,
sum(effective_coins) effective_coins6
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=1000000 and t.bet_coins<3000000
on duplicate key update 
counts6 = values(counts6),
bet_coins6 = values(bet_coins6),
prize_coins6 = values(prize_coins6),
effective_coins6 = values(effective_coins6);

INSERT into t_bet_coins_20170709(stat_date,counts7,bet_coins7,prize_coins7,effective_coins7)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts7,
sum(bet_coins) bet_coins7,
sum(prize_coins) prize_coins7,
sum(effective_coins) effective_coins7
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=3000000 and t.bet_coins<5000000
on duplicate key update 
counts7 = values(counts7),
bet_coins7 = values(bet_coins7),
prize_coins7 = values(prize_coins7),
effective_coins7 = values(effective_coins7);

INSERT into t_bet_coins_20170709(stat_date,counts8,bet_coins8,prize_coins8,effective_coins8)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts8,
sum(bet_coins) bet_coins8,
sum(prize_coins) prize_coins8,
sum(effective_coins) effective_coins8
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=5000000 and t.bet_coins<10000000
on duplicate key update 
counts8 = values(counts8),
bet_coins8 = values(bet_coins8),
prize_coins8 = values(prize_coins8),
effective_coins8 = values(effective_coins8);

INSERT into t_bet_coins_20170709(stat_date,counts9,bet_coins9,prize_coins9,effective_coins9)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts9,
sum(bet_coins) bet_coins9,
sum(prize_coins) prize_coins9,
sum(effective_coins) effective_coins9
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=10000000 and t.bet_coins<20000000
on duplicate key update 
counts9 = values(counts9),
bet_coins9 = values(bet_coins9),
prize_coins9 = values(prize_coins9),
effective_coins9 = values(effective_coins9);

INSERT into t_bet_coins_20170709(stat_date,counts10,bet_coins10,prize_coins10,effective_coins10)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts10,
sum(bet_coins) bet_coins10,
sum(prize_coins) prize_coins10,
sum(effective_coins) effective_coins10
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=20000000 and t.bet_coins<30000000
on duplicate key update 
counts10 = values(counts10),
bet_coins10 = values(bet_coins10),
prize_coins10 = values(prize_coins10),
effective_coins10 = values(effective_coins10);

INSERT into t_bet_coins_20170709(stat_date,counts11,bet_coins11,prize_coins11,effective_coins11)
select 
date(@param0) stat_date, 
count(distinct USER_ID) counts11,
sum(bet_coins) bet_coins11,
sum(prize_coins) prize_coins11,
sum(effective_coins) effective_coins11
from (
	select 
	o.USER_ID,
	sum(o.COIN_BUY_MONEY) bet_coins, 
	ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins,
	sum(
	    if(o.pass_type = '1001' 
		 and o.item_status not in (0,10,-5,-10,120,210) 
		 and o.MATCH_ODDS >= 1.5,
		 abs(ifnull(o.COIN_BUY_MONEY,0) - ifnull(o.COIN_PRIZE_MONEY,0)-ifnull(o.COIN_RETURN_MONEY,0)),
		 0 )) effective_coins
	from (
		select o.USER_ID,o.COIN_BUY_MONEY,o.COIN_PRIZE_MONEY,o.COIN_RETURN_MONEY,c.MATCH_ODDS,o.PASS_TYPE,o.ITEM_STATUS from game.t_order_item o 
		left join game.t_item_content c on c.ITEM_ID = o.item_id
		where o.CHANNEL_CODE='game'
		and o.BALANCE_TIME>=@param0
		and o.BALANCE_TIME<date_add(@param0,interval 1 day)
		group by o.ITEM_ID
		) o
	group by o.USER_ID
) t where t.bet_coins>=30000000 
on duplicate key update 
counts11 = values(counts11),
bet_coins11 = values(bet_coins11),
prize_coins11 = values(prize_coins11),
effective_coins11 = values(effective_coins11);

SET @param0 = date_add(@param0,interval 1 day);
end while label1;

end


