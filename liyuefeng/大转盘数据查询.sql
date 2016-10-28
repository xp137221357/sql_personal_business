set @beginTime = '2016-09-22 00:00:00';
set @endTime = '2016-09-28 23:59:59';
-- ITEM_EVENT: 'LP_TRADE',COMMENTS: '{"opt_name": "转盘抽奖扣款"}'
						
-- ITEM_EVENT: 'LP_PRIZE',COMMENTS: '{"opt_name": "转盘抽奖奖励"}'

-- t_roulette_act 抽奖详细表
-- t_game_region  分区统计

-- 转盘抽奖投入
select '投入',concat(@beginTime,'~',@endTime) '日期',
sum(if(ai.ACCT_TYPE='1015',ai.CHANGE_VALUE,0)) '体验币',
sum(if(ai.ACCT_TYPE='1001',ai.CHANGE_VALUE,0)) '金币'
 from forum.t_acct_items ai 
where ai.ITEM_EVENT='LP_TRADE'
and ai.COMMENTS like '%转盘抽奖扣款%'
and ai.ADD_TIME>=@beginTime
and ai.ADD_TIME<=@endTime

union all

-- 转盘抽奖返奖
select '返还',concat(@beginTime,'~',@endTime) '日期',
sum(if(ai.ACCT_TYPE='1015',ai.CHANGE_VALUE,0)) '体验币',
sum(if(ai.ACCT_TYPE='1001',ai.CHANGE_VALUE,0)) '金币'
 from forum.t_acct_items ai 
where ai.ITEM_EVENT='LP_PRIZE'
and ai.COMMENTS like '%转盘抽奖奖励%'
and ai.ADD_TIME>=@beginTime
and ai.ADD_TIME<=@endTime;


