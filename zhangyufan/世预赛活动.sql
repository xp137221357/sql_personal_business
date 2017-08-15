set@param0='2017-06-11';
set@param1='2017-06-13 23:59:59';
-- pvuv
select 'pvuv',date(t.PERIOD_NAME) stat_time,t.CHANNEL_NO,sum(pv) pv,sum(uv) uv from t_rpt_channel_pv_uv t 
where t.CHANNEL_NO in ('jrtttp2','guozu1')
and t.PERIOD_TYPE=1
and t.PERIOD_NAME>=@param0
and t.PERIOD_NAME<=@param1
group by stat_time,t.CHANNEL_NO;

-- 注册人数
select '注册人数',date(tu.CRT_TIME) stat_time,tu.CHANNEL_NO,count(1) from report.t_trans_user_attr tu 
where tu.CHANNEL_NO in ('jrtttp2','guozu1')
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<=@param1
group by stat_time,tu.CHANNEL_NO;

-- 登陆人数
select '登陆人数',date(tu.CRT_TIME) stat_date,tu.CHANNEL_NO,count(distinct tu.user_id) from report.t_trans_user_attr tu 
inner join report.t_stat_user_online t on tu.USER_ID=t.USER_ID
where tu.CHANNEL_NO in ('jrtttp2','guozu1')
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<=@param1
and t.STAT_TIME>=@param0
and t.STAT_TIME<=@param1
group by stat_date,tu.CHANNEL_NO;


-- 参与竞猜人数
select '竞猜',date(ai.PAY_TIME) stat_time,tu.CHANNEL_NO,count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '投注金币数' from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID and tu.CHANNEL_NO in ('jrtttp2','guozu1')
where ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
group by stat_time,tu.CHANNEL_NO;

-- 竞猜返奖人数
select '竞猜返奖',date(ai.PAY_TIME) stat_time,tu.CHANNEL_NO,count(distinct ai.user_id) '中奖人数',sum(ai.CHANGE_VALUE) '返奖金币数' from forum.t_acct_items ai
inner join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID and tu.CHANNEL_NO in ('jrtttp2','guozu1') 
where ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT in ('prize_coin','bk_prize_coin')
group by stat_time,tu.CHANNEL_NO;


-- 留存数据
set@param0='2017-06-13';
set@param1='2017-06-13 23:59:59';
set@param2='2017-06-14';
set@param3='2017-06-14 23:59:59';
set@param4='jrtttp2'; -- 'jrtttp2','guozu1'

select @param0 '日期',@param4,'登陆次日留存',count(t.user_id) '基础人数',count(t1.user_id) '留存人数' from (

	select tu.USER_ID from report.t_trans_user_attr tu 
	inner join report.t_stat_user_online t on tu.USER_ID=t.USER_ID
	where tu.CHANNEL_NO =@param4
	and tu.CRT_TIME>=@param0
	and tu.CRT_TIME<=@param1
	and t.STAT_TIME>=@param0
	and t.STAT_TIME<=@param1

) t 
left join (

	select tu.USER_ID from report.t_trans_user_attr tu 
	inner join report.t_stat_user_online t on tu.USER_ID=t.USER_ID
	where tu.CHANNEL_NO =@param4
	and tu.CRT_TIME>=@param0
	and tu.CRT_TIME<=@param1
	and t.STAT_TIME>=@param2
	and t.STAT_TIME<=@param3

)t1 on t.user_id=t1.user_id;





