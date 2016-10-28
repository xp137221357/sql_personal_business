-- 邹能能下面的用户
-- set @beginTime = '2016-07-01';
-- set @endTime = '2016-07-30';
set @invite_name = '邹能能';
SELECT u.user_id from forum.t_user u
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       inner join forum.t_user u2 on r2.user_id = u2.user_code and u2.nick_name = @invite_name
       
-- WHERE  u.status = 10
--        AND u.crt_time >= @beginTime
--        AND u.crt_time < @endTime

set @beginTime = '2016-07-01 10:00:00';
set @endTime = '2016-07-02 10:00:00';

-- 新增用户
select t1.NICK_NAME '昵称',t1.user_id '用户ID',t1.USER_MOBILE '联系方式',t2.rmb_value '充值金额RMB',
       t3.bet_coins '投注币',t4.return_coins '返还币',if(t3.bet_coins>0,round(t4.return_coins/t3.bet_coins,2),0) '返奖率' 
		 from (
       SELECT u.user_id,u.NICK_NAME,u.USER_MOBILE,u.USER_CODE from forum.t_user u
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       inner join forum.t_user u2 on r2.user_id = u2.user_code and u2.nick_name = @invite_name
       where u.crt_time>= @beginTime and u.crt_time<= @endTime  
) t1
left join (
      SELECT t.charge_user_id user_id,
		     sum(t.rmb_value) rmb_value
		FROM   (SELECT tc.charge_user_id,
             tc.rmb_value
      FROM   t_trans_user_recharge_coin tc where tc.crt_time>= @beginTime and tc.crt_time<= @endTime                                      
      UNION ALL
      SELECT td.charge_user_id,
             td.rmb_value
      FROM   t_trans_user_recharge_diamond td where td.crt_time>= @beginTime and td.crt_time<= @endTime     
      ) t
GROUP  BY t.charge_user_id) t2 on t1.user_id= t2.user_id
left join (
   select 
   oi.user_id,
	round(sum(oi.item_money)) bet_coins
	from game.t_order_item oi
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
	group by oi.user_id
) t3 on t3.user_id= t1.user_code
left join (
   select 
   oi.user_id,
	round(sum(oi.prize_money)) return_coins
	from game.t_order_item oi
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
	group by oi.user_id
) t4 on t4.user_id= t1.user_code



-- 充值用户
select t1.NICK_NAME '昵称',t1.user_id '用户ID',t1.USER_MOBILE '联系方式',t2.rmb_value '充值金额RMB',
       t3.bet_coins '投注币',t4.return_coins '返还币',if(t3.bet_coins>0,round(t4.return_coins/t3.bet_coins,2),0) '返奖率' 
		 from (
       SELECT u.user_id,u.NICK_NAME,u.USER_MOBILE,u.USER_CODE from forum.t_user u
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       inner join forum.t_user u2 on r2.user_id = u2.user_code and u2.nick_name = @invite_name  
) t1
inner join (
      SELECT t.charge_user_id user_id,
		     sum(t.rmb_value) rmb_value
		FROM   (SELECT tc.charge_user_id,
             tc.rmb_value
      FROM   t_trans_user_recharge_coin tc where tc.crt_time>= @beginTime and tc.crt_time<= @endTime                                      
      UNION ALL
      SELECT td.charge_user_id,
             td.rmb_value
      FROM   t_trans_user_recharge_diamond td where td.crt_time>= @beginTime and td.crt_time<= @endTime     
      ) t
GROUP  BY t.charge_user_id) t2 on t1.user_id= t2.user_id
left join (
   select 
   oi.user_id,
	round(sum(oi.item_money)) bet_coins
	from game.t_order_item oi
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
	group by oi.user_id
) t3 on t3.user_id= t1.user_code
left join (
   select 
   oi.user_id,
	round(sum(oi.prize_money)) return_coins
	from game.t_order_item oi
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
	group by oi.user_id
) t4 on t4.user_id= t1.user_code



-- 今日流水
select t1.NICK_NAME '昵称',t1.user_id '用户ID',t1.USER_MOBILE '联系方式',t2.rmb_value '充值金额RMB',
       t3.bet_coins '投注币',t4.return_coins '返还币',if(t3.bet_coins>0,round(t4.return_coins/t3.bet_coins,2),0) '返奖率' 
		 from (
       SELECT u.user_id,u.NICK_NAME,u.USER_MOBILE,u.USER_CODE from forum.t_user u
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       inner join forum.t_user u2 on r2.user_id = u2.user_code and u2.nick_name = @invite_name  
) t1
left join (
      SELECT t.charge_user_id user_id,
		     sum(t.rmb_value) rmb_value
		FROM   (SELECT tc.charge_user_id,
             tc.rmb_value
      FROM   t_trans_user_recharge_coin tc where tc.crt_time>= @beginTime and tc.crt_time<= @endTime                                      
      UNION ALL
      SELECT td.charge_user_id,
             td.rmb_value
      FROM   t_trans_user_recharge_diamond td where td.crt_time>= @beginTime and td.crt_time<= @endTime     
      ) t
GROUP  BY t.charge_user_id) t2 on t1.user_id= t2.user_id
inner join (
   select * from (
	   select 
	   oi.user_id,
		round(sum(oi.item_money)) bet_coins
		from game.t_order_item oi
		where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.PAY_TIME >= @beginTime and oi.PAY_TIME < @endTime
		group by oi.user_id) t order by t.bet_coins desc limit 100
) t3 on t3.user_id= t1.user_code
left join (
   select 
   oi.user_id,
	round(sum(oi.prize_money)) return_coins
	from game.t_order_item oi
	where  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10 ,210) and oi.BALANCE_TIME >= @beginTime and oi.BALANCE_TIME < @endTime
	group by oi.user_id
) t4 on t4.user_id= t1.user_code
order by bet_coins desc
