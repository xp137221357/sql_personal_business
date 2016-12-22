set @param0='2016-12-04 00:00:00';
set @param1 = '2016-12-04 23:59:59';

-- 处理：item = opt--- 派奖异常
-- 0 未处理事件
-- 1 已处理事件
-- 2 已用其他代替处理
-- 3 已知无关事件


-- 未处理其他事件
-- 系统赠送
-- 答题消耗
-- 赠送消耗

-- 有账户没有用户(孙亮)
-- 竞猜重复派奖(阿博)

update tmp_acct_items_1204_xp ai  
INNER JOIN game.t_msg ms ON cast(ms.MSG_ID as char)= ai.TRADE_NO
AND ms.USER_ID=ai.ACCT_ID AND ai.ITEM_EVENT='TRADE_COIN'
and ms.SEND_STATUS=1
set ai.AUDIT_STATUS=1


update tmp_acct_items_1204_xp ai  set ai.AUDIT_STATUS=3 where ai.ITEM_EVENT in ('PRESENT_FROM_USER')



select tx.ITEM_EVENT,tx.COMMENTS from tmp_acct_items_1204_xp tx where tx.AUDIT_STATUS=0 

select * from tmp_acct_items_1204_xp tx 
inner join (
	select tp.TUSER_ID,tp.CRT_TIME from forum.t_user_present tp 
	inner join report.v_user_system v on tp.USER_ID=v.USER_ID 
	where tp.CRT_TIME>=@param0 
	and tp.CRT_TIME<=@param1
	and tp.`STATUS`=10
	group by tp.TUSER_ID
) t on t.TUSER_ID = tx.USER_ID -- and t.CRT_TIME=tx.ADD_TIME
where tx.ITEM_EVENT='CP_PRIZE' and tx.ACCT_TYPE=1001 and tx.ITEM_STATUS=10;



select tx.ORDER_ID,o.ORDER_ID from tmp_acct_items_1204_xp tx
left join game.t_order_item o on tx.ORDER_ID = o.ORDER_ID
and o.CRT_TIME>=@param0
and o.CRT_TIME<=@param1
where tx.AUDIT_STATUS=2
limit 100;


-- 四项未处理
-- ITEM_EVENT='COUPON_TO_PCOIN' AND COMMENTS LIKE '%使用复活券%'
-- ITEM_EVENT='GET_FREE_COIN' AND COMMENTS LIKE '%分享赠送%'
-- ITEM_EVENT='CP_TRADE-REFUND' AND COMMENTS LIKE '%取消赏金答题%'
-- ITEM_EVENT='TRANSFER' AND COMMENTS LIKE '%平帐%'


select tx.ITEM_EVENT,tx.COMMENTS from tmp_acct_items_1204_xp tx where tx.COMMENTS like '%异常%'
