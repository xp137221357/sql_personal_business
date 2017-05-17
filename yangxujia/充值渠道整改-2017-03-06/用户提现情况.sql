set @param0='2017-01-01';
set @param1='2017-03-10 23:59:59';

select 
concat(@param0,'~',@param0) '统计时间',
'总' 类型,
count(distinct t.user_id) '总提现人数',
sum(t.coins) '提现金币',
count(distinct tf.user_id) '代理组提现人数',
sum(if(tf.user_id is not null,t.coins,0)) '代理组提现金币'
from report.t_trans_user_withdraw t 
left join(
	SELECT 
	       u.user_id
	FROM   forum.t_user u
	       INNER JOIN game.t_group_ref r1
	               ON u.user_code = r1.user_id
	       INNER JOIN game.t_group_ref r2
	               ON r1.root_id = r2.ref_id
	       INNER JOIN report.t_user_general_agent tu 
	       			ON r2.user_id = tu.user_code
	WHERE  u.client_id = 'BYAPP'
	union 
	select user_id from  report.t_user_general_agent
) tf on t.user_id = tf.user_id
where t.crt_time>=@param0
and  t.crt_time<=@param1

union all

select 
concat(@param0,'~',@param0),
'新增',
count(distinct t.user_id) '新增总提现人数',
sum(t.coins) '新增提现金币',
count(distinct tf.user_id) '新增代理组提现人数',
sum(if(tf.user_id is not null,t.coins,0)) '新增代理组提现金币'
from report.t_trans_user_withdraw t 
inner join (
	select tw.user_id from 
	report.t_trans_user_withdraw tw
	inner join (
		select min(t.sn) sn
		from report.t_trans_user_withdraw t 
		group by t.user_id
	) t on tw.sn=t.sn 
	and tw.crt_time>=@param0
	and tw.crt_time<=@param1
) t1 on t.user_id=t1.user_id
left join(
	SELECT 
	       u.user_id
	FROM   forum.t_user u
	       INNER JOIN game.t_group_ref r1
	               ON u.user_code = r1.user_id
	       INNER JOIN game.t_group_ref r2
	               ON r1.root_id = r2.ref_id
	       INNER JOIN report.t_user_general_agent tu 
	       			ON r2.user_id = tu.user_code
	WHERE  u.client_id = 'BYAPP'
	union 
	select user_id from  report.t_user_general_agent
) tf on t.user_id = tf.user_id
where t.crt_time>=@param0
and  t.crt_time<=@param1;





