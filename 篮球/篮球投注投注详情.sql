set @param0 = '2017-02-01 12:00:00'; 
set @param1 = '2017-04-05 13:59:59';

select date(o.CRT_TIME) stat_time,
if(t.COST_TYPE=1001,'金币','体验币') '金币类型',
count(distinct o.USER_ID) '人数',
count(distinct o.ITEM_ID) '单数',
count(distinct tc.MATCH_ID) '场次',round(sum(t.ITEM_MONEY)) '投注'
from wwgame_bk.t_ww_order_item o 
inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
where t.CRT_TIME>=@param0
and t.CRT_TIME<=@param1
group by stat_time,t.COST_TYPE;