

set @param0='2017-04-01';
set @param1='2017-05-01';
set @param2='四月份';

-- 充值

select @param2 '时间' ,'充值-原始',count(distinct t1.user_id) '原始人数','-'
from report.t_stat_first_recharge_coin t1
where t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1

union all

select @param2 '时间','充值-充值',count(distinct t1.user_id) '充值人数',sum(t2.rmb_value) '充值金币金额' 
from report.t_stat_first_recharge_coin t1
inner join report.t_trans_user_recharge_coin t2 on t1.USER_ID=t2.charge_user_id 
and t2.charge_method='app'
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and t2.CRT_TIME>=@param0 and t2.CRT_TIME<@param1

union all


select @param2 '时间','充值-出题',count(distinct t1.USER_ID) '使用答题人数',sum(ai.CHANGE_VALUE) '答题出金币数' 
from report.t_stat_first_recharge_coin t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=1
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='cp_trade'

union all


select @param2 '时间','充值-答题',count(distinct t1.USER_ID) '答题人数',sum(ai.CHANGE_VALUE) '答题进金币数' 
from report.t_stat_first_recharge_coin t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='cp_prize'

union all

select @param2 '时间','充值-投注',count(distinct t1.USER_ID) '投注人数',sum(ai.CHANGE_VALUE) '投注金币数' 
from report.t_stat_first_recharge_coin t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=1
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')

union all

select @param2 '时间','充值-返奖',count(distinct t1.USER_ID) '返奖人数',sum(ai.CHANGE_VALUE) '返奖金币数' 
from report.t_stat_first_recharge_coin t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT in ('prize_coin','bk_prize_coin');


--  注册

select @param2 '时间','注册-原始',count(distinct t1.user_id) '原始人数','-'
from report.t_trans_user_attr t1
where t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1

union all


select @param2 '时间','注册-充值',count(distinct t1.user_id) '充值人数',sum(t2.rmb_value) '充值金币金额' 
from report.t_trans_user_attr t1
inner join report.t_trans_user_recharge_coin t2 on t1.USER_ID=t2.charge_user_id
and t2.charge_method='app'
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and t2.CRT_TIME>=@param0 and t2.CRT_TIME<@param1

union all


select @param2 '时间','注册-出题',count(distinct t1.USER_ID) '使用答题人数',sum(ai.CHANGE_VALUE) '答题出金币数' 
from report.t_trans_user_attr t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=1
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='cp_trade'

union all


select @param2 '时间','注册-答题',count(distinct t1.USER_ID) '答题人数',sum(ai.CHANGE_VALUE) '答题进金币数' 
from report.t_trans_user_attr t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='cp_prize'

union all


select @param2 '时间','注册-投注',count(distinct t1.USER_ID) '投注人数',sum(ai.CHANGE_VALUE) '投注金币数' 
from report.t_trans_user_attr t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=1
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')

union all

select @param2 '时间','注册-返奖',count(distinct t1.USER_ID) '返奖人数',sum(ai.CHANGE_VALUE) '返奖金币数' 
from report.t_trans_user_attr t1
inner join forum.t_acct_items ai on t1.USER_ID=ai.USER_ID
and t1.CRT_TIME>=@param0 and t1.CRT_TIME<@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_TYPE=0
and ai.PAY_TIME>=@param0 and ai.PAY_TIME<@param1
and ai.ITEM_EVENT in ('prize_coin','bk_prize_coin');

