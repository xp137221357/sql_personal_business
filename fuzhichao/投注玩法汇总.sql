

set @param0='2017-03-03';

set @param1='2017-05-04 23:59:59';
select 

case o.PLAY_ID
	when 70101 then '全场欧赔胜平负'
	when 70102 then '全场亚盘胜负'
	when 70103 then '全场比分'
	when 70104 then '全场大小球'
	when 70105 then '全场总进球'
	when 70111 then '半场欧赔胜平负'
	when 70112 then '半场亚盘胜负'
	when 70113 then '半场比分'
	when 70114 then '半场大小球'
	when 70115 then '半场总进球'
	when 70130 then '全场角球数'
	when 70131 then '全场罚牌数'
	when 70133 then '全场进球单双'
	when 70140 then '半场角球数'
	when 70141 then '半场罚牌数'
	when 70143 then '半场进球单双'
	when 70150 then '半全场'
	when 70160 then '下一个进球'
	else '' 
end as '玩法',

count(distinct o.USER_ID) '投注人数',

round(sum(o.COIN_BUY_MONEY)) '投注金币数'

from game.t_order_item o 
where o.CHANNEL_CODE ='jrtt-jingcai'
and o.SPORT_TYPE='S'
and o.COIN_BUY_MONEY>0
and o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
GROUP BY o.PLAY_ID;



