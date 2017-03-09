-- set param=['2016-12-12 00:00:00','2016-12-18 23:59:59','ACT_LOTTERY'];

set @param0='2016-12-10 00:00:00';
set @param1='2017-12-18 23:59:59';
set @param2='ACT_LOTTERY';

-- ACT_LOTTERY商城抽奖, ACT_REDEEM商城兑奖

select date_format(ta.APPLY_TIME,'%Y-%m-%d %H:%i:%S') '抽奖时间',u.nick_name '昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',ts.ADDRESS '用户地址',ta.COIN '金币',ta.PCOIN '体验币',td.AWARD_NAME '奖品名称',
a.ACT_TITLE
 from
 forum.t_activity_apply ta 
inner join forum.t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join forum.t_user u on ta.USER_ID = u.user_id 
inner join forum.t_activity a on ta.ACT_ID = a.ACT_ID and a.ACT_CODE = @param2
left join forum.t_user_address ts on u.USER_ID=ts.user_id and ts.IS_DEFAULT=1
where ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=@param0 and ta.APPLY_TIME<=@param1
order by td.AWARD_MONEY desc;


