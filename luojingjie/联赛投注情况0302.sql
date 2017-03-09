set @param0='2017-01-01 00:00:00';
set @param1='2017-02-28 23:59:59';


select t.*,round(t.bet_coin-t.prize_coin) '盈利',concat(round(t.prize_coin*100/t.bet_coin,2),'%') '返奖率' from(
select tl.LEAGUE_NAME_CN,count(distinct tm.MATCH_ID) counts,round(sum(o.COIN_BUY_MONEY)) bet_coin,round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coin 
from game.t_order_item o 
inner join fb_main.t_match tm on o.BALANCE_MATCH_ID=tm.MATCH_ID and o.PASS_TYPE=1001 and o.CHANNEL_CODE='game' and o.COIN_BUY_MONEY>0
and tm.MATCH_TIME>=@param0 and tm.MATCH_TIME<=@param1
inner join fb_main.t_league_match tl on tm.LEAGUE_ID=tl.LEAGUE_ID
group by tm.LEAGUE_ID
) t ;


select t.*,round(t.bet_coin-t.prize_coin) '盈利',concat(round(t.prize_coin*100/t.bet_coin,2),'%') '返奖率' from(
select u.NICK_NAME,u.USER_ID,count(distinct tm.MATCH_ID) counts,round(sum(o.COIN_BUY_MONEY)) bet_coin,round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coin 
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE 
inner join fb_main.t_match tm on o.BALANCE_MATCH_ID=tm.MATCH_ID and o.PASS_TYPE=1001 and o.CHANNEL_CODE='game'
and tm.MATCH_TIME>=@param0 and tm.MATCH_TIME<=@param1 and o.COIN_BUY_MONEY>=1000000
group by o.USER_ID
) t where t.prize_coin/t.bet_coin>0.9;


-- 玩法(包括串关)
select t.*,round(t.bet_coin-t.prize_coin) '盈利',concat(round(t.prize_coin*100/t.bet_coin,2),'%') '返奖率' from(
select o.PLAY_ID,count(distinct tm.MATCH_ID) counts,round(sum(o.COIN_BUY_MONEY)) bet_coin,round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coin 
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE 
inner join fb_main.t_match tm on o.BALANCE_MATCH_ID=tm.MATCH_ID and o.CHANNEL_CODE='game' 
and tm.MATCH_TIME>=@param0 and tm.MATCH_TIME<=@param1 and o.COIN_BUY_MONEY>0
group by o.PLAY_ID
) t;
