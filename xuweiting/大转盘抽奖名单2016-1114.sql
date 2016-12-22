
set @param0='2016-10-12';
set @param1='2016-10-15 23:59:59';

select date_format(ta.APPLY_TIME,'%Y-%m-%d %H:%i:%S') '日期',
u.NICK_NAME,ta.user_id '用户ID',taa.AWARD_NAME '中奖物品'
from forum.t_activity_apply ta 
inner join forum.t_activity tc on ta.ACT_ID=tc.ACT_ID
inner join forum.t_activity_award taa on ta.AWARD_ID = taa.AWARD_ID
inner join forum.t_user u on u.USER_ID = ta.USER_ID
where 
tc.ACT_CODE='ACT_LOTTERY_OCT' 
and taa.AWARD_NAME in ('100京东卡','500京东卡','iPhone7')
and ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=@param0 
and ta.APPLY_TIME<=@param1
;





