set @param0 = '2016-08-05 00:00:00';
set @param1 = '2016-09-02 23:59:59';

-- 注册

-- set param=['2016-08-31 00:00:00','2016-09-08 23:59:59']; -- 分别填入起始时间，结束时间
select date(u.CRT_TIME) '开始时间',count(u.USER_ID) '注册人数' from forum.t_user u 
where u.CLIENT_ID='BYAPP' 
and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1
-- group by date(u.CRT_TIME)  
;

-- 充值金币
-- 官方+第三方充值
select date(tc.CRT_TIME ) '开始时间',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金额'
from report.t_trans_user_recharge_coin tc
inner join forum.t_user u on u.USER_ID=tc.charge_user_id and u.CLIENT_ID='BYAPP' 
and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and tc.CRT_TIME >= @param0 and tc.CRT_TIME < @param1
-- and date(u.CRT_TIME)=date(tc.CRT_TIME )
-- group by date(tc.CRT_TIME ) 
;

-- 新增注册充值钻石
select date(td.CRT_TIME ) '时间',count(distinct td.charge_user_id) '充值人数',sum(td.diamonds) '充值钻石数',sum(td.rmb_value) '充值金额'
from report.t_trans_user_recharge_diamond td
inner join forum.t_user u on u.USER_ID=td.charge_user_id and u.CLIENT_ID='BYAPP' 
and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and td.CRT_TIME >= @param0 and td.CRT_TIME <= @param1
-- and date(u.CRT_TIME)=date(td.CRT_TIME  )
-- group by date(td.CRT_TIME  ) 
;


-- 投注人数
select date(oi.CRT_TIME) '时间',count(distinct oi.USER_ID) '投注人数',oi.COIN_BUY_MONEY '投注金币数',oi.P_COIN_BUY_MONEY '投注体验币数'
from game.t_order_item oi
inner join forum.t_user u on u.USER_CODE=oi.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and  oi.CHANNEL_CODE = 'GAME' and oi.ITEM_STATUS not in (-5, -10, 210) 
and oi.CRT_TIME >= @param0 and oi.CRT_TIME < @param1
-- and date(u.CRT_TIME)=date(oi.CRT_TIME )
-- group by date(oi.CRT_TIME )
;


-- 购买推荐人数
select date(ai.ADD_TIME) '时间',count(distinct ai.USER_ID) '购买推荐人数',sum(ai.change_value) '使用钻石数'
from forum.t_acct_items ai
inner join forum.t_user u on u.USER_ID=ai.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and ai.ITEM_STATUS =10 AND ai.ITEM_EVENT in ('BUY_RECOM')    -- ('BUY_SERVICE','BUY_RECOM')
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
-- and date(u.CRT_TIME)=date(ai.ADD_TIME )
-- group by date(ai.ADD_TIME)
;

-- 新增注册参与活动
select date(ai.ADD_TIME) '时间',count(distinct ai.USER_ID) '首充活动购买钻石人数',sum(ai.change_value) '首充活动购买钻石数'
from forum.t_acct_items ai
inner join forum.t_user u on u.USER_ID=ai.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
and ai.ITEM_STATUS =10 AND ai.ITEM_EVENT ='DIAMEND_PRESENT'  -- ('BUY_SERVICE','BUY_RECOM')
and ai.COMMENTS not like '%ACT_CODE%'
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
-- and date(u.CRT_TIME)=date(ai.ADD_TIME )
-- group by date(ai.ADD_TIME)
;

-- 总参与活动
select date(ai.ADD_TIME) '时间',count(distinct ai.USER_ID) '首充活动购买钻石人数',sum(ai.change_value) '首充活动购买钻石数'
from forum.t_acct_items ai
-- inner join forum.t_user u on u.USER_ID=ai.USER_ID and u.CLIENT_ID='BYAPP' and u.CRT_TIME>= @param0 and u.CRT_TIME<= @param1 
where ai.ITEM_STATUS =10 AND ai.ITEM_EVENT ='DIAMEND_PRESENT'  -- ('BUY_SERVICE','BUY_RECOM')
and ai.COMMENTS not like '%ACT_CODE%'
and ai.ADD_TIME >= @param0 and ai.ADD_TIME <= @param1
-- and date(u.CRT_TIME)=date(ai.ADD_TIME )
-- group by date(ai.ADD_TIME)
;




