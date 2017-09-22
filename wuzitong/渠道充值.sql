    竞彩王者，账号归属 张富，渠道编码 apple_p016
    福利足彩，账号归属 张富，渠道编码 apple_p014
    百盈足球(专业版)，账号归属 陈美伶，渠道编码 apple_p011
    
    麻烦@肖盼@杨旭佳 导出下架马甲包内所有注册用户的信息，按照不同的渠道包分开统计。充值高于500的用户联系方式，电话等单独导出。监测下架后开始导流后的用户存留转移情况。
    
    
    select u.NICK_NAME '用户昵称',u.USER_MOBILE '用户联系方式',u.USER_ID '用户ID',u.ACCT_NUM '会员号',sum(tc.rmb_value) '充值金额',e.CHANNEL_NO '注册渠道' from forum.t_user_event e
    inner join forum.t_user u on e.USER_ID=u.USER_ID and e.CHANNEL_NO in ('apple_p016','apple_p014','apple_p011') and e.EVENT_CODE='reg'
    inner join (
    select tc.charge_user_id,tc.rmb_value from  report.t_trans_user_recharge_coin tc
    union all
    select tc.charge_user_id,tc.rmb_value from  report.t_trans_user_recharge_diamond tc
    ) tc on u.USER_ID=tc.charge_user_id
    group by u.USER_ID



