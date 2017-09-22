set @param0='2017-09-12';
set @param1='2017-09-12 23:59:59';


-- 账务记录
select ai.ITEM_ID,concat(ai.ACCT_ID,'_'),ai.ACCT_TYPE,ai.CHANGE_VALUE,ai.CHANGE_TYPE,ai.AFTER_VALUE,ai.PAY_TIME,ai.UPDATE_TIME
from FORUM.t_acct_items ai 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1015) 
and ai.ITEM_STATUS in (10,-10)
order by ai.UPDATE_TIME asc;

-- 用户对账（对账事件）
select 
ai.ITEM_EVENT,round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)))
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1015) 
and ai.ITEM_STATUS in (10,-10)
and v.USER_ID is null
group by ai.ITEM_EVENT;


-- 264345216
-- 264322216
-- 对账总数
select 
round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)))
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1015) 
and ai.ITEM_STATUS in (10,-10)
and v.USER_ID is null
;


-- 用户对账（人群）
select * from (
select 
 ai.ACCT_ID,concat(ai.ACCT_ID,'_') ACCT_ID_,round(sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE))) value
from FORUM.t_acct_items ai 
left join report.v_user_system v on v.USER_ID=ai.USER_ID 
where  ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10)
and v.USER_ID is null 
group by ai.ACCT_ID
) t order by t.ACCT_ID asc;


-- 6495104565281317035
-- 用户对账（个人）
SELECT *
FROM FORUM.t_acct_items ai
WHERE ai.ACCT_ID='1123985965957505398' 
AND ai.PAY_TIME>=@param0 
AND ai.PAY_TIME<=@param1
and ai.ACCT_TYPE in (1001) 
and ai.ITEM_STATUS in (10,-10);






