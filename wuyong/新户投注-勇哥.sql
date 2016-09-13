
set @beginTime = '2016-06-10';
set @endTime = '2016-07-09';

select concat(@beginTime,'~',@endTime) '时间','Game-大户投注详情',round(ifnull(t1.bet_coins,0)) '投注金币',round(ifnull(t2.return_coins,0)) '返还金币',round(ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) '盈利金币',
round((ifnull(t2.return_coins,0)-ifnull(t1.bet_coins,0)) / 100,0)  '盈利金额(RMB)'
from (select 
round(sum(oi.ITEM_MONEY)) bet_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.t_user u where u.crt_time>=@beginTime and u.crt_time<=@endTime  and u.nick_name not in ('朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠',
'晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫'))) t1,(select 
sum(oi.PRIZE_MONEY) return_coins
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
and oi.USER_ID in (select USER_CODE from forum.t_user u where u.crt_time>=@beginTime and u.crt_time<=@endTime  and u.nick_name not in ('朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠',
'晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫'))) t2