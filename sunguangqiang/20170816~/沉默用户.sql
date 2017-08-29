
drop table t_stat_silent_user_20170821_temp;

create table t_stat_silent_user_20170821_temp
select o.USER_ID from game.t_order_item o 
where o.PAY_TIME>='2017-08-12'
and o.PAY_TIME<'2017-08-22'
and o.COIN_BUY_MONEY>0
group by o.USER_ID;



delete t from t_stat_silent_user_20170821 t
inner join t_stat_silent_user_20170821_temp t1 on t.USER_ID=t1.USER_ID;



update t_stat_silent_user_20170821 t 
inner join forum.t_user u on t.USER_ID=u.USER_CODE
set t.nick_name=u.NICK_NAME,
t.acct_num=u.ACCT_NUM,
t.user_mobile=u.USER_MOBILE,
t.id=u.USER_ID;


update t_stat_silent_user_20170821 t 
inner join game.t_group_ref t1 on t.USER_ID=t1.USER_ID
inner join game.t_group_ref t2 on t2.REF_ID=t1.ROOT_ID
inner join report.t_partner_group t3 on t2.USER_ID=t3.user_id
set t.agent_name=t3.agent;


set @cur_id=0;

insert into t_stat_silent_user_20170821(USER_ID,bet_coins,last_bet_time)
select t.USER_ID,sum(t1.CHANGE_VALUE),max(t1.END_TIME) last_bet_time from t_stat_silent_user_20170821 t
inner join t_stat_user_items_total_data t1 on t.user_id=t1.USER_ID and t.id=@cur_id
and t1.ITEM_EVENT in ('ft_bet_coins','bk_bet_coins')
and t1.ACCT_TYPE=1001
on duplicate key update  
bet_coins = VALUES(bet_coins)
;

insert into t_stat_silent_user_20170821(USER_ID,prize_coins)
select t.USER_ID,sum(t1.CHANGE_VALUE) from t_stat_silent_user_20170821 t
inner join t_stat_user_items_total_data t1 on t.user_id=t1.USER_ID and t.id=@cur_id
and t1.ITEM_EVENT in ('ft_prize_coins','bk_prize_coins')
and t1.ACCT_TYPE=1001
on duplicate key update  
prize_coins = VALUES(prize_coins)
;
	
	

insert into t_stat_silent_user_20170821(USER_ID,t.casino_bet_coins,last_casino_time)
select t.USER_ID,sum(t1.CHANGE_VALUE) casino_bet_coins,max(t1.END_TIME) last_casino_time from t_stat_silent_user_20170821 t
inner join t_stat_user_items_total_data t1 on t.user_id=t1.USER_ID and t.id=@cur_id
and t1.ITEM_EVENT in ('dq_trade','lp_trade','FQ_TRADE','TB_TRADE','LPD_TRADE','DWSP_TRADE')
and t1.ACCT_TYPE=1001
on duplicate key update  
casino_bet_coins = VALUES(casino_bet_coins),
last_casino_time = VALUES(last_casino_time)
;

insert into t_stat_silent_user_20170821(USER_ID,casino_prize_coins)
select t.USER_ID,sum(t1.CHANGE_VALUE) from t_stat_silent_user_20170821 t
inner join t_stat_user_items_total_data t1 on t.user_id=t1.USER_ID and t.id=@cur_id
and t1.ITEM_EVENT in ('dq_prize','lp_prize','FQ_PRIZE','TB_BINGO','LPD_BINGO','DWSP_BINGO')
and t1.ACCT_TYPE=1001
on duplicate key update  
casino_prize_coins = VALUES(casino_prize_coins)
;

insert into t_stat_silent_user_20170821(USER_ID,casino_cancel_coins)
select t.USER_ID,sum(t1.CHANGE_VALUE) from t_stat_silent_user_20170821 t
inner join t_stat_user_items_total_data t1 on t.user_id=t1.USER_ID and t.id=@cur_id
and t1.ITEM_EVENT in ('FQ_RETURN','TB_CANCEL','LPD_CANCEL','DWSP_CANCEL')
and t1.ACCT_TYPE=1001
on duplicate key update  
casino_prize_coins = VALUES(casino_prize_coins)
;



insert into t_stat_silent_user_20170821(USER_ID,last_luanch_time)
select t.USER_ID,max(t1.STAT_TIME) from t_stat_silent_user_20170821 t
inner join t_stat_user_online t1 on t.user_id=t1.USER_ID and t.id=@cur_id
on duplicate key update  
last_luanch_time = VALUES(last_luanch_time)
;


update t_stat_silent_user_20170821 t 
inner join forum.t_user_event e on t.user_id=e.USER_ID and e.EVENT_CODE='reg'  -- and t.id= cur_id
inner join report.t_stat_inner_ip_address tp on e.IP like concat(tp.inner_ip,'%')
set t.is_inner_ip=1;


select 
t.nick_name '用户昵称',
t.acct_num '会员号',
t.agent_name '代理名称',
t.user_mobile '手机号码',
t.bet_coins '历史投注',
t.prize_coins '历史返奖',
t.casino_bet_coins-ifnull(t.casino_cancel_coins,0) '娱乐场投注',
t.casino_prize_coins '娱乐场返奖',
t.last_bet_time '最后一次投注时间',
t.last_casino_time '最后一次娱乐场时间',
date(ifnull(t.last_luanch_time,ifnull(t.last_bet_time,'2016-06-01'))) '最后一次启动app时间',
if(t.is_inner_ip=1,'内部ip','外部ip') 'ip归属'
from t_stat_silent_user_20170821 t;