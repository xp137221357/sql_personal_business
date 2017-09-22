set @param0='2017-08-01';
set @param1='2017-09-01';


select 
date_format(tm.MATCH_TIME,'%Y-%m-%d') stat_time,
count(if(tm.league_level=1,1,null)) '一级联赛场次',
count(if(tm.league_level=2,1,null)) '二级联赛场次',
count(if(tm.league_level not in (1,2),1,null)) '其他联赛场次'
from game.t_match_ref tm  
where tm.MATCH_TIME>=@param0 and tm.MATCH_TIME<=@param1
group by stat_time;



select * from (
select tm.LEAGUE_NAME,count(distinct o.USER_ID) counts,sum(o.COIN_BUY_MONEY) bet_coins 
from game.t_order_item o
inner join game.t_match_ref tm on o.BALANCE_MATCH_ID=tm.MATCH_ID 
where o.PAY_TIME>=@param0
and o.PAY_TIME<@param1
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
group by tm.LEAGUE_NAME
) t order by t.bet_coins desc;




select 
concat(@param0,'~',@param1),
tm.LEAGUE_NAME,
u.NICK_NAME,
u.ACCT_NUM,
sum(o.COIN_BUY_MONEY) bet_coins,
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins
from game.t_order_item o
inner join forum.t_user u on o.USER_ID=u.user_code
inner join game.t_match_ref tm on o.BALANCE_MATCH_ID=tm.MATCH_ID 
where o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<@param1
and o.ITEM_STATUS not in (-5,-10,0,10,200,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and tm.LEAGUE_NAME='中超'
and o.SPORT_TYPE='S'
group by u.USER_ID;


select 
concat(@param0,'~',@param1) '时间',
tm.LEAGUE_NAME '联赛名称',
concat(tm.HOME_TEAM_NAME,'VS',tm.AWAY_TEAM_NAME) '赛事名称',
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
o.PAY_TIME '投注时间',
o.BALANCE_TIME '结算时间',
sum(o.COIN_BUY_MONEY) '投注金币',
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) '返奖金币'
from game.t_order_item o
inner join forum.t_user u on o.USER_ID=u.user_code
inner join game.t_match_ref tm on o.BALANCE_MATCH_ID=tm.MATCH_ID 
where o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<@param1
and o.ITEM_STATUS not in (-5,-10,0,10,200,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and tm.LEAGUE_NAME='亚冠'
and o.SPORT_TYPE='S'
group by o.ITEM_ID;


-- 20170831000648000136211

select 
u.NICK_NAME,
o.ORDER_ID,
o.COIN_BUY_MONEY,
ifnull(o.COIN_PRIZE_MONEY,0)+ifnull(o.COIN_RETURN_MONEY,0) 
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.user_code
and o.ITEM_STATUS not in (-5,-10,0,10,200,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.BALANCE_MATCH_ID='20170831000648000136211'








