set @beginTime:='2016-07-12';
set @endTime:='2016-07-19';
set @system_model:='ios';

## 总充值用户 & 总充值金额
select t3.company_name,count(distinct t3.USER_ID) 总充值用户, sum(t3.COST_VALUE) 总充值金额 from (
select hw.company_name, '官充' type_, ai.USER_ID,ai.COST_VALUE  from forum.t_acct_items ai 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model
and ai.add_time >= @beginTime and ai.ADD_TIME < @endTime and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT = 'BUY_DIAMEND'  
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP' 
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um)
and ai.USER_ID not in (select user_id from test.new_user_boss)
union all 
select hw.company_name, '第三方充' type_, t2.receiver, round(sum(t2.sum_in_actual) / 139, 2) from (
select '赏金' type_,receiver, sum_in_actual from (
	## 第三方主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	inner join t_user_merchant um on o.USER_ID = um.user_code
	and oa.USER_ID not in (select user_code from t_user_merchant)
	and oa.USER_ID not in (select user_code from test.new_user_boss)
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
	union all 
	## 第三方被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime 
		 inner join t_user_merchant um on oa.USER_ID = um.user_code
	and o.USER_ID not in (select user_code from t_user_merchant)
	and o.USER_ID not in (select user_code from test.new_user_boss)
	inner join forum.t_user u on o.USER_ID = u.USER_CODE
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
      and tp.TUSER_ID not in (select user_id from test.new_user_boss)
      
   union all
		## 线下网银
	select '线下网银',ai.user_id charge_user_id, ai.change_value as coins
	 from forum.t_acct_items ai where ai.ITEM_EVENT = 'ADMIN_USER_OPT' and ai.COMMENTS like '%网银充值%' and ai.acct_type = 1001 and ai.item_status = 10
	 	and ai.ADD_TIME >= @beginTime  AND ai.ADD_TIME < @endTime
	 	and ai.user_id not in (select um.user_id from t_user_merchant um)
	 	and ai.USER_ID not in (select user_id from test.new_user_boss)
	)t2 inner join t_user_company_group hw on t2.receiver = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by t2.receiver
)t3 
inner join test.t_stat_first_recharge tts on tts.USER_ID = t3.USER_ID and  tts.crt_time>=@beginTime and tts.crt_time<=@endTime
group by t3.company_name;