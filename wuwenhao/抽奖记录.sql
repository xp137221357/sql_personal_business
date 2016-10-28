

-- select * from t_activity limit 100 


set @param0='2016-10-21';
set @param1='2016-10-22 23:30:00';

-- 商城抽奖-第三期
select date_add(ta.APPLY_TIME,interval 8 hour) '抽奖时间',u.nick_name '昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',ta.COIN '金币',ta.PCOIN '体验币',td.AWARD_NAME '奖品名称' from t_activity_apply ta 
inner join t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join t_user u on ta.USER_ID = u.user_id 
where ta.APPLY_STATUS in (10,20) 
and ta.act_id = 3
and ta.APPLY_TIME>=@param0 and ta.APPLY_TIME<=@param1
order by td.AWARD_MONEY desc;

-- 商城兑换-第三期
select date(ta.APPLY_TIME) '兑奖时间',u.nick_name '昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',ta.COIN '金币',ta.PCOIN '体验币',td.AWARD_NAME '奖品名称' from t_activity_apply ta 
inner join t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join t_user u on ta.USER_ID = u.user_id and u.NICK_NAME='撒旦寂寞' and td.AWARD_NAME='200京东卡'
where ta.APPLY_STATUS in (10,20) 
and ta.act_id in (12)
and ta.APPLY_TIME>=@param0 and ta.APPLY_TIME<=@param1
order by td.AWARD_MONEY desc













