

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
where o.PAY_TIME>='2017-08-01'
and o.PAY_TIME<'2017-09-01'
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.SPORT_TYPE='S'
group by tm.LEAGUE_NAME
) t order by t.bet_coins desc;




