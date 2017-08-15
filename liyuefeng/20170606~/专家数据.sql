set @param0 = '2017-05-01'; 
set  @param1 = '5月份';

-- 专家数据
-- 待刷数据
-- select * from t_expert t where t.IS_EXPERT =1 and t.`STATUS`=10 and t.EXPERT_TIME is not null;


select '专家基础数据',  @param1 '时间',count(distinct ta.USER_ID) '专家人数','-' 金额 from t_expert_apply ta 
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0

union all


select '专家官充数据',  @param1 '时间',count(distinct ta.USER_ID) '官充人数',sum(ai.CHANGE_VALUE) '官充金额' from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'
and ai.ACCT_TYPE=1003
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0

union all

select '专家投注数据',  @param1 '时间',count(distinct ta.USER_ID) '投注人数',sum(ai.CHANGE_VALUE) '投注金额' from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
and ai.ACCT_TYPE=1001
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0

union all


select '专家兑换钻石数据',  @param1 '时间',count(distinct ta.USER_ID) '兑换人数',sum(ai.CHANGE_VALUE) '兑换钻石数' from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT ='diamend_t_coin'
and ai.ACCT_TYPE=1003
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0;






select '专家推荐获得钻石数据',  @param1 '时间',u.NICK_NAME,ai.USER_ID,round(sum(ai.CHANGE_VALUE)) '获得钻石数'  from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT ='RECOM_PRIZE'
and ai.ACCT_TYPE=1004
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0
group by ai.USER_ID;



select '专家消耗钻石数据(非提现)',  @param1 '时间',u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.REALNAME '真实姓名',round(sum(ai.CHANGE_VALUE)) '消耗钻石数'  from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
and ai.ITEM_EVENT not in ('WITHDRAW','RECOM_PRIZE-REFUND')
and ai.CHANGE_TYPE=1
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0
group by ai.USER_ID;


select '专家消耗钻石数据(非提现)',  @param1 '时间',u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.REALNAME '真实姓名',round(sum(ai.CHANGE_VALUE)) '消耗钻石数'  from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
and ai.ITEM_EVENT in ('DIAMEND_T_COIN', 'BUY_RECOM','BUY_VIP','BUY_SERVICE')
and ai.CHANGE_TYPE=1
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0
group by ai.USER_ID;



-- 余额数
select * from (
select '专家收入钻石余额',  @param1 '时间',u.USER_ID,u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.REALNAME '真实姓名',round(ai.AFTER_VALUE) '钻石余额数'  
from t_expert_apply ta 
inner join forum.t_acct_items ai on ta.USER_ID=ai.USER_ID
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1004
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0
order by ai.PAY_TIME desc
) t
group by t.USER_ID;


