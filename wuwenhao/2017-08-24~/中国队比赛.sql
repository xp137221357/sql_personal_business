'70101：全场欧赔胜平负
70102：全场亚盘胜负
70103：全场比分
70104：全场大小球
70105：全场总进球
70111：半场欧赔胜平负
70112：半场亚盘胜负
70113：半场比分
70114：半场大小球
70115：半场总进球
70130：全场角球数
70131：全场罚牌数
70133：全场进球单双
70140：半场角球数
70141：半场罚牌数
70143：半场进球单双
70150：半全场
70160：下一个进球';


select 
u.NICK_NAME '昵称',
o.ORDER_ID '订单',
o.PLAY_ID '玩法',
o.COIN_BUY_MONEY '投注金币',
ifnull(o.COIN_PRIZE_MONEY,0)+ifnull(o.COIN_RETURN_MONEY,0) '返奖金币数'
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.user_code
and o.ITEM_STATUS not in (-5,-10,0,10,200,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.BALANCE_MATCH_ID='20170831000648000136211';



select t.*,t.COIN_RETURN_MONEY/t.COIN_BUY_MONEY from (
select 
sum(o.COIN_BUY_MONEY) COIN_BUY_MONEY,
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) COIN_RETURN_MONEY
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.user_code
and o.ITEM_STATUS not in (-5,-10,0,10,200,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.BALANCE_MATCH_ID='20170831000648000136211'
) t;




