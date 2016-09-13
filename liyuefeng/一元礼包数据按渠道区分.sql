-- 表1：活动用户人数
-- 今日头条、百度、应用宝、华为、小米、苹果
-- 新增激活
set @beginTime='2016-08-23';
set @endTime='2016-08-31 23:59:59';
select t.PERIOD_NAME '日期',sum(t.FIRST_DNUM) '首次激活' 
from report.t_rpt_overview t 
where t.PERIOD_TYPE=1 and t.PERIOD_NAME>=@beginTime 
and t.PERIOD_NAME<= @endTime
group by PERIOD_NAME;


-- 渠道
select date(t.ADD_TIME) '日期',tu.CHANNEL_COMPANY '渠道名',count(distinct t.DEVICE_CODE) '首次激活' 
from report.t_device_statistic t 
inner join report.t_trans_user_attr tu on tu.USER_CODE = t.USER_CODE and tu.CHANNEL_COMPANY in ('今日头条','百度','应用宝','华为','小米','苹果')
where t.ADD_TIME>=@beginTime 
and t.ADD_TIME<= @endTime
group by date(t.ADD_TIME),tu.CHANNEL_COMPANY;


-- 新增注册

select date(u.CRT_TIME)'日期',tu.CHANNEL_COMPANY '渠道名',count(distinct u.user_id) '注册用户数' 
from forum.t_user u 
inner join report.t_trans_user_attr tu on tu.USER_ID = u.USER_ID and tu.CHANNEL_COMPANY in ('今日头条','百度','应用宝','华为','小米','苹果')
where u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
group by date(u.CRT_TIME),tu.CHANNEL_COMPANY ;

-- 购买一元礼包

select date(t.add_time) '日期',tu.CHANNEL_COMPANY '渠道名', count(distinct t.user_id) '充值一元礼包人数',sum(t.cost_value) '充值一元礼包金额' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
inner join report.t_trans_user_attr tu on tu.USER_ID = u.USER_ID and tu.CHANNEL_COMPANY in ('今日头条','百度','应用宝','华为','小米','苹果')
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event='BUY_DIAMEND'
and t.ACCT_TYPE=1003 
and t.comments like '%ACT_YYLB%'
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time),tu.CHANNEL_COMPANY;

-- 充值
select date(t.add_time) '日期', tu.CHANNEL_COMPANY '渠道名',count(distinct t.user_id) '充值人数',sum(t.cost_value) '充值金额' 
from forum.t_acct_items t 
inner join forum.t_user u on t.user_id= u.USER_ID and date(u.CRT_TIME)= date(t.add_time)
inner join report.t_trans_user_attr tu on tu.USER_ID = u.USER_ID and tu.CHANNEL_COMPANY in ('今日头条','百度','应用宝','华为','小米','苹果')
and u.CLIENT_ID='BYAPP'
and u.`STATUS`=10
where t.item_event ='BUY_DIAMEND'
and t.ACCT_TYPE=1003 
and t.item_status=10
and t.add_time >= @beginTime 
and t.add_time<= @endTime
group by date(t.add_time),tu.CHANNEL_COMPANY ;

select date(oi.CRT_TIME) '时间',tu.CHANNEL_COMPANY '渠道名',count(distinct oi.USER_ID) '投注人数',sum(oi.COIN_BUY_MONEY) '投注金币数',sum(oi.P_COIN_BUY_MONEY) '投注体验币数'
from game.t_order_item oi
inner join report.t_trans_user_attr tu on tu.USER_CODE = oi.USER_ID and tu.CHANNEL_COMPANY in ('今日头条','百度','应用宝','华为','小米','苹果')
inner join forum.t_user u on u.USER_CODE=oi.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @beginTime and u.CRT_TIME<= @endTime
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and date(u.CRT_TIME)=date(oi.CRT_TIME )
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
group by date(oi.CRT_TIME ),tu.CHANNEL_COMPANY;