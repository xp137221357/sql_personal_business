select u.NICK_NAME '昵称',u.ACCT_NUM '会员号',tc.charge_method '充值方式',sum(tc.rmb_value) '人民币' 
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on u.USER_ID = tc.charge_user_id
where tc.charge_method !='APP' 
group by tc.charge_user_id,tc.charge_method