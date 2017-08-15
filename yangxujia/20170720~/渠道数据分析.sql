-- 07-15~07-27，07-28~08-09，apple,360，oppo

set @param0='2017-07-15';
set @param1='2017-07-28';
set @param2=concat(@param0,'~',@param1);

-- 渠道，终端，首次激活，新增注册，充值人数，金币金额，钻石金额，投注量，返奖金额，返奖率，投注场次，投注人数，投注订单数，人均订单，每单金额

select @param2 '时间',
t.CHANNEL_NO '渠道编码',
sum(t.FIRST_DNUM) '首次激活' 
from report.t_rpt_overview t 
where t.PERIOD_TYPE=1
and t.PERIOD_NAME>=@param0
and t.PERIOD_NAME<@param1
and t.CHANNEL_NO in ('apple','360','oppo')
group by t.CHANNEL_NO;


select 
@param2 '时间',
tu.CHANNEL_NO '渠道编码',
count(distinct tu.USER_ID) '注册人数',
count(distinct tc.charge_user_id) '充值人数',
sum(if(tc.types='coin',tc.rmb_value,0)) '充值金币金额',
sum(if(tc.types='diamond',tc.rmb_value,0)) '充值钻石金额'
from report.t_trans_user_attr tu 
left join (
  select tc.charge_user_id,tc.rmb_value,'coin' types from report.t_trans_user_recharge_coin tc where tc.charge_method='app' and tc.crt_time>=@param0 and tc.crt_time<@param1
  
  union all
  
  select tc.charge_user_id,tc.rmb_value ,'diamond' types from report.t_trans_user_recharge_diamond tc where tc.charge_method='app' and tc.crt_time>=@param0 and tc.crt_time<@param1

) tc on tu.USER_ID= tc.charge_user_id
where tu.CRT_TIME>=@param0
and tu.CRT_TIME<@param1
and tu.CHANNEL_NO in ('apple','360','oppo')
group by tu.CHANNEL_NO;


select 
@param2 '时间',
tu.CHANNEL_NO '渠道编码',
count(distinct o.BALANCE_MATCH_ID) 投注场次,
count(distinct tu.USER_ID) '投注人数',
count(o.ORDER_ID) '投注订单数',
sum(o.COIN_BUY_MONEY) '投注金币数',
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) '返奖金币数'
 from game.t_order_item o 
inner join report.t_trans_user_attr tu on o.USER_ID=tu.USER_CODE 
where o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.PAY_TIME>=@param0
and o.PAY_TIME<@param1
and o.COIN_BUY_MONEY>0
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<@param1
and tu.CHANNEL_NO in ('apple','360','oppo')
group by tu.CHANNEL_NO;

-- o.COIN_EXTRA_MONEY