


select ai.ITEM_ID,u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',ai.PAY_TIME '充值时间',ai.COST_VALUE '充值金额',ai.CHANGE_VALUE '金币数'
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.ITEM_EVENT='buy_diamend'
and ai.ACCT_TYPE=1003
and ai.ITEM_STATUS=10
and u.ACCT_NUM in (
'13369266',
'11693714',
'13072440',
'11126327',
'12775022',
'13369275',
'13369293',
'12350777',
'12375749'
)
order by ai.USER_ID asc,ai.ADD_TIME asc;


select * from (
select if(ai.COMMENTS like '%underline%','线下充值','官充') 充值方式,u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',ai.PAY_TIME '充值时间',
ai.COST_VALUE '充值金额',
if(ai2.COST_VALUE>0,ai2.COST_VALUE,ai.COST_VALUE*100) '金币数',ai.USER_ID,ai.ADD_TIME
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
inner join forum.t_acct_items ai2 on ai.ITEM_ID=ai2.REF_ITEM_ID
and ai.ITEM_EVENT='buy_diamend' 
and ai.ITEM_STATUS=10
and u.ACCT_NUM in (
'13369266',
'11693714',
'13072440',
'11126327',
'12775022',
'13369275',
'13369293',
'12350777',
'12375749'
)

union all


select '网银充值',u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',ai.PAY_TIME '充值时间',ai.COST_VALUE '充值金额',ai.CHANGE_VALUE '金币数',ai.USER_ID,ai.ADD_TIME
from forum.t_acct_items ai
inner join forum.t_user u on ai.USER_ID=u.USER_ID
and ai.ITEM_EVENT='ADMIN_USER_OPT' and ai.COMMENTS like '%网银%'
and ai.ITEM_STATUS=10
and u.ACCT_NUM in (
'13369266',
'11693714',
'13072440',
'11126327',
'12775022',
'13369275',
'13369293',
'12350777',
'12375749'
)
) t 
order by t.USER_ID asc,t.ADD_TIME asc;



