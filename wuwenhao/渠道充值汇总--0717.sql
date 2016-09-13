set @beginTime:='2016-06-10';
set @endTime:='2016-07-11';
set @system_model:='IOS';

##新增官方充值用户数与充值金额【华为】
select hw.company_name, hw.SYSTEM_MODEL, count(ai.USER_ID) 新增官充金币用户, sum(ai.COST_VALUE) 新增官充金币金额 from forum.t_acct_items ai 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID
and ITEM_ID in (
select min(ai.ITEM_ID) ITEM_ID from forum.t_acct_items ai 
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP'
where ai.ACCT_TYPE = 1001 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT like '%COIN_FROM_DIAMEND%'  
group by ai.USER_ID 
) and ai.add_time >= @beginTime and ai.ADD_TIME < @endTime 
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um)
and hw.SYSTEM_MODEL = @system_model
group by hw.company_name;


## 新增非官方充值用户
select hw.company_name, count(distinct t2.receiver) 新增非官方充值金币用户, round(sum(t2.sum_in_actual) / 139, 2) 新增非官方充值金币金额 from (
select '赏金' type_,receiver, sum_in_actual from (
	## 币商主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	
	  inner join t_user_merchant um2 on o.USER_ID = um2.user_code
      and oa.USER_ID not in (select um.user_code from t_user_merchant um)
 and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	# 首次充值
	and oa.USER_ID not in (
		select oa.USER_ID from game.t_offer_apply oa 
					inner join game.t_offer o on oa.OFFER_ID = o.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
		 and o.START_TIME < @beginTime
		 inner join t_user_merchant um2 on o.USER_ID = um2.user_code
	)	 
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
		 
		 
	union all 
		 
	## 币商被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
		 	  inner join t_user_merchant um2 on oa.USER_ID = um2.user_code
      and o.USER_ID not in (select um.user_code from t_user_merchant um)
      
      
	# 首次充值
	and o.USER_ID not in (
		select o.USER_ID from game.t_offer_apply oa 
					inner join game.t_offer o on oa.OFFER_ID = o.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1 
		 and o.START_TIME < @beginTime
		 inner join t_user_merchant um2 on oa.USER_ID = um2.user_code
	)
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
      # 首次充值
      and tp.TUSER_ID not in (
		select up.tuser_id from forum.t_user_present up 
                           inner join t_user_merchant um on up.user_id = um.user_id and up.crt_time < @beginTime and up.status = 10
		)
	)t2 inner join t_user_company_group hw on t2.receiver = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by hw.company_name;
	
	
	
## 总充值用户与充值金币金额
select company_name, count(distinct t3.USER_ID) 总新增充值用户数, round(sum(t3.COST_VALUE), 2) 总新增充值金币金额  from (
select hw.company_name, '官充' type_, ai.USER_ID,ai.COST_VALUE  from forum.t_acct_items ai 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model
and ITEM_ID in (
select min(ai.ITEM_ID) ITEM_ID from forum.t_acct_items ai 
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP'
where ai.ACCT_TYPE = 1001 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT like '%COIN_FROM_DIAMEND%'  
group by ai.USER_ID 
) and ai.add_time >= @beginTime and ai.ADD_TIME < @endTime
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um)
union all 

select hw.company_name,  '第三方充' type_, t2.receiver, round(sum(t2.sum_in_actual) / 139, 2) from (
select '赏金' type_,receiver, sum_in_actual from (
	## 币商主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	inner join t_user_merchant um on o.USER_ID = um.user_code
	and oa.USER_ID not in (select user_code from t_user_merchant)
	# 首次充值
	and oa.USER_ID not in (
		select oa.USER_ID from game.t_offer_apply oa 
					inner join game.t_offer o on oa.OFFER_ID = o.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1 
		 inner join t_user_merchant um on o.USER_ID = um.USER_CODE
		 and o.START_TIME < @beginTime
	)	 
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
		 
		 
	union all 
		 
	## 币商被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime 
		 inner join t_user_merchant um on oa.USER_ID = um.user_code
	and o.USER_ID not in (select user_code from t_user_merchant)
	# 首次充值
	and o.USER_ID not in (
		select o.USER_ID from game.t_offer_apply oa 
					inner join game.t_offer o on oa.OFFER_ID = o.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1 
		 inner join t_user_merchant um on oa.USER_ID = um.USER_CODE
		 and o.START_TIME < @beginTime
	)
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
                           
      # 首次充值
      and tp.TUSER_ID not in (
		select up.tuser_id from forum.t_user_present up 
      inner join t_user_merchant um2 on up.user_id = um2.user_id and up.crt_time < @beginTime and up.status = 10 
		)
	)t2 inner join t_user_company_group hw on t2.receiver = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by t2.receiver
)t3 group by t3.company_name;



##新增充值钻石人数 & 新增充值钻石金额
select hw.company_name, count(distinct ai.USER_ID) 新增充值钻石人数, sum(ai.CHANGE_VALUE) 新增充值钻石金额 from forum.t_acct_items ai 
inner join (
select min(ai.ITEM_ID) ITEM_ID from forum.t_acct_items ai 
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP'
where ai.ACCT_TYPE = 1003 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT = 'BUY_DIAMEND' and ai.COMMENTS not like '%buy_coin%'
group by ai.USER_ID 
)t on ai.ITEM_ID = t.ITEM_ID
and ai.ADD_TIME >= @beginTime and ai.ADD_TIME < @endTime 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um) group by hw.company_name
;

##########################################################充值金币用户数   		&& 充值金币金额		###########################################

## 官充用户数 & 官充金额
select hw.company_name, count(distinct ai.USER_ID) 官充金币用户数,round(sum(ai.COST_VALUE) ,2) 官充金币金额  from forum.t_acct_items ai 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model
and ai.add_time >= @beginTime and ai.ADD_TIME < @endTime and ai.ACCT_TYPE = 1001 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT = 'COIN_FROM_DIAMEND'  
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP' 
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um) group by hw.company_name;





## 第三方用户数 & 第三方充值金额
select hw.company_name, count(distinct t2.receiver) 第三方充值金币用户数, round(sum(t2.sum_in_actual) / 139, 2) 第三方充值金币金额 from (
select '赏金' type_,receiver, sum_in_actual from (
	## 币商主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	
	  inner join t_user_merchant um2 on o.USER_ID = um2.user_code
      and oa.USER_ID not in (select um.user_code from t_user_merchant um)
 and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
	union all 
	## 币商被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
		 	  inner join t_user_merchant um2 on oa.USER_ID = um2.user_code
      and o.USER_ID not in (select um.user_code from t_user_merchant um)
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
	)t2 inner join t_user_company_group hw on t2.receiver = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by hw.company_name;
	
	
## 总充值用户 & 总充值金额
select t3.company_name,count(distinct t3.USER_ID) 总充值用户, sum(t3.COST_VALUE) 总充值金额 from (
select hw.company_name, '官充' type_, ai.USER_ID,ai.COST_VALUE  from forum.t_acct_items ai 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model
and ai.add_time >= @beginTime and ai.ADD_TIME < @endTime and ai.ACCT_TYPE = 1001 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT = 'COIN_FROM_DIAMEND'  
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP' 
and ai.USER_ID not in (select um.USER_ID from t_user_merchant um)
union all 
select hw.company_name, '第三方充' type_, t2.receiver, round(sum(t2.sum_in_actual) / 139, 2) from (
select '赏金' type_,receiver, sum_in_actual from (
	## 币商主动给下级用户金币
	select '币商主动给下级用户金币' type_, o.USER_ID sender, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, u.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	inner join t_user_merchant um on o.USER_ID = um.user_code
	and oa.USER_ID not in (select user_code from t_user_merchant)
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
	union all 
	## 币商被动给下级用户金币
	select '币商被动给下级用户金币',oa.USER_ID, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  u.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime 
		 inner join t_user_merchant um on oa.USER_ID = um.user_code
	and o.USER_ID not in (select user_code from t_user_merchant)
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
	)t2 inner join t_user_company_group hw on t2.receiver = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by t2.receiver
)t3 group by t3.company_name;


##  总充值钻石人数 & 总充值钻石金额
select hw.company_name, count(distinct ai.USER_ID) 总充值钻石人数, sum(ai.CHANGE_VALUE) 总充值钻石金额 from forum.t_acct_items ai 
inner join forum.t_user u on ai.user_id = u.user_id and u.CLIENT_ID = 'BYAPP'
and ai.ACCT_TYPE = 1003 and ai.ITEM_STATUS = 10 and ai.ITEM_EVENT = 'BUY_DIAMEND' and ai.COMMENTS not like '%buy_coin%'
and ai.ADD_TIME >= @beginTime and ai.ADD_TIME < @endTime 
inner join t_user_company_group hw on ai.USER_ID = hw.USER_ID and hw.SYSTEM_MODEL = @system_model group by hw.company_name;


##########################################################    流水量返水金额		###########################################
select hw.company_name, round(sum(oi.ITEM_MONEY),2) 投注流水, round(sum(oi.PRIZE_MONEY),2) 返还流水, round(sum(oi.PRIZE_MONEY) / 146,2) 返水金额, count(distinct oi.USER_ID) 投注用户数, count(oi.ORDER_ID) 投注订单数, round(count(oi.ORDER_ID) / count(distinct oi.USER_ID),2) 人均单数, round(sum(oi.ITEM_MONEY) / count(oi.ORDER_ID),2) 订单均额 from game.t_order_item oi 
inner join t_user_company_group hw on oi.USER_ID = hw.USER_CODE  and hw.SYSTEM_MODEL = @system_model
and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime 
and oi.ITEM_STATUS not in (-5, -10) group by hw.company_name;


## 兑出游戏币数
select hw.company_name, count(distinct sender) 兑出游戏币人数, sum(t2.sum_in_actual) 兑出游戏币数, round(sum(t2.sum_in_actual) / 146,2) 兑出游戏币金额 from (
select '赏金' type_,sender, sum_in_actual from (
	## 币商主动给下级用户金币
	select '用户主动给币商金币' type_, u.USER_ID sender, u.NICK_NAME, o.OFFER_PRIZE, o.OFFER_GRATUITY, ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) sum_in_actual, oa.USER_ID receiver, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime
	inner join t_user_merchant um on oa.USER_ID = um.user_code
	and o.USER_ID not in (select user_code from t_user_merchant)
	inner join forum.t_user u on o.USER_ID = u.USER_CODE
	union all 
	## 币商被动给下级用户金币
	select '用户被动给币商金币',u.USER_ID, u.NICK_NAME, o.OFFER_GRATUITY, o.OFFER_PRIZE, ifnull(o.OFFER_PRIZE,0) - ifnull(o.OFFER_GRATUITY,0) sum_in_actual,  o.USER_ID, oa.OFFER_APPLY_TIME from game.t_offer_apply oa 
	inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
	and o.START_TIME >= @beginTime and o.START_TIME < @endTime 
		 inner join t_user_merchant um on o.USER_ID = um.user_code
	and oa.USER_ID not in (select user_code from t_user_merchant)
	inner join forum.t_user u on oa.USER_ID = u.USER_CODE
		)t 
	union all
	
	# 用户赠送
	SELECT 
       '赠送',tp.user_id,
       tp.money
FROM   forum.t_user_present tp
       INNER JOIN forum.t_user u
               ON u.user_id = tp.tuser_id
and  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
      inner join t_user_merchant um2 on tp.TUSER_ID = um2.user_id
      and tp.user_id not in (select um.user_id from t_user_merchant um)
	) t2 inner join t_user_company_group hw on t2.sender = hw.USER_ID  and hw.SYSTEM_MODEL = @system_model group by hw.company_name