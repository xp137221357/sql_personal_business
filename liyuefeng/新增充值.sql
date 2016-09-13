set @param0='2016-08-31 00:00:00';-- //注册起始时间
set @param1='2016-09-01 23:59:59';-- //注册结束时间
set @param2='2016-08-31 00:00:00';-- //充值起始时间
set @param3='2016-09-01 23:59:59';-- //充值结束时间
-- //请将上面的值依次设置到 @param 里面 
-- set @param =['2016-08-31 00:00:00','2016-09-01 23:59:59','2016-08-31 00:00:00','2016-09-01 23:59:59'];
select u.NICK_NAME '昵称',u.USER_ID '用户ID',u.USER_MOBILE,tu.system_model,tu.channel_name,date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%s') '注册时间',date_format(ai.ADD_TIME,'%Y-%m-%d %H:%i:%s') '充值时间',ai.COST_VALUE '充值金额(人民币)' 
from forum.t_user u 
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID and (tu.CHANNEL_NAME like '%苹果%' or tu.CHANNEL_NAME like '%UC%' or tu.CHANNEL_NAME like '%今日头条%' )
inner join forum.t_acct_items ai on u.USER_ID=ai.USER_ID
and ai.ITEM_STATUS = 10 AND ai.ITEM_EVENT = 'BUY_DIAMEND' 
and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and ai.ADD_TIME>= @param2 and ai.ADD_TIME<= @param3 
order by u.CRT_TIME asc;

-- 回帖又充值
select u.NICK_NAME 'user_name',u.USER_ID 'user_id',u.USER_MOBILE,date_format(u.CRT_TIME,'%Y-%m-%d %H:%i:%s') 'reg_time',date_format(ai.ADD_TIME,'%Y-%m-%d %H:%i:%s') 'pay_time',ai.COST_VALUE 'rmb' 
from forum.t_user u 
inner join forum.t_acct_items ai on u.USER_ID=ai.USER_ID
inner join forum.t_circles_note t on t.user_id=u.USER_ID and t.NOTE_STATUS =0 and t.NOTE_TYPE=20 
 inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID and (tu.CHANNEL_NAME like '%苹果%' or tu.CHANNEL_NAME like '%UC%' or tu.CHANNEL_NAME like '%今日头条%' )
and ai.ITEM_STATUS = 10 AND ai.ITEM_EVENT = 'BUY_DIAMEND' 
 and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and ai.ADD_TIME>= @param2 and ai.ADD_TIME<= @param3 
order by u.CRT_TIME asc;

-- 回帖又充值又投注
select @mon,'用户回帖量' ,count(t.USER_ID) '数量' 
from t_circles_note t where t.NOTE_STATUS =0 and t.NOTE_TYPE=20 and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime
