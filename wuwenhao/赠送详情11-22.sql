set @beginTime='2016-11-10 00:00:00';
set @endTime = '2016-11-13 23:59:59';

select ts.stat_date stat_time,t1.task_present,t2.invite_present,
t3.activity_present,t4.day_activity,t5.user_return,
t6.system_present,t7.task_obtain
 from t_stat_coin_operate ts 
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_value)) task_present from forum.t_acct_items ai
	where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
	  and ai.ADD_TIME >= @beginTime and ai.ADD_TIME <= @endTime
	  and ai.USER_ID not in (select user_id from report.v_user_system)
	  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
	  and (ai.TRADE_NO like '%BUY_SRV%' or ai.TRADE_NO like '%ADD_NOTE%' or
		  ai.TRADE_NO like '%FOLLOW_CIRCLE%' or
		  ai.TRADE_NO like  'SIGN_%' or ai.TRADE_NO = 'BIND_BIND'
		  or ai.TRADE_NO = 'NEWTASK1000_NEWTASK1000')
	group by stat_time
) t1 on ts.stat_date=t1.stat_time
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_value)) invite_present  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='GET_FREE_COIN' and ai.ITEM_STATUS=10
			  and ai.TRADE_NO like 'USER_GJ-%'
	group by stat_time
) t2 on ts.stat_date=t2.stat_time
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_value)) activity_present  from forum.t_acct_items ai
			where  ai.item_status = 10 and ai.ACCT_TYPE in (1001) and 
			(ai.ITEM_EVENT in ('COIN_PRESENT','BUY_SERVICE_PRESENT','VIP_PRESENT','ACT_PROFIT') or 
			(ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS not like '%网银充值%' ))
			and ai.USER_ID not in (select user_id from report.v_user_system)
			and ai.CHANGE_TYPE=0 and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
	group by stat_time
) t3 on ts.stat_date=t3.stat_time
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_value)) day_activity  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <=  @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='FREE_COIN_TTACT' and ai.ITEM_STATUS=10
	group by stat_time
) t4 on ts.stat_date=t4.stat_time
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_value)) user_return  from forum.t_acct_items ai
			where ai.item_status = 10 and ai.ACCT_TYPE in (1001)
			  and ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
			  and ai.USER_ID not in (select user_id from report.v_user_system)
			  and ai.ITEM_EVENT='USER_GROUP_PRIZE' and ai.ITEM_STATUS=10
	group by stat_time
) t5 on ts.stat_date=t5.stat_time
left join (
   select  date_format(crt_time,'%Y-%m-%d') stat_time,
			ifnull(sum(system_present),0) system_present from (
		    
		   SELECT p.crt_time crt_time,p.money system_present
        	FROM   forum.t_user_present p
         inner join report.v_user_system vs on p.USER_ID = vs.USER_ID
               AND p.`status` = 10
               AND p.crt_time >= @begintime
               AND p.crt_time <= @endtime
               
		   union all 
		   
			select oa.OFFER_APPLY_TIME crt_time,o.OFFER_GRATUITY - o.OFFER_PRIZE system_present
			from game.t_offer_apply oa 
			inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
			inner join report.v_user_system vus on o.USER_ID = vus.USER_CODE and oa.USER_ID != vus.USER_CODE 
			and oa.OFFER_APPLY_TIME >= @begintime and oa.OFFER_APPLY_TIME <= @endtime
			
			union all 

			select oa.OFFER_APPLY_TIME crt_time, o.OFFER_PRIZE - o.OFFER_GRATUITY system_present 
			from game.t_offer_apply oa 
			inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
			inner join report.v_user_system vus on oa.USER_ID = vus.USER_CODE and o.USER_ID != vus.USER_CODE 
			and oa.OFFER_APPLY_TIME >= @begintime and oa.OFFER_APPLY_TIME <= @endtime
	)t where system_present>0 
	group by stat_time
) t6 on ts.stat_date=t6.stat_time
left join (
   select date_format(ai.ADD_TIME,'%Y-%m-%d') stat_time,
	round(sum(ai.change_VALUE)) task_obtain from forum.t_acct_items ai 
	where ai.item_event='USER_TASK' 
	and ai.item_status = 10 
	and ai.USER_ID not in (select user_id from report.v_user_system)
	and ai.ACCT_TYPE in (1001)
	and ai.ADD_TIME >= @begintime  and ai.ADD_TIME <= @endtime
	group by stat_time
) t7 on ts.stat_date=t7.stat_time
where ts.stat_date>=@beginTime and ts.stat_date<=@endTime
order by ts.stat_date asc