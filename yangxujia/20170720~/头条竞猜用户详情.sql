

-- 01月1号
set @param0='2017-03-01';
set @param1='2017-08-03';

-- 注册
select '注册用户数',count(1) from forum.t_user_event e 
where e.CRT_TIME>=@param0
and e.CRT_TIME<@param1
and e.EVENT_CODE='reg'
and e.CHANNEL_NO='jrtt-jingcai';




-- 注册
select 'app内注册用户数',count(1) from forum.t_user_event e 
where e.CRT_TIME>=@param0
and e.CRT_TIME<@param1
and e.EVENT_CODE='reg'
and e.CHANNEL_NO='jrtt-jingcai'
and e.DEVICE_CODE is not null;



-- 下载
select '下载用户数',count(1) from forum.t_device_info t 
where t.ADD_TIME>=@param0
and t.ADD_TIME<@param1
and t.REG_CHANNEL='jrtt-jingcai';



-- 免费领取金币
select '免费领取金币用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and tu.CHANNEL_NO='jrtt-jingcai'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='get_free_coin'
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS=10;


-- 免费领取体验币
select '免费领取体验币用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and tu.CHANNEL_NO='jrtt-jingcai'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ITEM_EVENT='get_free_coin'
and ai.ACCT_TYPE=1015
and ai.ITEM_STATUS=10;


-- 金币投注用户
select '金币投注用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID 
and tu.CHANNEL_NO='jrtt-jingcai'
and ai.ITEM_EVENT='trade_coin'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1001
and ai.ITEM_STATUS=10;


-- 体验币投注用户
select '体验币投注用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID 
and tu.CHANNEL_NO='jrtt-jingcai'
and ai.ITEM_EVENT='trade_coin'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1015
and ai.ITEM_STATUS=10;


-- 充值人数（app以及h5）
select '充值用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID 
and tu.CHANNEL_NO='jrtt-jingcai'
and ai.ITEM_EVENT='buy_diamend'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10;


-- 充值人数（app内）
select 'app内充值用户数',count(distinct ai.user_id) from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID 
and tu.CHANNEL_NO='jrtt-jingcai'
and ai.ITEM_EVENT='buy_diamend'
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<@param1
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10
and ai.APP_TYPE='byapp';




