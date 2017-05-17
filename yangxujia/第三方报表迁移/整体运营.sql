stat_time,channel_no,device_num,online_unum,first_dnum,second_dnum,active_dnum,reg_unum,first_buy_unum,first_buy_amount,buy_unum,buy_amount,
first_srv_unum,first_srv_amount,srv_unum,srv_amount,first_bcoin_unum,first_bcoin_amount,buycoin_unum,buycoin_amount,visual_status,
device_pv,device_uv,
diamond_user_cnt,diamond_recharge_sum,
ft_bet_users,ft_bet_counts,ft_bet_coins,ft_return_coins,
bk_bet_users,bk_bet_counts,bk_bet_coins,bk_return_coins,

insert into t_rpt_third_overview(stat_time,channel_no,device_num,online_unum,first_dnum,second_dnum,active_dnum,reg_unum,first_buy_unum,first_buy_amount,buy_unum,buy_amount,first_srv_unum,first_srv_amount,srv_unum,srv_amount,first_bcoin_unum,first_bcoin_amount,buycoin_unum,buycoin_amount,visual_status)
SELECT 
t.period_name, 
t.CHANNEL_NO,
ceil(SUM(t.device_num)*ifnull(tc.device_num,1)) device_num, 
ceil(SUM(t.online_unum)*ifnull(tc.online_unum,1)) online_unum, 
ceil(SUM(t.first_dnum)*ifnull(tc.first_dnum,1)) first_dnum, 
ceil(SUM(t.second_dnum)*ifnull(tc.second_dnum,1)) second_dnum, 
ceil(SUM(t.active_dnum)*ifnull(tc.active_dnum,1)) active_dnum, 
ceil(SUM(t.reg_unum)*ifnull(tc.reg_unum,1)) reg_unum, 
ceil(SUM(t.first_buy_unum)*ifnull(tc.first_buy_unum,1))  first_buy_unum, 
ceil(SUM(t.first_buy_amount)*ifnull(tc.first_buy_amount,1))  first_buy_amount, 
ceil(SUM(t.buy_unum)*ifnull(tc.buy_unum,1))  buy_unum, 
ceil(SUM(t.buy_amount)*ifnull(tc.buy_amount,1))  buy_amount, 
ceil(SUM(t.first_srv_unum)*ifnull(tc.first_srv_unum,1))  first_srv_unum, 
ceil(SUM(t.first_srv_amount)*ifnull(tc.first_srv_amount,1))  first_srv_amount, 
ceil(SUM(t.srv_unum)*ifnull(tc.srv_unum,1))  srv_unum, 
ceil(SUM(t.srv_amount)*ifnull(tc.srv_amount,1))  srv_amount, 
ceil(SUM(t.first_bcoin_unum)*ifnull(tc.first_bcoin_unum,1))  first_bcoin_unum, 
ceil(SUM(t.first_bcoin_amount)*ifnull(tc.first_bcoin_amount,1))  first_bcoin_amount, 
ceil(SUM(t.buycoin_unum)*ifnull(tc.buycoin_unum,1))  buycoin_unum, 
ceil(SUM(t.buycoin_amount)*ifnull(tc.buycoin_amount,1))  buycoin_amount,
if(ifnull(now()>tc.BEGIN_TIME,1) and ifnull(now()<tc.END_TIME,1),1,0)  visual_status
FROM report.t_rpt_overview t
left join report.t_rpt_channel_discount tc on t.CHANNEL_NO=tc.CHANNEL_NO
WHERE period_type='1' 
AND period_name>=date_add(curdate(),interval -1 day) 
AND period_name<curdate()
GROUP BY t.period_name,t.CHANNEL_NO
on duplicate key update
device_num = values(device_num),
online_unum = values(online_unum),
first_dnum = values(first_dnum),
second_dnum = values(second_dnum),
active_dnum = values(active_dnum),
reg_unum = values(reg_unum),
first_buy_unum = values(first_buy_unum),
first_buy_amount = values(first_buy_amount),
buy_unum = values(buy_unum),
buy_amount = values(buy_amount),
first_srv_unum = values(first_srv_unum),
first_srv_amount = values(first_srv_amount),
srv_unum = values(srv_unum),
srv_amount = values(srv_amount),
first_bcoin_unum = values(first_bcoin_unum),
first_bcoin_amount = values(first_bcoin_amount),
buycoin_unum = values(buycoin_unum),
buycoin_amount = values(buycoin_amount),
visual_status = values(visual_status);

insert into t_rpt_third_overview(stat_time,channel_no,device_pv,device_uv)
select 
t.period_name, 
t.CHANNEL_NO,
SUM(t.device_pv) device_pv,
SUM(t.device_uv) device_uv
 from (
	SELECT 
	t.period_name, 
	t.CHANNEL_NO,
	ceil(SUM(t.PV)*ifnull(tc.device_pv,1)) device_pv, 
	ceil(SUM(t.UV)*ifnull(tc.device_uv,1)) device_uv
	FROM report.t_rpt_channel_pv_uv t
	left join report.t_rpt_channel_discount tc on t.CHANNEL_NO=tc.CHANNEL_NO
	WHERE period_type='1' 
	AND period_name>=date_add(curdate(),interval -1 day) 
	AND period_name<curdate()
	GROUP BY t.period_name,t.CHANNEL_NO
	union all
	SELECT 
	t.period_name, 
	t.CHANNEL_NO,
	ceil(SUM(t.PV)*ifnull(tc.device_pv,1)) device_pv, 
	ceil(SUM(t.UV)*ifnull(tc.device_uv,1)) device_uv
	FROM report.t_rpt_h5_url_pv_uv t
	left join report.t_rpt_channel_discount tc on t.CHANNEL_NO=tc.CHANNEL_NO
	WHERE period_type='1' 
	AND period_name>=date_add(curdate(),interval -1 day) 
	AND period_name<curdate()
	GROUP BY t.period_name,t.CHANNEL_NO
) t GROUP BY t.period_name,t.CHANNEL_NO
on duplicate key update
device_pv = values(device_pv),
device_uv = values(device_uv);

insert into t_rpt_third_overview(stat_time,channel_no,diamond_user_cnt,diamond_recharge_sum)
select 
DATE(tr.crt_time) period_name, 
tu.CHANNEL_NO,
ceil(COUNT(DISTINCT tr.charge_user_id)*ifnull(tc.diamond_user_cnt,1)) diamond_user_cnt, 
ceil(SUM(tr.rmb_value)*ifnull(tc.diamond_recharge_sum,1)) diamond_recharge_sum
from report.t_trans_user_recharge_diamond tr 
inner join report.t_trans_user_attr tu on tr.charge_user_id=tu.USER_ID 
left join report.t_rpt_channel_discount tc on tu.CHANNEL_NO=tc.CHANNEL_NO
where tr.crt_time >=date_add(curdate(),interval -1 day) 
and tr.crt_time <curdate()
group by period_name,tu.CHANNEL_NO
on duplicate key update
diamond_user_cnt = values(diamond_user_cnt),
diamond_recharge_sum = values(diamond_recharge_sum);

insert into t_rpt_third_overview(stat_time,channel_no,ft_bet_users,ft_bet_counts,ft_bet_coins)
select 
t1.stat_time,
t1.CHANNEL_NO,
ceil(t1.bet_users*ifnull(tc.ft_bet_users,1)) ft_bet_users,
ceil(t1.bet_counts*ifnull(tc.ft_bet_counts,1)) ft_bet_counts,
ceil(t1.bet_coins*ifnull(tc.ft_bet_coins,1)) ft_bet_coins
from (
	select date(oi.CRT_TIME) stat_time,
	   tu.CHANNEL_NO,
	   count(distinct oi.user_id) bet_users,
	   count(1) bet_counts,
		round(SUM(ifnull(oi.COIN_BUY_MONEY,0))) bet_coins
	from game.t_order_item oi
	INNER JOIN report.t_trans_user_attr tu ON oi.USER_ID = tu.USER_CODE
	where  
		oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
		and oi.item_status not in (-5,-10,210)
		and oi.PAY_TIME >= date_add(curdate(),interval -1 day) 
		and oi.PAY_TIME <curdate() 
	group by stat_time,tu.CHANNEL_NO
) t1
left join report.t_rpt_channel_discount tc on t1.CHANNEL_NO=tc.CHANNEL_NO
group by t1.stat_time,t1.CHANNEL_NO
on duplicate key update
ft_bet_users = values(ft_bet_users),
ft_bet_counts = values(ft_bet_counts),
ft_bet_coins = values(ft_bet_coins);


insert into t_rpt_third_overview(stat_time,channel_no,ft_return_coins)
select 
t1.stat_time,
t1.CHANNEL_NO,
ceil(t1.return_coins*ifnull(tc.ft_return_coins,1)) ft_return_coins
from (
	select date(oi.BALANCE_TIME) stat_time,
	   tu.CHANNEL_NO,
		round(ifnull(SUM(oi.COIN_PRIZE_MONEY),0)+ifnull(SUM(oi.COIN_RETURN_MONEY),0)) return_coins
	from game.t_order_item oi 
	INNER JOIN report.t_trans_user_attr tu ON oi.USER_ID = tu.USER_CODE
	where  oi.CHANNEL_CODE in ('GAME','jrtt-jingcai')
	   and oi.item_status not in (-5,-10,210)
		and oi.BALANCE_STATUS=20
		and oi.BALANCE_TIME >=date_add(curdate(),interval -1 day) 
		and oi.BALANCE_TIME <curdate()
	group by stat_time,tu.CHANNEL_NO
)t1 
left join report.t_rpt_channel_discount tc on t1.CHANNEL_NO=tc.CHANNEL_NO
group by t1.stat_time,t1.CHANNEL_NO
on duplicate key update
ft_return_coins = values(ft_return_coins);

insert into t_rpt_third_overview(stat_time,channel_no,bk_bet_users,bk_bet_counts,bk_bet_coins)
select 
t1.stat_time,
t1.CHANNEL_NO,
ceil(t1.bet_users*ifnull(tc.bk_bet_users,1)) bk_bet_users,
ceil(t1.bet_counts*ifnull(tc.bk_bet_counts,1)) bk_bet_counts,
ceil(t1.bet_coins*ifnull(tc.bk_bet_coins,1)) bk_bet_coins
from(
	select 
	date(o.CRT_TIME) stat_time,
	tu.CHANNEL_NO,
	count(distinct o.user_id) bet_users,
	count(1) bet_counts,
	round(ifnull(SUM(t.ITEM_MONEY),0)) bet_coins
	from wwgame_bk.t_ww_order_item o 
	INNER JOIN report.t_trans_user_attr tu ON o.USER_ID = tu.USER_CODE
	inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
	inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
	where t.CRT_TIME>=date_add(curdate(),interval -1 day) 
	and t.CRT_TIME<curdate()
	and t.item_status not in (-5,-10,210)
	and t.COST_TYPE='1001'
	group by stat_time,tu.CHANNEL_NO
)t1 
left join report.t_rpt_channel_discount tc on t1.CHANNEL_NO=tc.CHANNEL_NO
group by t1.stat_time,t1.CHANNEL_NO
on duplicate key update
bk_bet_users = values(bk_bet_users),
bk_bet_counts = values(bk_bet_counts),
bk_bet_coins = values(bk_bet_coins);

insert into t_rpt_third_overview(stat_time,channel_no,bk_return_coins)
select 
t1.stat_time,
t1.CHANNEL_NO,
ceil(t1.return_coins*ifnull(tc.bk_return_coins,1)) bk_return_coins
from (
	select 
	date(o.CRT_TIME) stat_time,
	tu.CHANNEL_NO,
	round(ifnull(SUM(t.PRIZE_MONEY),0)+ifnull(SUM(t.RETURN_MONEY),0)) return_coins
	from wwgame_bk.t_ww_order_item o 
	INNER JOIN report.t_trans_user_attr tu ON o.USER_ID = tu.USER_CODE
	inner join wwgame_bk.t_ww_order_money t on o.ITEM_ID=t.ITEM_ID 
	inner join wwgame_bk.t_ww_item_content tc on o.ITEM_ID=tc.ITEM_ID
	where t.BALANCE_TIME>=date_add(curdate(),interval -1 day) 
	and t.BALANCE_TIME<curdate()
	and t.item_status not in (-5,-10,210)
	and t.COST_TYPE='1001'
	and t.BALANCE_STATUS=20
	group by stat_time,tu.CHANNEL_NO
) t1 
left join report.t_rpt_channel_discount tc on t1.CHANNEL_NO=tc.CHANNEL_NO
group by t1.stat_time,t1.CHANNEL_NO
on duplicate key update
bk_return_coins = values(bk_return_coins);


-- 根据配置更新数据状态

update t_rpt_third_overview op, t_rpt_channel_discount cd 
set op.VISUAL_STATUS = 0 where op.CHANNEL_NO = cd.CHANNEL_NO and op.PERIOD_NAME < cd.BEGIN_TIME and cd.BEGIN_TIME is not null;

update t_rpt_third_overview op, t_rpt_channel_discount cd 
set op.VISUAL_STATUS = 0 where op.CHANNEL_NO = cd.CHANNEL_NO and op.PERIOD_NAME > cd.END_TIME and cd.END_TIME is not null;

update t_rpt_third_overview op, t_rpt_channel_discount cd 
set op.VISUAL_STATUS = 1 where op.CHANNEL_NO = cd.CHANNEL_NO and op.PERIOD_NAME >= date(cd.BEGIN_TIME)
and (op.PERIOD_NAME <= date(cd.END_TIME) or cd.END_TIME is  null);



-- 查询数据

set @begin_time='2017-04-01';
set @end_time='2017-04-06';
set @channel_no='jrtt-jingcai';
select 
stat_time,channel_no,device_num,online_unum,first_dnum,second_dnum,active_dnum,reg_unum,first_buy_unum,first_buy_amount,buy_unum,buy_amount,
first_srv_unum,first_srv_amount,srv_unum,srv_amount,first_bcoin_unum,first_bcoin_amount,buycoin_unum,buycoin_amount,visual_status,
device_pv,device_uv,
diamond_user_cnt,diamond_recharge_sum,
ft_bet_users,ft_bet_counts,ft_bet_coins,ft_return_coins,
bk_bet_users,bk_bet_counts,bk_bet_coins,bk_return_coins
from report.t_rpt_third_overview t
where t.stat_time>=@begin_time
and t.stat_time<@end_time
and t.channel_no in (@channel_no)
group by t.stat_time,t.channel_no;



select t.PERIOD_NAME,t.channel_no,sum(device_num),sum(online_unum),sum(first_dnum),sum(second_dnum),sum(active_dnum),sum(reg_unum) from t_rpt_overview t 
where t.PERIOD_TYPE=1
and t.PERIOD_NAME>='2017-04-01'
and t.PERIOD_NAME<'2017-04-06'
and t.channel_no in ('jrtt-jingcai')
group by t.PERIOD_NAME,t.channel_no;



select * from report.t_rpt_code_name t where t.table_name='整体运营';

select * from t_channel_discount;
select * from t_device_channel_balance;
select * from  t_rpt_channel_discount;














