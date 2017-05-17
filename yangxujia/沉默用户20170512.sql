
set @param0='2017-04-01';
set @param1='2017-05-01';

select u.NICK_NAME '用户昵称',u.USER_ID '用户ID',u.USER_MOBILE '联系方式',u.ACCT_NUM '会员号' from report.t_trans_user_attr tu 
inner join forum.t_user u on tu.USER_ID=u.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
and tu.CRT_TIME>=@param0
and tu.CRT_TIME<@param1
left join (
select user_id from forum.t_acct_items ai 
where ai.ITEM_STATUS=10
and ai.ITEM_EVENT='buy_diamend'
and ai.ADD_TIME>=@param0
and ai.ADD_TIME<@param1
) t on tu.USER_ID=t.user_id
where t.USER_ID is null
group by u.USER_ID