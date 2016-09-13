set @beginTime0 = '2016-07-17 00:00:00';
set @endTime0 = '2016-07-23 23:59:59';

set @beginTime1 = '2016-07-17 00:00:00';
set @endTime1 = '2016-07-31 23:59:59';

select u.CRT_TIME 用户注册时间,u.NICK_NAME 用户名,u.USER_ID 用户id,t.ADD_TIME 充值时间,t.ITEM_SRC 充值方式,t.cost_VALUE 充值金额 from forum.t_acct_items t
inner join forum.t_user u on u.USER_ID = t.USER_ID and u.CLIENT_ID ='BYAPP' and u.CRT_TIME >= @beginTime0 and  u.CRT_TIME <= @endTime0 
inner join test.t_trans_user_attr ta on ta.USER_ID = t.USER_ID and ta.CHANNEL_NAME='苹果'
where t.ITEM_EVENT = 'BUY_DIAMEND' and t.ITEM_STATUS = 10 and t.ADD_TIME >= @beginTime1 and  t.ADD_TIME <= @endTime1 
order by t.ADD_TIME desc

-- group by t.ADD_TIME


select * from forum.t_acct_items t where t.COST_VALUE>0 limit 1000