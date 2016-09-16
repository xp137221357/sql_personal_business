set @beginTime='2016-07-11';
set @endTime = '2016-07-16';

select oi.USER_ID,oi.IS_INPLAY,tm.LEAGUE_LEVEL,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL=1,oi.ITEM_MONEY,0)) first_league_pre_bet,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL!=1,oi.ITEM_MONEY,0)) other_league_pre_bet,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL=1,oi.ITEM_MONEY,0)) first_league_play_bet,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL!=1,oi.ITEM_MONEY,0)) other_league_play_bet,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL=1,oi.PRIZE_MONEY,0)) first_league_pre_return,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL!=1,oi.PRIZE_MONEY,0)) other_league_pre_return,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL=1,oi.PRIZE_MONEY,0)) first_league_play_return,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL!=1,oi.PRIZE_MONEY,0)) other_league_play_return
	from game.t_order_item oi 
	inner join game.t_match_ref tm on oi.BALANCE_MATCH_ID = tm.MATCH_ID 
	where  oi.CHANNEL_CODE = 'game' and oi.ITEM_STATUS not in (-5,-10,210) 
	and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
   GROUP BY oi.USER_ID
   
   
   
SELECT 
COUNT( DISTINCT IF(vs.user_type=21 AND vs.STATUS = 10, vs.user_id,null)) vip1
FROM t_user_vip_srv vs
WHERE vs.pay_status = 10 AND vs.CRT_TIME <= '2016-07-27' AND vs.CRT_TIME >= '2016-01-01';

	
	
	
-- sql比较差异
select * from (
select 
* from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
and ai.ITEM_EVENT in ('COIN_FROM_DIAMEND') 
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 ) a 
left join 
(
SELECT *
FROM t_trans_user_recharge_coin tc
WHERE tc.charge_method='app' 
AND tc.crt_time>=@beginTime 
AND tc.crt_time<=@endTime) b on a.user_id=b.charge_user_id
where b.charge_user_id is null;



-- 分足求和
select 
ts.stat_date,
ifnull(sum(ts.fore_asserts),0)
FROM t_stat_coin_trends ts
WHERE ts.user_group='all' 
and ts.stat_date>=@beginTime
and ts.stat_date<=@endTime
group by stat_date with rollup ;


-- 取反
select count(tf.user_id) from forum.t_user u 
inner join t_stat_user_first_bet_time tf on u.user_id = tf.user_id 
and u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime
and tf.CRT_TIME>=@beginTime and tf.CRT_TIME<=@endTime
left join t_stat_first_recharge tfc on tfc.USER_ID = tf.user_id
and tfc.CRT_TIME>=@beginTime and tfc.CRT_TIME<=@endTime
where tfc.USER_ID is null ;


-- 时间的交错
-- 坚持只有一个变量
SELECT Date_format(ti.add_time, '%Y-%m-%d')
         stat_time,
         ta.system_model
         device_type,
         ta.channel_no,
         Count(DISTINCT ta.user_id)
         new_recharge_count,
         Sum(Ifnull(ti.cost_value, 0))
         cost_value
  FROM   forum.t_acct_items ti
         INNER JOIN forum.t_user tu
                 ON ti.user_id = tu.user_id
                    AND date(tu.crt_time) = date(ti.add_time)
         INNER JOIN t_trans_user_attr ta
                 ON ti.user_id = ta.user_id
  WHERE  ti.item_status = 10
         AND ti.acct_type = 1003
         AND ti.item_event = 'BUY_DIAMEND'
         AND ti.add_time >= @beginTime
         AND ti.add_time < Date_add(@endTime,
                            INTERVAL 7 day)
  GROUP  BY stat_time,
            ta.system_model,
            ta.channel_no
            
            
            
-- 为什么增加子查询会改善计算速度？
-- 1.减少每次计算的数据
-- 2.减少计算次数
-- 3.子查询里面使用group by 先过滤
select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins,
round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
round(sum(oi.COIN_BUY_MONEY))- round(sum(oi.COIN_PRIZE_MONEY)) profit_coins
from game.t_order_item oi -----------

select t.bet_coins,t.return_coins,t.return_coins-t.bet_coins profit_coins from (
select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins,
round(sum(oi.COIN_PRIZE_MONEY)) return_coins
from game.t_order_item oi -----------) t


-- left join + where is null/not null实现多功能 代替 inner join
left join(
SELECT t.charge_user_id,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 1000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 1000
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 4
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 5
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 6
     end                             AS value_type,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID  -- and tt.value_type = 5
left join 
(select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id) tfc on U.USER_ID = tfc.charge_user_id
and tfc.CRT_TIME>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
 and tfc.CRT_TIME<=@endTime
 where tt.charge_user_id is not null
 group by stat_time 
)tt ;


-- 计算时差
SELECT TIMESTAMPDIFF(hour,'2009-9-01','2009-10-01'); 