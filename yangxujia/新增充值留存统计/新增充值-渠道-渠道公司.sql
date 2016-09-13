

set @beginTime='2016-06-10 00:00:00';
set @endTime = '2016-07-09 00:00:00';

-- test.v_user_vip
-- select * from test.v_user_boss

## 新增充值- 继续充test值
-- channel_name 
-- 百盈猜球/百赢足球/百盈竞彩大师/百盈足球助手/百盈足球风云/百盈足球大师/百盈足球彩票
-- company_name
-- 今日头条/百度/应用宝/华为/小米/

select '新增充值- 继续充值',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',ch.company_name '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID  and o.USER_ID not in (select user_id from test.v_user_vip)
inner join forum.t_user_event te on te.USER_ID = o.USER_ID and te.EVENT_CODE = 'REG' 
inner join forum.t_device_channel ch on ch.CHANNEL_NO = te.CHANNEL_NO and ch.company_name in ('今日头条','百度','应用宝','华为','小米')
and o.USER_ID not in (select user_id from test.v_user_boss)
and o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),ch.company_name;


## 新增充值金币-继续充值金币
select '新增充值金币-继续充值金币',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',ch.ch.company_name; '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID and o.USER_ID not in (select user_id from test.v_user_vip)
inner join forum.t_user_event te on te.USER_ID = o.USER_ID and te.EVENT_CODE = 'REG' 
inner join forum.t_device_channel ch on ch.CHANNEL_NO = te.CHANNEL_NO and ch.CHANNEL_NAME in ch.company_name in ('今日头条','百度','应用宝','华为','小米')
and o.USER_ID not in (select user_id from test.v_user_boss)
and o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and o.COMMENTS  like '%buy_coin%'
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),ch.company_name;


## 新增充钻石 - 继续充钻石
select '新增充钻石 - 继续充钻石',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',ch.ch.company_name; '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID and o.USER_ID not in (select user_id from test.v_user_vip)
inner join forum.t_user_event te on te.USER_ID = o.USER_ID and te.EVENT_CODE = 'REG'
inner join forum.t_device_channel ch on ch.CHANNEL_NO = te.CHANNEL_NO and ch.CHANNEL_NAME in ch.company_name in ('今日头条','百度','应用宝','华为','小米')
and o.USER_ID not in (select user_id from test.v_user_boss)
and o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and o.COMMENTS  not like '%buy_coin%'
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),ch.company_name;

