set @beginTime='2016-06-10 00:00:00';
set @endTime = '2016-07-09 00:00:00';

-- 地推邀请用户

-- 三少爷的剑/球霸天下/88888888/邹能能      
       
                  
                 

select '新增充值- 继续充值',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',t2.nick_name '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID  and o.USER_ID not in (select user_id from test.v_user_vip) and o.USER_ID not in (select user_id from test.v_user_boss)
inner join (select u.user_id,u2.NICK_NAME from forum.t_user_event e
       inner join forum.t_user u
               ON u.user_id = e.user_id
                  AND e.event_code = 'REG'
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id 
       INNER JOIN forum.t_user u2
               ON r2.user_id = u2.user_code
					and u2.NICK_NAME in ('三少爷的剑','球霸天下','88888888','邹能能' )) t2 on t2.user_id = o.user_id
where o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),t2.nick_name;



## 新增充值金币-继续充值金币
select '新增充值金币-继续充值金币',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',t2.nick_name '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID  and o.USER_ID not in (select user_id from test.v_user_vip) and o.USER_ID not in (select user_id from test.v_user_boss)
inner join (select u.user_id,u2.NICK_NAME from forum.t_user_event e
       inner join forum.t_user u
               ON u.user_id = e.user_id
                  AND e.event_code = 'REG'
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id 
       INNER JOIN forum.t_user u2
               ON r2.user_id = u2.user_code
					and u2.NICK_NAME in ('三少爷的剑','球霸天下','88888888','邹能能' )) t2 on t2.user_id = o.user_id
where o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and o.COMMENTS  like '%buy_coin%'
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),t2.nick_name;


## 新增充钻石 - 继续充钻石
select '新增充钻石 - 继续充钻石',concat(@beginTime,'~',@endTime) '时间区间',
date(rb.crt_time) '新增日期', date(o.ADD_TIME) '留存日期', ifnull(count(distinct o.USER_ID),0) '人数',sum(ifnull(o.COST_VALUE,0)) '金额',t2.nick_name '渠道名' FROM test.T_STAT_FIRST_RECHARGE_BET rb
INNER JOIN forum.t_acct_items o ON rb.USER_Id = o.USER_ID  and o.USER_ID not in (select user_id from test.v_user_vip) and o.USER_ID not in (select user_id from test.v_user_boss)
inner join (select u.user_id,u2.NICK_NAME from forum.t_user_event e
       inner join forum.t_user u
               ON u.user_id = e.user_id
                  AND e.event_code = 'REG'
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id 
       INNER JOIN forum.t_user u2
               ON r2.user_id = u2.user_code
					and u2.NICK_NAME in ('三少爷的剑','球霸天下','88888888','邹能能' )) t2 on t2.user_id = o.user_id
where o.ITEM_EVENT = 'BUY_DIAMEND' and o.ITEM_STATUS = 10
and o.COMMENTS  not like '%buy_coin%'
and date(o.ADD_TIME) >= date(rb.crt_time)
and o.ADD_TIME >= @beginTime  and o.ADD_TIME < @endTime
and rb.crt_time >= @beginTime and rb.CRT_TIME < @endTime
group by date(rb.crt_time), date(o.ADD_TIME),t2.nick_name;