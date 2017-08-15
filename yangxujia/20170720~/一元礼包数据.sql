select max(id) from report.t_stat_yylb_20170731

BEGIN

set @curId = 1;
set @maxId = 15541;

update t_stat_yylb_20170731 t
inner join (
select ty.user_id,count(1) times from report.t_trans_user_recharge_coin tc 
inner join t_stat_yylb_20170731 ty on tc.charge_user_id=ty.user_id and tc.rmb_value!=1
group by ty.user_id
)tt on t.user_id=tt.user_id
set t.coin_recharge_times=times;


update t_stat_yylb_20170731 t
inner join (
select ty.user_id,count(1) times from report.t_trans_user_recharge_diamond tc 
inner join t_stat_yylb_20170731 ty on tc.charge_user_id=ty.user_id and tc.rmb_value!=1
group by ty.user_id
)tt on t.user_id=tt.user_id
set t.diamond_recharge_times=times;


label1: WHILE @curId <=@maxId Do


update t_stat_yylb_20170731 t
inner join (
	select t.user_id,count(1) bet_times 
	from forum.t_acct_items ai
	inner join t_stat_yylb_20170731 t on ai.USER_ID=t.user_id and t.id=@curId
	where 
	ai.ITEM_EVENT='trade_coin'
	and ai.PAY_TIME>='2017-01-01'
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
) tt on t.user_id=tt.user_id 
set t.bet_times=tt.bet_times;

update t_stat_yylb_20170731 t
inner join (
	select t.user_id,count(1) game_times 
	from forum.t_acct_items ai
	inner join t_stat_yylb_20170731 t on ai.USER_ID=t.user_id and t.id=@curId
	where 
	ai.ITEM_EVENT in ('dq_trade','lp_trade','TB_TRADE','FQ_TRADE','LPD_TRADE')
	and ai.PAY_TIME>='2017-01-01'
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
) tt on t.user_id=tt.user_id 
set t.game_times=tt.game_times;

update t_stat_yylb_20170731 t
inner join (
	select t.user_id,count(1) recom_times 
	from forum.t_acct_items ai
	inner join t_stat_yylb_20170731 t on ai.USER_ID=t.user_id and t.id=@curId
	where 
	ai.ITEM_EVENT in ('buy_recom','buy_service','buy_vip')
	and ai.PAY_TIME>='2017-01-01'
	and ai.ACCT_TYPE=1003
	and ai.ITEM_STATUS=10
) tt on t.user_id=tt.user_id 
set t.recom_times=tt.recom_times;


SET @curId = @curId+ 1;
end while label1;

END



select 
t.user_id '用户ID',
t.channel_no '渠道编码',
t.pay_time '充值一元礼包时间',
IFNULL(t.coin_recharge_times,0) '充值次数',
IFNULL(t.bet_times,0) '投注次数',
IFNULL(t.game_times,0) '游戏次数',
IFNULL(t.recom_times,0) '推荐次数',
if(u.`STATUS`=10,'正常','非正常') '是否正常用户'
from t_stat_yylb_20170731 t
inner join forum.t_user u on u.user_id=t.user_id;

select t.channel_no,count(1) '一元礼包充值人数'  from t_stat_yylb_20170731 t
group by t.channel_no;

select t.channel_no,count(1) '再次充值人数'  from t_stat_yylb_20170731 t
where t.recharge_times>0
group by t.channel_no;

select t.channel_no,count(1) '未投注人数'  from t_stat_yylb_20170731 t
where t.bet_times=0
group by t.channel_no;

select t.channel_no,count(1) '投注1次人数'  from t_stat_yylb_20170731 t
where t.bet_times=1
group by t.channel_no;

select t.channel_no,count(1) '投注2次人数'  from t_stat_yylb_20170731 t
where t.bet_times=2
group by t.channel_no;

select t.channel_no,count(1) '投注多于次人数'  from t_stat_yylb_20170731 t
where t.bet_times>2
group by t.channel_no;


select t.channel_no,count(1) '游戏1次人数'  from t_stat_yylb_20170731 t
where t.game_times=1
group by t.channel_no;

select t.channel_no,count(1) '游戏2次人数'  from t_stat_yylb_20170731 t
where t.game_times=2
group by t.channel_no;

select t.channel_no,count(1) '游戏多于次人数'  from t_stat_yylb_20170731 t
where t.game_times>2
group by t.channel_no;


select t.channel_no,count(1) '购买推荐1次人数'  from t_stat_yylb_20170731 t
where t.recom_times=1
group by t.channel_no;

select t.channel_no,count(1) '购买推荐2次人数'  from t_stat_yylb_20170731 t
where t.recom_times=2
group by t.channel_no;

select t.channel_no,count(1) '购买推荐多于次人数'  from t_stat_yylb_20170731 t
where t.recom_times>2
group by t.channel_no;




