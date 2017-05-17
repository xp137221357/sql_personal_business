set @param0='2017-03-21';
set @param1='2017-03-21 23:59:59';

select 
*
-- sum(t.counts) 

from (
select 
tu.CHANNEL_NAME '渠道名',
tu.CHANNEL_NO '渠道编码',
count(distinct ai.USER_ID) counts 
from forum.t_acct_items ai 
inner join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID
where
ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
and ai.ITEM_STATUS in (10,-10)
and ai.ADD_TIME >= @param0 
and ai.ADD_TIME <= @param1
group by tu.CHANNEL_NO
) t order by t.counts desc