set @param0='2017-07-01';
set @param5='7月份';
set @param4='娱乐场';
set @param3='老用户';
-- set @param1='jrtt-jingcai';
set @param1='';
set @param2='';

select 
@param4 '事件类型',
@param3 '用户属性',
@param5 '时间',

count(distinct t.user_id) '基础用户',

count(distinct t1.user_id) '1月后',

count(distinct t2.user_id) '2月后',

count(distinct t3.user_id) '3月后',

count(distinct t4.user_id) '4月后',

count(distinct t5.user_id) '5月后',

count(distinct t6.user_id) '6月后',

count(distinct t7.user_id) '7月后',

count(distinct t8.user_id) '8月后',

count(distinct t9.user_id) '9月后',

count(distinct t10.user_id) '10月后',

count(distinct t11.user_id) '11月后',

count(distinct t12.user_id) '12月后'

from (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and tu.CRT_TIME<@param0
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=@param0
	and ai.pay_time< date_add(@param0,interval 1 month)
	group by ai.user_id
) t
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
 	where ai.pay_time>=date_add(@param0,interval 1 month)
	and ai.pay_time< date_add(@param0,interval 2 month)
	group by ai.user_id
)t1 on t1.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 2 month)
	and ai.pay_time< date_add(@param0,interval 3 month)
	group by ai.user_id
)t2 on t2.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 3 month)
	and ai.pay_time< date_add(@param0,interval 4 month)
	group by ai.user_id
)t3 on t3.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 4 month)
	and ai.pay_time< date_add(@param0,interval 5 month)
	group by ai.user_id
)t4 on t4.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 5 month)
	and ai.pay_time< date_add(@param0,interval 6 month)
	group by ai.user_id
)t5 on t5.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 6 month)
	and ai.pay_time< date_add(@param0,interval 7 month)
	group by ai.user_id
)t6 on t6.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 7 month)
	and ai.pay_time< date_add(@param0,interval 8 month)
	group by ai.user_id
)t7 on t7.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 8 month)
	and ai.pay_time< date_add(@param0,interval 9 month)
	group by ai.user_id
)t8 on t8.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 9 month)
	and ai.pay_time< date_add(@param0,interval 10 month)
	group by ai.user_id
)t9 on t9.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 10 month)
	and ai.pay_time< date_add(@param0,interval 11 month)
	group by ai.user_id
)t10 on t10.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 11 month)
	and ai.pay_time< date_add(@param0,interval 12 month)
	group by ai.user_id
)t11 on t11.user_id=t.user_id
left join (
	select ai.user_id from forum.t_acct_items ai
	inner join report.t_trans_user_attr tu on ai.user_id=tu.USER_ID and if(@param1='',1=1,tu.CHANNEL_NO=@param1) 
	and ai.ACCT_TYPE=1001
	and ai.ITEM_STATUS=10
	and ai.ITEM_EVENT in ('dq_trade','lp_trade','tb_trade','fq_trade')
	where ai.pay_time>=date_add(@param0,interval 12 month)
	and ai.pay_time< date_add(@param0,interval 13 month)
	group by ai.user_id
)t12 on t12.user_id=t.user_id

