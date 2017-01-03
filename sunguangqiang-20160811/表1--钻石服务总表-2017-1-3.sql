set @param0='2016-10-01';
set @param1 = '2016-10-23 23:59:59';

SELECT 
		'充值钻石人数-金额',
		null value1,
		dw.diamond_user_cnt  value2,
		dw.diamond_recharge_sum value3
FROM   
(SELECT date(@param0)      period_name_d,
             Count(DISTINCT ai.user_id)
             diamond_user_cnt,
             Round(Ifnull(Sum(ai.change_value), 0), 2)
             diamond_recharge_sum
      FROM   forum.t_acct_items ai
      where ai.item_event = 'BUY_DIAMEND'
            AND ai.item_status = 10
            AND ( ai.comments NOT LIKE '%buy_coin%'
                  AND ai.comments NOT LIKE '%underline%'
                )
            and  ai.add_time >= @param0    
            and ai.add_time<= @param1
      ) dw
                  
union all
                  
                  
SELECT '新增充值钻石人数-金额',
			null,
        df.new_recharge_person '新增充值钻石人数',
		  df.first_buy_diamond_sum '新增充值钻石金额'
FROM    
	(SELECT date(ai.add_time)             stat_time_f,
	       Count(DISTINCT ai.user_id)
	                         new_recharge_person,
	       Ifnull(Sum(ai.change_value), 0) first_buy_diamond_sum
	FROM   forum.t_acct_items ai
	       INNER JOIN t_stat_first_recharge_dmd ts
	               ON ai.user_id = ts.user_id
	                  AND ai.item_event = 'BUY_DIAMEND'
	                  AND ai.comments NOT LIKE '%buy_coin%'
	                  AND ai.comments NOT LIKE '%underline%'
	                  and ts.crt_time >= @param0    
				         and ts.crt_time<= @param1
				         and ai.add_time >= @param0    
				         and ai.add_time<= @param1
	                  and ai.item_status=10
   ) df
   
   union all
              
SELECT '购买服务人数-金额',
		null,
		dw.buy_sv_user_cnt '购买服务人数',
		dw.buy_sv_sum '购买服务金额'
FROM   
     (SELECT date(@param0)      period_name_d,
             Count(DISTINCT ai.user_id)
             buy_sv_user_cnt,
             Round(Ifnull(Sum(ai.change_value), 0), 2)
             buy_sv_sum
      FROM   forum.t_acct_items ai
             WHERE ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
             AND ai.item_status = 10
             and ai.change_value>0
             and ai.add_time >= @param0    
             and ai.add_time<= @param1
      ) dw
       
union all

SELECT '新增购买服务人数-金额',
			null,
        df.new_buy_sv_cnt '新增购买服务人数',
		  df.first_buy_sv_sum '新增购买服务金额'
FROM
     (SELECT date(ai.add_time)  stat_time_f,
		       Count(DISTINCT ai.user_id)
		               new_buy_sv_cnt,
	          Ifnull(Sum(ai.change_value), 0) first_buy_sv_sum
	   FROM   forum.t_acct_items ai
	   INNER JOIN t_stat_first_buy_srv ts
	         ON ai.user_id = ts.user_id
	            AND ai.item_event IN ('BUY_SERVICE','BUY_RECOM')
	            and ts.crt_time >= @param0    
		         and ts.crt_time<= @param1
		         and ai.add_time >= @param0    
		         and ai.add_time<= @param1
	            and ai.item_status=10
	   ) df
              
   union all

select '数据分析购买服务人数-金额',
		case tu.SERVICE_id
		    when 2 then '竞猜'
		    when 5 then '平局'
		    when 8 then '亚盘'
		end as '类别',
		count(distinct tu.USER_ID) '购买服务人数',
		sum(tu.MONEY) '购买服务金额' 
from forum.t_user_service tu
inner join forum.t_service ts on ts.SERVICE_id=tu.SERVICE_id and ts.SERVICE_id in (2,5,8)
and tu.`STATUS`=10
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<=@param1 
group by tu.SERVICE_id

union all

SELECT 
		'专家推荐数据人数-金额',
		null,
		Count(DISTINCT t.user_id) AS '购买人数',
		sum(ifnull(t.MONEY,0)) AS '购买金额'
     FROM   forum.t_user_match_recom t
            inner join forum.t_match_recom tm on t.RECOM_ID = tm.RECOM_ID and tm.SINGLE_MONEY>0 
            INNER JOIN forum.t_user o
                    ON t.user_id = o.user_id
                       AND o.group_type IN( 0, 2 )
                       AND o.client_id = 'BYAPP'
WHERE  t.pay_status = 10
and t.crt_time >= @param0
AND t.crt_time<= @param1 ;