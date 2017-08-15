
set @param0='2017-01-01';
set @param1='2017-01-01 23:59:59';
set @param2=1003;

create table t_job20170616
select * from t_job;





-- 充值

INSERT into t_stat_diamond_operate(stat_date,b_official_recharge_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE))),0) b_official_recharge_diamonds 
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('BUY_DIAMEND','ADMIN_OPT_RECHARGE', 'DIAMEND_TO_COIN')
and ai.ACCT_TYPE in (1003)
and ai.item_status in (10,-10) 
on duplicate key update 
b_official_recharge_diamonds = values(b_official_recharge_diamonds);

-- 充值赠送

INSERT into t_stat_diamond_operate(stat_date,b_reward_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(ai.CHANGE_VALUE)),0) b_reward_diamonds 
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('DIAMEND_PRESENT')
and ai.ACCT_TYPE in (1003)
and ai.item_status in (10,-10) 
on duplicate key update 
b_reward_diamonds = values(b_reward_diamonds);


-- 推荐收入

INSERT into t_stat_diamond_operate(stat_date,g_recom_earn_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(ai.CHANGE_VALUE)),0) g_recom_earn_diamonds 
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('RECOM_PRIZE')
and ai.ACCT_TYPE in (1004)
and ai.item_status in (10,-10) 
on duplicate key update 
g_recom_earn_diamonds = values(g_recom_earn_diamonds);



-- 购买金币

INSERT into t_stat_diamond_operate(stat_date,b_buy_coin_diamonds,g_buy_coin_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.ACCT_TYPE=1003,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))),0) b_buy_coin_diamonds,
ifnull(round(sum(if(ai.ACCT_TYPE=1004,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))),0) g_buy_coin_diamonds
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('DIAMEND_T_COIN')
and ai.ACCT_TYPE in (1003,1004)
and ai.item_status in (10,-10) 
on duplicate key update 
b_buy_coin_diamonds = values(b_buy_coin_diamonds),
g_buy_coin_diamonds = values(g_buy_coin_diamonds);

-- 购买服务

INSERT into t_stat_diamond_operate(stat_date,b_buy_service_diamonds,g_buy_service_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.ACCT_TYPE=1003,ai.CHANGE_VALUE,0))),0) b_buy_service_diamonds,
ifnull(round(sum(if(ai.ACCT_TYPE=1004,ai.CHANGE_VALUE,0))),0) g_buy_service_diamonds
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('BUY_SERVICE')
and ai.ACCT_TYPE in (1003,1004)
and ai.item_status in (10,-10) 
on duplicate key update 
b_buy_service_diamonds = values(b_buy_service_diamonds),
g_buy_service_diamonds = values(g_buy_service_diamonds);


-- 购买推荐

INSERT into t_stat_diamond_operate(stat_date,b_buy_recom_diamonds,g_buy_recom_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.ACCT_TYPE=1003,ai.CHANGE_VALUE,0))),0) b_buy_recom_diamonds,
ifnull(round(sum(if(ai.ACCT_TYPE=1004,ai.CHANGE_VALUE,0))),0) g_buy_recom_diamonds
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('BUY_RECOM')
and ai.ACCT_TYPE in (1003,1004)
and ai.item_status in (10,-10) 
on duplicate key update 
b_buy_recom_diamonds = values(b_buy_recom_diamonds),
g_buy_recom_diamonds = values(g_buy_recom_diamonds);


-- 购买vip

INSERT into t_stat_diamond_operate(stat_date,b_buy_vip_diamonds,g_buy_vip_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.ACCT_TYPE=1003,ai.CHANGE_VALUE,0))),0) b_buy_vip_diamonds,
ifnull(round(sum(if(ai.ACCT_TYPE=1004,ai.CHANGE_VALUE,0))),0) g_buy_vip_diamonds
from forum.t_acct_items ai 
where ai.PAY_TIME >= date_add(curdate(),interval -1 day)
and ai.PAY_TIME<= concat(date_add(curdate(),interval -1 day),' 23:59:59')
and ai.ITEM_EVENT in ('BUY_VIP')
and ai.ACCT_TYPE in (1003,1004)
and ai.item_status in (10,-10) 
on duplicate key update 
b_buy_vip_diamonds = values(b_buy_vip_diamonds),
g_buy_vip_diamonds = values(g_buy_vip_diamonds);

-- 系统偏差(金币的交换)
-- 钻石交换

-- 所有事件

INSERT into t_stat_diamond_operate(stat_date,b_all_event_diamonds,g_all_event_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(round(sum(if(ai.ACCT_TYPE=1003,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))),0) b_all_event_diamonds,
ifnull(round(sum(if(ai.ACCT_TYPE=1004,if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE),0))),0) g_all_event_diamonds
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10) 
and ai.item_event !='ADMIN_GROUP_OPT'
and ai.PAY_TIME >= date_add(curdate(),interval -1 day)  
and ai.PAY_TIME <=concat(date_add(curdate(),interval -1 day),' 23:59:59') 
and ai.USER_ID not in (select user_id from report.t_user_system)
on duplicate key update 
b_all_event_diamonds = values(b_all_event_diamonds),
g_all_event_diamonds = values(g_all_event_diamonds);


-- 新增充值，充值
INSERT into t_stat_diamond_operate(stat_date,b_new_recharge_counts,b_new_recharge_diamonds,b_recharge_counts,b_recharge_diamonds)
select 
date_add(curdate(),interval -1 day) stat_date,
ifnull(count(distinct tc.charge_user_id),0) b_new_recharge_counts,
ifnull(sum(ifnull(tc.diamonds,0)),0) b_new_recharge_diamonds,
ifnull(t.b_recharge_counts,0) b_recharge_counts,
ifnull(t.b_recharge_diamonds,0) b_recharge_diamonds
from t_trans_user_recharge_diamond tc 
inner join (
	select tt.charge_user_id,tt.crt_time from (
	select t.charge_user_id,t.crt_time from t_trans_user_recharge_diamond t 
	order by t.crt_time asc) tt
	group by charge_user_id
) tfc on tc.charge_user_id = tfc.charge_user_id 
and tfc.crt_time>=date_add(curdate(),interval -1 day) and tfc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
and tc.crt_time>=date_add(curdate(),interval -1 day) and tc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
left join 
(
	select 
	date_add(curdate(),interval -1 day) stat_date,
	count(distinct tc.charge_user_id) b_recharge_counts,
	sum(ifnull(diamonds,0)) b_recharge_diamonds
	from t_trans_user_recharge_diamond tc 
	where tc.crt_time>=date_add(curdate(),interval -1 day) 
	and tc.crt_time<=concat(date_add(curdate(),interval -1 day),' 23:59:59')
) t on t.stat_date = stat_date
on duplicate key update 
b_new_recharge_counts = values(b_new_recharge_counts),
b_new_recharge_diamonds = values(b_new_recharge_diamonds),
b_recharge_counts = values(b_recharge_counts),
b_recharge_diamonds = values(b_recharge_diamonds);


