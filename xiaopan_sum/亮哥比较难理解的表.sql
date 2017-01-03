-- 亮哥表的深入理解

t_acct_items: 里面的change_value表示钻石以及金币的变化，而cost_value是change_value变化时牵涉到的金钱变化，并不是一直是一一对应关系，需要根据具体事件来确定两者的关系；
              其中，after_value已经没有了意义，change_type表示 0是增加，1是减去
t_device_info : 当天设备的及时数据，不能查历史数据，典型的业务表，及时数据;
               每个设备对应一条记录，同一个设备的在一条记录上更新,即是update_time;
t_device_info : 增加了首次激活时候的渠道历史数据,REG_CHANNEL,REG_VERSION,来源t_device_statistic表的处理！add_time表示添加记录的时间,即首次激活时间;
t_device_statistic :每天的静态数据，ctr_time 表示该条记录创建的时间(act_date=date(crt_time))，add_time: 表示首次创建该设备记录的时间，而并不是这条记录创建的时间，创建是由两个时间决定；
t_device_statistic : 增加了首次激活时候的渠道历史数据,REG_CHANNEL,REG_VERSION,作为源始表，便于统计渠道激活数据;
t_rpt_overview: 按日周月为单位统计了大部分的业务数据，针对静态表里面的详细数据，做了一遍统计，主要是不方便去重，并且不能精确到时分秒；
t_user 表中比t_user_event中的reg用户多 1w多的 测试用户
t_user_freeze_log 冻结用户以及冻结原因查询
t_user 与 t_trans_user_attr 表的差异(t_trans_user_attr只有百赢的用户,而且比t_user少后台开的账户)
t_stat_first_recharge以及t_stat_first_recharge_coin 只包括官方充值的数据，不包含第三方的额充值

t_acct_items 免费券的问题
-- 领取
--    item_event='FREE_EXPERT_COUPON' and ai.ACCT_TYPE=103 专家体验券
--    item_event='FREE_RECOM_COUPON' and ai.ACCT_TYPE=104 免费推荐券
-- 使用
-- 	where ai.item_event ='BUY_RECOM' and ai.ACCT_TYPE=103
t_code 罗列了所有的券种类
注:在t_acct_items计算券面额时注意其中的'acct_type'
账务表： v_account_item t  账务余额情况
账务表： t_account_item_snap t 账务变动记录

game.t_order_item 里面的oder_id指的是订单号,item_id表示具体项目 id,pay_time 投注时间,balance_time计算时间
10 初始状态
-5  退款中
-10 已退款
210 退款成功
-100:未中奖
100:结算中 
110:已返奖
120:走盘
130:输一半
140:赢一半

-- 活动列表
FROM forum.t_activity_award td
inner join forum.t_act_award_ref r on r.AWARD_ID=td.AWARD_ID
inner join forum.t_activity taa on r.ACT_ID=taa.ACT_ID
inner join forum.t_activity_apply ta ta.ACT_ID=taa.ACT_ID