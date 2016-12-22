-- 每日充值钻石数据
set @param0='2016-11-01';
set @param1='2016-11-14 23:59:59';

select 
u.USER_ID '用户iD',u.NICK_NAME '用户昵称',u.USER_MOBILE '联系方式',u.CRT_TIME '注册时间',
td.crt_time '首充时间',
td.diamonds '首充钻石',
t1.diamonds '充值钻石',
t2.coins'充值金币',
t3.bet_coins '投注金币',
t3.bet_free_coins '投注体验币',
t4.buy_recom_value '购买推荐金额'
from t_stat_first_recharge_dmd tfd
inner join t_trans_user_recharge_diamond td on td.charge_user_id= tfd.USER_ID and td.crt_time=tfd.crt_time
and tfd.crt_time>=@param0 and tfd.crt_time<=@param1
inner join forum.t_user u on tfd.USER_ID=u.USER_ID
left join (
   select charge_user_id user_id,sum(td.diamonds) diamonds from report.t_trans_user_recharge_diamond td 
		where td.crt_time>=@param0 and td.crt_time<=@param1
		group by user_id
		) t1 on t1.USER_ID= tfd.USER_ID 
left join (
   select charge_user_id user_id,sum(tc.coins) coins  from report.t_trans_user_recharge_coin tc 
	where tc.crt_time>=@param0 and tc.crt_time<=@param1
	group by user_id
	  ) t2 on t2.USER_ID= tfd.USER_ID 
left join (
   select user_id,sum(o.COIN_BUY_MONEY) bet_coins,sum(o.P_COIN_BUY_MONEY) bet_free_coins from game.t_order_item o 
	where o.ITEM_STATUS not in (-5,-10,210) and o.CHANNEL_CODE ='GAME' 
		and o.crt_time>=@param0 and o.crt_time<=@param1
		group by user_id
	) t3 on t3.user_id= tfd.USER_CODE
left join (
    select user_id, sum(ai.change_value) buy_recom_value from forum.t_acct_items ai 
	 where ai.ITEM_STATUS=10 and ai.ITEM_EVENT in ('BUY_SERVICE','BUY_RECOM') 
		and ai.add_time>=@param0 and ai.add_time<=@param1
		group by user_id
	) t4 on t4.USER_ID= tfd.USER_ID
order by tfd.user_id asc




