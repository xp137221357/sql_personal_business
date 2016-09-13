set @beginTime:='2016-06-10';
set @endTime:='2016-07-11';
 set @system_model:='ios';
## 第三方新增用户数 & 第三方新增充值金额


select  hw.company_name,  '第三方充' type_, t2.receiver, round(sum(t2.sum_in_actual) / 139, 2)  from (
select '赏金' type_,receiver, sum_in_actual from (
	## 币商主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u0.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	  inner join t_user_merchant um2 on o.USER_ID = um2.user_code
      and oa.USER_ID not in (select um.user_code from t_user_merchant um)
      and oa.USER_ID not in (select user_code from test.new_user_boss)
      and o.START_TIME >= @beginTime and o.START_TIME < @endTime 
	inner join forum.t_user u0 on oa.USER_ID = u0.USER_CODE 
	union all 
	## 币商被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u2.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
		 	  inner join t_user_merchant um2 on oa.USER_ID = um2.user_code
      and o.USER_ID not in (select um.user_code from t_user_merchant um)
      and o.USER_ID not in (select user_code from test.new_user_boss)
	   inner join forum.t_user u2 on o.USER_ID = u2.USER_CODE 
		)t 
	union all
	# 用户赠送
	SELECT 
       '赠送',tp.tuser_id,
	       tp.money
	FROM   forum.t_user_present tp
	       INNER JOIN forum.t_user u
	               ON u.user_id = tp.tuser_id
	and  tp.status = 10
	       AND tp.crt_time >= @beginTime
	       AND tp.crt_time < @endTime
	      inner join t_user_merchant um2 on tp.user_id = um2.user_id
	      and tp.TUSER_ID not in (select um.user_id from t_user_merchant um)
	      and tp.USER_ID not in (select user_id from test.new_user_boss)
	      inner join forum.t_user u3 on tp.TUSER_ID = u3.USER_id 
      
      	union all
		## 线下网银
	select '线下网银',ai.user_id charge_user_id, ai.change_value as coins
	 from forum.t_acct_items ai
	  inner join forum.t_user u4 on ai.USER_ID = u4.USER_id 
	  where ai.ITEM_EVENT = 'ADMIN_USER_OPT' and ai.COMMENTS like '%网银充值%' and ai.acct_type = 1001 and ai.item_status = 10
	 	and ai.ADD_TIME >= @beginTime  AND ai.ADD_TIME < @endTime
	 	and ai.user_id not in (select um.user_id from t_user_merchant um)
	 	and ai.USER_ID not in (select user_id from test.new_user_boss)
	 	
	)t2 
	inner join forum.t_user u6 on u6.user_id= t2.receiver  and u6.CRT_TIME>=@beginTime and u6.CRT_TIME<=@endTime
	inner join t_user_company_group hw on t2.receiver = hw.USER_ID   and hw.SYSTEM_MODEL = @system_model 
	group by hw.company_name;
	
	
	