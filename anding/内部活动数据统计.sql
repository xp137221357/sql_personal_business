set @param0='2016-09-02 17:05:00';  -- 起始时间
set @param1='2016-09-11 23:59:59'; -- 结束时间
-- //请将上面的param值依次设置到 @param 里面 

-- -- 投注情况
-- set @param=['2016-09-02 17:05:00','2016-09-05 17:00:00'];
select 
u.NICK_NAME '昵称', u.ACCT_NUM '会员号', count(distinct if(oi.COIN_BUY_MONEY>0,oi.balance_match_id,null)) '投注场次',count(if(oi.COIN_BUY_MONEY>0,oi.ITEM_ID,null)) '投注次数', sum(oi.COIN_PRIZE_MONEY) - sum(oi.COIN_BUY_MONEY) '盈利'
 from game.t_order_item oi 
inner join forum.t_user u on oi.USER_ID = u.USER_CODE
and u.ACCT_NUM in (
'11404202','12727898','12771800','12790979','11955017',
'11646503','11010071','11010968','11011223','11010068',
'11010077','11118023','11679224','11010569','12869445',
'12655046','11010347','11176682','11681564','11010104',
'11010089','11010059','12675299','12863190','12777662',
'11987321','12869106','11011274','12706949','11017088',
'11017112','12211781','12869238','11010125','12874434'
) and oi.ITEM_STATUS not in (0,10,-5, -10, 210)
and oi.CHANNEL_CODE = 'GAME'
and oi.BALANCE_TIME >= @param0
and oi.BALANCE_TIME <= @param1
group by u.USER_ID order by sum(oi.COIN_PRIZE_MONEY) - sum(oi.COIN_BUY_MONEY) desc;



-- 充值情况

 select NICK_NAME '昵称',ACCT_NUM '会员号',user_id '用户ID',rmb_value '人民币' from (
 SELECT t.charge_user_id user_id,
        NICK_NAME,ACCT_NUM,
        sum(t.rmb_value) rmb_value
 FROM   (SELECT u.NICK_NAME,
                u.ACCT_NUM,
                tc.charge_user_id,
                tc.rmb_value
         FROM   t_trans_user_recharge_coin tc     
			inner join forum.t_user u 
					on tc.charge_user_id = u.USER_ID and tc.crt_time>= @param0 and tc.crt_time<= @param1
					and u.ACCT_NUM in (
					'11404202','12727898','12771800','12790979','11955017',
					'11646503','11010071','11010968','11011223','11010068',
					'11010077','11118023','11679224','11010569','12869445',
					'12655046','11010347','11176682','11681564','11010104',
					'11010089','11010059','12675299','12863190','12777662',
					'11987321','12869106','11011274','12706949','11017088',
					'11017112','12211781','12869238','11010125','12874434'
					)                                      
         UNION ALL
         SELECT u.NICK_NAME,
                u.ACCT_NUM,
			       td.charge_user_id,
                td.rmb_value
         FROM   t_trans_user_recharge_diamond td
         inner join forum.t_user u 
					on td.charge_user_id = u.USER_ID and td.crt_time>= @param0 and td.crt_time<= @param1
					and u.ACCT_NUM in (
					'11404202','12727898','12771800','12790979','11955017',
					'11646503','11010071','11010968','11011223','11010068',
					'11010077','11118023','11679224','11010569','12869445',
					'12655046','11010347','11176682','11681564','11010104',
					'11010089','11010059','12675299','12863190','12777662',
					'11987321','12869106','11011274','12706949','11017088',
					'11017112','12211781','12869238','11010125','12874434'
					) 
         ) t 
 GROUP  BY t.charge_user_id) tt 