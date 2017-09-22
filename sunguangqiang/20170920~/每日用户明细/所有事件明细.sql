BEGIN


set @param0 = '2017-09-12';

label1: WHILE @param0 <='2017-09-21' Do
	
INSERT into t_acct_items_user_coin_detail(stat_date,user_id,recharge_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) recharge_coin
from forum.t_acct_items ai 
where ai.PAY_TIME >= @param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ITEM_EVENT in ('ADMIN_OPT_RECHARGE', 'COIN_FROM_DIAMEND')
and ai.ACCT_TYPE =1001
and ai.item_status in (10,-10,100) 
group by ai.user_id
on duplicate key update 
recharge_coin = values(recharge_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,task_reward_coin)
select  
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) task_reward_coin   
from forum.t_acct_items ai
where ai.item_status in (10,-10,100)
  and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0 and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
	  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
	  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
	  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000'  or ai.trade_no like '%EVENT_SHARE%' )
group by ai.user_id
on duplicate key update 
task_reward_coin = values(task_reward_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,invite_reward_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) invite_reward_coin
from forum.t_acct_items ai
where ai.item_status in (10,-10,100)
  and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0  and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='GET_FREE_COIN'
  and ai.TRADE_NO like 'USER_GJ-%' 
 group by ai.user_id
on duplicate key update 
invite_reward_coin = values(invite_reward_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,extra_present_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) extra_present_coin  
from forum.t_acct_items ai
where  ai.item_status in (10,-10,100) 
   and ai.ACCT_TYPE =1001
   and ai.ITEM_EVENT in ('COIN_PRESENT')
	and ai.CHANGE_TYPE=0 
	and ai.PAY_TIME >= @param0  
	and ai.PAY_TIME <date_add(@param0,interval 1 day)
group by ai.user_id
on duplicate key update 
extra_present_coin = values(extra_present_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,service_present_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) service_present_coin  
from forum.t_acct_items ai
where  ai.item_status in (10,-10,100) 
   and ai.ACCT_TYPE =1001
   and ai.ITEM_EVENT in ('BUY_SERVICE_PRESENT')
	and ai.CHANGE_TYPE=0 
	and ai.PAY_TIME >= @param0  
	and ai.PAY_TIME <date_add(@param0,interval 1 day)
group by ai.user_id
on duplicate key update 
service_present_coin = values(service_present_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,vip_present_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) vip_present_coin  
from forum.t_acct_items ai
where  ai.item_status in (10,-10,100) 
   and ai.ACCT_TYPE =1001
   and ai.ITEM_EVENT in ('VIP_PRESENT')
	and ai.CHANGE_TYPE=0 
	and ai.PAY_TIME >= @param0  
	and ai.PAY_TIME <date_add(@param0,interval 1 day)
group by ai.user_id
on duplicate key update 
vip_present_coin = values(vip_present_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,recharge_present_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) recharge_present_coin  
from forum.t_acct_items ai
where  ai.item_status in (10,-10,100) 
   and ai.ACCT_TYPE =1001
   and ai.ITEM_EVENT in ('ACT_PROFIT')
	and ai.CHANGE_TYPE=0 
	and ai.PAY_TIME >= @param0  
	and ai.PAY_TIME <date_add(@param0,interval 1 day)
group by ai.user_id
on duplicate key update 
recharge_present_coin = values(recharge_present_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,act_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) act_trade_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) AND ai.ITEM_EVENT in ('BUY_ACT_TIMES') 
and ai.PAY_TIME >= @param0   
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
act_trade_coin = values(act_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,act_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) act_prize_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) AND ai.ITEM_EVENT in ('ACT_PRIZE') 
and ai.PAY_TIME >= @param0   
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
act_prize_coin = values(act_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,activity_daily_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) activity_daily_coin 
from forum.t_acct_items ai
where ai.item_status in (10,-10,100) 
  and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0  
  and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='FREE_COIN_TTACT'
group by ai.user_id
on duplicate key update 
activity_daily_coin = values(activity_daily_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,agent_reward_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) agent_reward_coin
from forum.t_acct_items ai
where ai.item_status in (10,-10,100) 
  and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0 
  and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='USER_GROUP_PRIZE'
group by ai.user_id
on duplicate key update 
agent_reward_coin = values(agent_reward_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,user_task_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) user_task_coin
from forum.t_acct_items ai
where ai.item_status in (10,-10,100)
  and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0  
  and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='USER_TASK'
group by ai.user_id
on duplicate key update 
user_task_coin = values(user_task_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,admin_opt_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) admin_opt_coin
from forum.t_acct_items ai
where  ai.item_status in (10,-10,100)
			and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT like 'ADMIN_OPT_%' 
and ai.PAY_TIME >= @param0 
and ai.PAY_TIME <date_add(@param0,interval 1 day)
group by ai.user_id
on duplicate key update 
admin_opt_coin = values(admin_opt_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,coupon_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) coupon_coin
from forum.t_acct_items ai
where ai.item_status in (10,-10,100)
 and ai.ACCT_TYPE =1001
  and ai.PAY_TIME >= @param0  
  and ai.PAY_TIME <date_add(@param0,interval 1 day)
  and ai.ITEM_EVENT='COUPON_TO_PCOIN'
  and ai.COMMENTS LIKE '%使用复活券%'
group by ai.user_id
on duplicate key update 
coupon_coin = values(coupon_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,dq_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) dq_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('dq_trade')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
dq_trade_coin = values(dq_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,lp_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) lp_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('lp_trade')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
lp_trade_coin = values(lp_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,tb_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) tb_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('TB_CANCEL','TB_TRADE')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
tb_trade_coin = values(tb_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,fq_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) fq_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('FQ_TRADE','FQ_RETURN')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
fq_trade_coin = values(fq_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,lpd_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) lpd_trade_coin 
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('LPD_CANCEL','LPD_TRADE')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
lpd_trade_coin = values(lpd_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,dwsp_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) dwsp_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('DWSP_CANCEL','DWSP_TRADE')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
dwsp_trade_coin = values(dwsp_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,nn_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) nn_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('NN_CANCEL','NN_TRADE','NN_UNFREEZE')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
nn_trade_coin = values(nn_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,nn_bk_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) nn_bk_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('NN_BANKER','NN_LEAVE','NN_RANK')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
nn_bk_trade_coin = values(nn_bk_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,dq_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) dq_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('dq_prize')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
dq_prize_coin = values(dq_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,lp_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) lp_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('lp_prize')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
lp_prize_coin = values(lp_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,tb_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) tb_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('TB_BINGO')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
tb_prize_coin = values(tb_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,fq_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) fq_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('FQ_PRIZE')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
fq_prize_coin = values(fq_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,lpd_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) lpd_prize_coin 
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('LPD_BINGO')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
lpd_prize_coin = values(lpd_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,singin_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) singin_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('SIGNIN_BONUS','SIGNIN_PRIZE','SIGNIN_LOTTO')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
singin_prize_coin = values(singin_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,admin_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) admin_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('ADMIN_OPT_H5GAME')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
admin_prize_coin = values(admin_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,dwsp_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) dwsp_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('DWSP_BINGO')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
dwsp_prize_coin = values(dwsp_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,nn_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) nn_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001 
and ai.ITEM_EVENT in ('NN_BINGO')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
nn_prize_coin = values(nn_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,ft_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) ft_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('trade_coin')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
ft_trade_coin = values(ft_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,bk_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) bk_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('bk_trade_coin')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
bk_trade_coin = values(bk_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,pk_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) pk_trade_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('PK_TRADE_COIN_USER','RE_ROOM_MONEY')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
pk_trade_coin = values(pk_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,ft_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) ft_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('prize_coin')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
ft_prize_coin = values(ft_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,bk_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) bk_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('bk_prize_coin')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
bk_prize_coin = values(bk_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,pk_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) pk_prize_coin
from forum.t_acct_items ai
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_EVENT in ('PK_PRIZE_COIN_USER')
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
pk_prize_coin = values(pk_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,ft_ex_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) ft_ex_prize_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) 
AND ai.ITEM_EVENT in ('EX_PRIZE_COIN')
and ai.PAY_TIME >= @param0  
and ai.PAY_TIME <date_add(@param0,interval 1 day) 
and ai.ACCT_TYPE=1001
group by ai.user_id
on duplicate key update 
ft_ex_prize_coin = values(ft_ex_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,bk_ex_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) bk_ex_prize_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) 
AND ai.ITEM_EVENT in ('BK_EX_PRIZE_COIN')
and ai.PAY_TIME >= @param0  
and ai.PAY_TIME <date_add(@param0,interval 1 day) 
and ai.ACCT_TYPE=1001
group by ai.user_id
on duplicate key update 
bk_ex_prize_coin = values(bk_ex_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,present_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) present_trade_coin
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('USER_PRESENT') 
AND ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
present_trade_coin = values(present_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,cp_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) cp_trade_coin
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('CP_TRADE','CP_TRADE-REFUND') 
AND ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
cp_trade_coin = values(cp_trade_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,packet_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) packet_trade_coin
from forum.t_acct_items ai 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS in(10,-10,100)
and ai.ITEM_EVENT in ('PCKET_EXPIRE','ROOM_PACKET_TRADE')
group by ai.user_id
on duplicate key update 
packet_trade_coin = values(packet_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,pk_trade_coin_sys)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) pk_trade_coin_sys
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('PK_TRADE_COIN_SYS') 
AND ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
pk_trade_coin_sys = values(pk_trade_coin_sys);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,present_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) present_prize_coin
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('PRESENT_FROM_USER') 
and ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_STATUS in (10,-10,100)
group by ai.user_id
on duplicate key update 
present_prize_coin = values(present_prize_coin);

INSERT into t_acct_items_user_coin_detail(stat_date,user_id,cp_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) cp_prize_coin
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('CP_PRIZE') 
AND ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
cp_prize_coin = values(cp_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,packet_prize_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) packet_prize_coin
from forum.t_acct_items ai 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
and ai.ITEM_STATUS in(10,-10,100)
and ai.ITEM_EVENT in ('PACKET_RECIVE')	
group by ai.user_id
on duplicate key update 
packet_prize_coin = values(packet_prize_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,pk_prize_coin_sys)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) pk_prize_coin_sys
from forum.t_acct_items ai 
where ai.ITEM_EVENT in ('PK_PRIZE_COIN_SYS') 
AND ai.PAY_TIME >= @param0
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
pk_prize_coin_sys = values(pk_prize_coin_sys);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,broadcast_trade_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) broadcast_trade_coin
FROM forum.t_acct_items ai 
where ai.PAY_TIME >= @param0   
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ITEM_STATUS in (10,-10,100)
and ai.ACCT_TYPE =1001
AND ai.ITEM_EVENT='BROADCAST_COIN'
group by ai.user_id
on duplicate key update 
broadcast_trade_coin = values(broadcast_trade_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,redeem_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) redeem_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) AND ai.ITEM_EVENT in ('COIN_REDEEM') 
and ai.PAY_TIME >= @param0   
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
redeem_coin = values(redeem_coin);


INSERT into t_acct_items_user_coin_detail(stat_date,user_id,diamond_t_coin)
select 
@param0 stat_date,
ai.user_id,
sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) diamond_t_coin
from forum.t_acct_items ai
where  ai.ITEM_STATUS in (10,-10,100) 
AND ai.ITEM_EVENT in ('COIN_F_DIAMEND') 
and ai.PAY_TIME >= @param0   
and ai.PAY_TIME <date_add(@param0,interval 1 day)
and ai.ACCT_TYPE =1001
group by ai.user_id
on duplicate key update 
diamond_t_coin = values(diamond_t_coin);


SET @param0 = date_add(@param0,interval 1 day);
end while label1;

end