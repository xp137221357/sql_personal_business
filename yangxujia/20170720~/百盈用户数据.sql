另外导出一份5~6月份的 
1 首次下载百盈足球app并注册登录过的用户（头条竞猜用户不计入）； 
2 无充值行为（无官方充值行为）；
3 注册时间在05月01日-06月30日 ；



set @param0='2017-05-01';
set @param1='2017-07-01';


select u.USER_ID '用户ID',u.NICK_NAME '用户昵称',u.USER_MOBILE '手机号码',u.ACCT_NUM '会员号',u.CRT_TIME '注册时间',tu.CHANNEL_NO '渠道编码' from forum.t_user u 
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID and tu.CHANNEL_NO!='jrtt-jingcai'
left join report.t_trans_user_recharge_coin tc on tc.charge_user_id=u.USER_ID and tc.crt_time>=@param0
left join report.t_trans_user_recharge_diamond td on td.charge_user_id=u.USER_ID and td.crt_time>=@param0
where tc.charge_user_id is null and td.charge_user_id is null
and u.CRT_TIME>=@param0
and u.CRT_TIME<@param1
group by u.USER_ID;



