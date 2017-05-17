-- 渠道名	渠道编码	用户昵称	用户ID	联系方式	最后在线时间	注册时间	设备号	ip地址	投注金币	投注体验币	投注次数


set @param0='2017-03-01';
set @param1='2017-04-24 23:59:59';

-- update t_stat_msg_user t set t.recharge_counts=0

insert into t_stat_msg_user (user_id,nick_name)
select u.user_id,u.nick_name from  forum.t_user u 
inner join t_stat_msg_user t on u.user_id=t.user_id
on duplicate key update 
nick_name = values(nick_name);



insert into t_stat_msg_user (user_id,recharge_coins,recharge_counts)
select t.user_id,sum(tc.coins) coins,count(1) from report.t_trans_user_recharge_coin tc 
inner join t_stat_msg_user t on tc.charge_user_id=t.user_id
and tc.crt_time>=@param0
and tc.crt_time<=@param1
group by t.user_id
on duplicate key update 
recharge_coins = values(recharge_coins),
recharge_counts = values(recharge_counts);


insert into t_stat_msg_user (user_id,bet_counts,bet_coins,prize_coins)
select 
ai.USER_ID,
count(if(ai.change_type=1,ai.USER_ID,null)) bet_counts,
round(sum(if(ai.change_type=1,ai.CHANGE_VALUE,0))) bet_coins,
round(sum(if(ai.change_type=0,ai.CHANGE_VALUE,0))) prize_coins
from forum.t_acct_items ai 
inner join t_stat_msg_user t on t.user_id=ai.user_id
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE='1001'
and ai.ITEM_EVENT in ('trade_coin','prize_coin','bk_trade_coin','bk_prize_coin','PK_TRADE_COIN_USER','PK_PRIZE_COIN_USER','RE_ROOM_MONEY','EX_PRIZE_COIN','bk_EX_PRIZE_COIN')
group by ai.USER_ID
on duplicate key update 
bet_counts = values(bet_counts),
bet_coins = values(bet_coins),
prize_coins = values(prize_coins);



-- 2546634

select * from forum.t_acct_items ai  
inner join t_stat_msg_user tm on ai.USER_ID=tm.user_id
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1;


