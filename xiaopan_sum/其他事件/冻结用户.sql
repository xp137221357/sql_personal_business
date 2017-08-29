


select count(1) from report.t_stat_partner_user t;



select 
u.NICK_NAME '用户昵称',
u.USER_ID '用户ID',
u.ACCT_NUM '会员号',
u.REALNAME '真实名字',
u.USER_MOBILE '联系方式',
u.CRT_TIME '注册时间',
u.ADDRESS '注册地址',
e.SYSTEM_MODEL '终端类型',
e.DEVICE_CODE '设备号',
e.IP 'ip地址',
e.CHANNEL_NO '渠道编码',
tu.CRT_TIME '冻结时间',
tu.REASON '冻结理由'
 from forum.t_user u 
 inner join forum.t_user_event e on e.USER_ID=u.USER_ID and e.EVENT_CODE='reg'
 left join report.t_user_freeze_log_20170823 tu on u.USER_ID=tu.USER_ID
 where u.STATUS=11;
 
 
 
 
 
 select t.REASON from t_user_freeze_log t 
 group by t.REASON;
 
 
  create table report.t_user_freeze_log_20170823
  select * from (
  select t.USER_ID,t.CRT_TIME,t.REASON from forum.t_user_freeze_log t where t.OPT_TYPE=0
  order by t.CRT_TIME 
  ) t
  group by t.USER_ID
 -- 1: