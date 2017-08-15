

select u.NICK_NAME '用户昵称',concat(u.USER_ID,'') '用户ID',u.ACCT_Num '会员号',u.USER_MOBILE '联系方式' from forum.t_user u
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID
and tu.CRT_TIME>='2017-05-01' and tu.CRT_TIME<'2017-06-01' and tu.CHANNEL_NO!='jrtt-jingcai'
left join 
(select  ai.user_id from forum.t_acct_items ai  where ai.PAY_TIME>='2017-05-01'
and ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'
group by ai.user_id
) t on tu.USER_ID=t.USER_ID
where t.user_id is null;