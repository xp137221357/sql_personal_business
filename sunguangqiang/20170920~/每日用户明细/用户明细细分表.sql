

update t_stat_user_daily_balance_0912 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0913 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0914 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0915 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0916 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0917 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0918 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0919 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0920 t set t.user_code=replace(t.user_code,'_','');
update t_stat_user_daily_balance_0921 t set t.user_code=replace(t.user_code,'_','');

select 
u.USER_ID '用户ID',
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
t1.money_before '日前余额',
t1.money_after '日后余额',
ifnull(recharge_coin,0) '充值金币',
ifnull(ft_trade_coin,0)'足球投注',
ifnull(ft_prize_coin,0)'足球返奖',
ifnull(ft_ex_prize_coin,0)'足球异常派奖',
ifnull(bk_trade_coin,0)'篮球投注',
ifnull(bk_prize_coin,0)'篮球返奖',
ifnull(bk_ex_prize_coin,0)'篮球异常派奖',
ifnull(pk_trade_coin,0)'pk场投注',
ifnull(pk_prize_coin,0)'pk场返奖',
ifnull(present_trade_coin,0)'赠送给用户',
ifnull(present_prize_coin,0)'来自用户赠送',
ifnull(cp_trade_coin,0)'悬赏',
ifnull(cp_prize_coin,0)'答题',
ifnull(packet_trade_coin,0)'发红包',
ifnull(packet_prize_coin,0)'接收红包',
ifnull(pk_trade_coin_sys,0)'系统pk场暂扣',
ifnull(pk_prize_coin_sys,0)'系统pk场派奖',
ifnull(broadcast_trade_coin,0)'广播消耗',
ifnull(redeem_coin,0)'金币兑换',
ifnull(diamond_t_coin,0)'钻石兑换金币',
ifnull(act_trade_coin,0)'抽奖消耗',
ifnull(act_prize_coin,0)'抽奖奖励',
ifnull(extra_present_coin,0)'活动额外赠送',
ifnull(service_present_coin,0)'购买服务赠送',
ifnull(vip_present_coin,0)'购买vip赠送',
ifnull(recharge_present_coin,0)'充值赠送',
ifnull(task_reward_coin,0) '新手任务赠送',
ifnull(invite_reward_coin,0) '邀请赠送',
ifnull(activity_present_coin,0) '活动赠送',
ifnull(activity_daily_coin,0) '天天活动赠送',
ifnull(agent_reward_coin,0) '购买赠送',
ifnull(user_task_coin,0) '完成任务赠送',
ifnull(coupon_coin,0) '使用复活券赠送',
ifnull(admin_opt_coin,0) '后台操作',
ifnull(dq_trade_coin,0) '点球投注',
ifnull(dq_prize_coin,0) '点球返奖',
ifnull(lp_trade_coin,0) '轮盘投注',
ifnull(lp_prize_coin,0) '轮盘返奖',
ifnull(tb_trade_coin,0) '投宝投注',
ifnull(tb_prize_coin,0) '投宝返奖',
ifnull(fq_trade_coin,0) '猜猜乐投注',
ifnull(fq_prize_coin,0) '猜猜乐返奖',
ifnull(lpd_trade_coin,0)'幸运24投注',
ifnull(lpd_prize_coin,0)'幸运24返奖',
ifnull(dwsp_trade_coin,0)'动物赛跑投注',
ifnull(dwsp_prize_coin,0)'动物赛跑返奖',
ifnull(nn_trade_coin,0) '牛牛投注',
ifnull(nn_prize_coin,0) '牛牛返奖',
ifnull(nn_bk_trade_coin,0) '牛牛上下庄',
ifnull(singin_prize_coin,0) '签到奖励',
ifnull(admin_prize_coin,0) '游戏后台操作'
from t_acct_items_user_coin_detail t
inner join forum.t_user u on t.user_id=u.USER_ID
inner join report.t_stat_user_daily_balance_0921 t1 on u.user_code=t1.user_code
where t.stat_date='2017-09-21';















