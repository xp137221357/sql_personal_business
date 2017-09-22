

-- 电话号码	用户ID	投注次数	推荐次数	充值次数	是否正常	金币余额	充值次数	最后登录时间



-- create table t_stat_active_user_detail_chengjionglin

-- select 1 user_mobile,1 user_id,1 bet_counts,1 recom_counts,1 recharge_counts,1 is_valid,1 coin_balance,1 last_reg_time;

truncate t_stat_active_user_detail_chengjionglin;

set @param0='2017-08-30'
-- 用户状态

update t_stat_active_user_detail_chengjionglin t 
set t.user_mobile=replace(t.user_mobile,'\n',''),
t.user_mobile=replace(t.user_mobile,'\r','') 
where t.user_mobile like '%\n%'
or t.user_mobile like '%\r%';

update t_stat_active_user_detail_chengjionglin t
inner join forum.t_user u on t.user_mobile=u.USER_MOBILE
set t.STATUS=u.`STATUS`,
t.user_id=u.USER_ID;

-- 娱乐场次数
insert into t_stat_active_user_detail_chengjionglin(user_id,game_counts)
select ai.USER_ID,count(1) from forum.t_acct_items ai 
inner join report.t_stat_active_user_detail_chengjionglin t on ai.USER_ID=t.user_id
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('dq_trade','lp_trade','TB_TRADE','FQ_TRADE','LPD_TRADE','DWSP_TRADE','SIGNIN_LOTTO')
and ai.PAY_TIME<@param0
group by ai.USER_ID
on duplicate key update 
game_counts = values(game_counts);


-- 投注次数
insert into t_stat_active_user_detail_chengjionglin(user_id,bet_counts)
select ai.USER_ID,count(1) from forum.t_acct_items ai 
inner join report.t_stat_active_user_detail_chengjionglin t on ai.USER_ID=t.user_id
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
and ai.PAY_TIME<@param0
group by ai.USER_ID
on duplicate key update 
bet_counts = values(bet_counts);

-- 购买推荐次数
insert into t_stat_active_user_detail_chengjionglin(user_id,recom_counts)
select ai.USER_ID,count(1) from forum.t_acct_items ai 
inner join report.t_stat_active_user_detail_chengjionglin t on ai.USER_ID=t.user_id
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('buy_recom','buy_service','buy_vip')
and ai.PAY_TIME<@param0
group by ai.USER_ID
on duplicate key update 
recom_counts = values(recom_counts);

-- 充值次数
insert into t_stat_active_user_detail_chengjionglin(user_id,recharge_counts)
select t.charge_user_id,count(1) from (
select tc.charge_user_id from report.t_trans_user_recharge_coin tc
inner join t_stat_active_user_detail_chengjionglin t on tc.charge_user_id=t.user_id 
and tc.crt_time<@param0
union all
select tc.charge_user_id from report.t_trans_user_recharge_diamond tc
inner join t_stat_active_user_detail_chengjionglin t on tc.charge_user_id=t.user_id
and tc.crt_time<@param0
) t group by t.charge_user_id
on duplicate key update 
recharge_counts = values(recharge_counts);


-- 最后一次登录时间
insert into t_stat_active_user_detail_chengjionglin(user_id,last_reg_time)
select e.USER_ID,max(e.CRT_TIME) from  forum.t_user_event e
inner join t_stat_active_user_detail_chengjionglin t on e.user_id=t.user_id 
and e.crt_time<@param0
group by e.USER_ID
on duplicate key update 
last_reg_time = values(last_reg_time);

-- 金币余额
insert into t_stat_active_user_detail_chengjionglin(user_id,coin_balance)
select * from (
select ai.USER_ID,ai.AFTER_VALUE from forum.t_acct_items ai 
inner join t_stat_active_user_detail_chengjionglin t on ai.user_id=t.user_id 
and ai.PAY_TIME<@param0
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
order by ai.ITEM_ID desc
) t
group by t.USER_ID
on duplicate key update 
coin_balance = values(coin_balance);


select 
t.user_mobile '电话号码',
t.user_id '用户ID',
ifnull(t.bet_counts,0) '投注次数',
ifnull(t.game_counts,0) '娱乐场次数',
ifnull(t.recom_counts,0) '购买推荐次数',
ifnull(t.recharge_counts,0) '充值次数',
if(t.`status`=10,'正常','冻结') '状态',
ifnull(t.coin_balance,0) '金币余额',
t.last_reg_time '最后一次登录时间'
from t_stat_active_user_detail_chengjionglin t;






