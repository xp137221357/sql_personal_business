set @beginTime='2016-09-01 00:00:00';
set @endTime = '2016-09-30 23:59:59';



/*投注场次*/
-- 总
select 
 count(distinct oi.USER_ID) '总投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;

-- 金币
select 
  count(distinct oi.USER_ID) '金币投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and if(oi.PAY_TIME<'2016-07-05 17:55:09',oi.item_MONEY>0,oi.COIN_BUY_MONEY>0)
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;

-- 体验币
select 
  count(distinct oi.USER_ID) '体验币投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.P_COIN_BUY_MONEY>0
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;
-- 山东总

select 
  count(distinct oi.USER_ID) '山东总投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
 INNER JOIN report.t_trans_user_attr tu ON oi.USER_ID=tu.user_code
 inner join T_USER_SHANGDONG ts ON ts.USER_ID=tu.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;


-- 山东金币

select 
  count(distinct oi.USER_ID) '山东金币投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
 INNER JOIN report.t_trans_user_attr tu ON oi.USER_ID=tu.user_code
 inner join T_USER_SHANGDONG ts ON ts.USER_ID=tu.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and if(oi.PAY_TIME<'2016-07-05 17:55:09',oi.item_MONEY>0,oi.COIN_BUY_MONEY>0)
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;

-- 山东体验币

select 
  count(distinct oi.USER_ID) '山东体验币投注人数',count(1) '订单数',count(distinct oi.BALANCE_MATCH_ID) '投注场次'
 from game.t_order_item oi
 INNER JOIN report.t_trans_user_attr tu ON oi.USER_ID=tu.user_code
 inner join T_USER_SHANGDONG ts ON ts.USER_ID=tu.user_id
where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.P_COIN_BUY_MONEY>0
and oi.PAY_TIME >= @beginTime and oi.PAY_TIME <= @endTime;


-- 山东充值

set @beginTime='2016-06-11 00:00:00';
set @endTime = '2016-07-11 23:59:59';
select 
  count(distinct ttc.charge_user_id) '山东新增充值人数',sum(ttc.coins) '新增充值金币'
 from t_stat_first_recharge_coin tc
 inner join T_USER_SHANGDONG ts ON ts.USER_ID=tc.user_id and tc.CRT_TIME>= @beginTime and  tc.CRT_TIME <= @endTime
 inner join t_trans_user_recharge_coin ttc on ttc.charge_user_id = ts.user_id

