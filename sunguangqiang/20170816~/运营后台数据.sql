


select 

t.period_name '日期',
t.device_pv '访问PV',
t.device_uv '访问UV',
t.device_num '访问设备数',
t.online_unum '在线设备数',
t.first_dnum '首次激活',
t.second_dnum '二次激活',
t.active_dnum '活跃设备',
t.active_unum '活跃用户数',
t.first_buy_unum '新增充值人数',
t.first_buy_amount '新增充值金额',
t.buy_unum '充值人数',
t.buy_amount '充值金额',
t.first_srv_unum '新增购买服务人数',
t.first_srv_amount '新增购买服务钻石数',
t.srv_unum '购买服务人数',
t.srv_amount '购买服务钻石数',
t.first_bcoin_unum '新增购买游戏币人数',
t.first_bcoin_amount '新增购买游戏币金额',
t.buycoin_unum '购买游戏币人数',
t.buycoin_amount '购买游戏币金额',
t.diamond_user_cnt '充值钻石人数',
t.diamond_recharge_sum '充值钻石金额'

from t_rpt_overview_20170824 t;




select 
t.stat_date '日期',
t.fore_asserts_normal_coins '前总余额',
t.fobidden_counts '冻结人数',
t.fobidden_normal_coins'冻结金额',
t.recharge_coins '充值金币',
t.reward_coins '金币赠送',
t.quiz_coins_consume '竞猜消耗',
t.casino_coins_consume '娱乐场消耗',
t.mall_coins_consume '商城消耗',
t.abnormal_coins_consume '异常派奖',
t.system_coins_deviation '系统偏差',
t1.new_counts '全渠道新增充值人数',
t.all_new_recharge_coins '全渠道新增充值金币',
t2.counts '全渠道金币人数',
t.all_recharge_coins '全渠道金币充值'

from t_stat_coin_operate_dawn t
left join (

	select date(crt_time) stat_time,count(distinct t.charge_user_id) new_counts 
	from (
	select tc.charge_user_id,min(tc.crt_time) crt_time 
	from report.t_trans_user_recharge_coin tc
	group by tc.charge_user_id 
	) t group by stat_time

) t1 on t.stat_date=t1.stat_time

left join (

	select date(tc.crt_time) stat_time,count(distinct tc.charge_user_id) counts 
	from report.t_trans_user_recharge_coin tc 
	group by stat_time

) t2 on t.stat_date=t2.stat_time;






select 
t.stat_date '日期',
t.fore_asserts_normal_coins '前总余额',
t.fobidden_counts '冻结人数',
t.fobidden_normal_coins'冻结金额',
t.recharge_coins '充值金币',
t.reward_coins '金币赠送',
t.football_coins_consume '足球消耗',
t.basketball_coins_consume '篮球消耗',
t.exchange_coins_consume '交易消耗',
t.pk_room_coins_consume 'PK场消耗',
t.broadcast_coins_consume '广播消耗',
t.draw_coins_consume '抽奖消耗',
t.redeem_coins_consume '兑换消耗',
t.opt_coins_consume '手动派奖',
t.rotary_coins_consume '转盘消耗',
t.penalty_coins_consume '点球大战消耗',
t.user_coins_deposit '系统偏差',
t1.new_counts '全渠道新增充值人数',
t.t_new_recharge_coins '全渠道新增充值金币',
t2.counts '全渠道金币人数',
t.t_recharge_coins '全渠道金币充值'

from t_stat_coin_operate t
left join (

	select date(crt_time) stat_time,count(distinct t.charge_user_id) new_counts 
	from (
	select tc.charge_user_id,min(tc.crt_time) crt_time 
	from report.t_trans_user_recharge_coin tc
	group by tc.charge_user_id 
	) t group by stat_time

) t1 on t.stat_date=t1.stat_time

left join (

	select date(tc.crt_time) stat_time,count(distinct tc.charge_user_id) counts 
	from report.t_trans_user_recharge_coin tc 
	group by stat_time

) t2 on t.stat_date=t2.stat_time
where t.stat_date>='2016-01-01'
and t.stat_date<='2017-01-01';


