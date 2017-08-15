set @param0='2017-05-15';
set @param1='2017-05-19';
-- 金币
select t1.stat_time '时间',t1.counts '点球人数',t1.pays '点球投注',t1.earns '点球返奖',
		 t2.counts '轮盘人数',t2.pays '轮盘投注',t2.earns '轮盘返奖',
		 t3.counts '猜猜乐人数',t3.pays '猜猜乐投注',t3.earns '猜猜乐返奖',
		 t4.counts '欢乐骰人数',t4.pays '欢乐骰投注',t4.earns '欢乐骰返奖'
from (
	select 
	date_format(modified_time,'%Y-%m-%d') stat_time,count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_pk_act t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.pay>0
	and t.`status`=1
	group by stat_time
) t1
left join (
	select
	date_format(modified_time,'%Y-%m-%d') stat_time,count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_roulette_act t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.pay>0
	and t.`status`=1
	group by stat_time
) t2 on t1.stat_time =t2.stat_time
left join (
	select 
	date_format(modified_time,'%Y-%m-%d') stat_time, 
	count(distinct t.user_id) counts,sum(t.amount1)+sum(t.amount2)+sum(t.amount3)+sum(t.amount4) pays,sum(t.earn) earns  
	from h5game.t_fq_info t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.amount1+t.amount2+t.amount3+t.amount4>0
	and t.state=1
	group by stat_time
) t3 on t1.stat_time =t3.stat_time

left join (
	select
	date_format(create_time,'%Y-%m-%d') stat_time,count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_tb_result t 
	where t.create_time>=@param0
	and t.create_time<=@param1
	and t.pay>0
	group by stat_time
) t4 on t1.stat_time =t4.stat_time

union all

select '合计',t1.counts,t1.pays,t1.earns,
		 t2.counts,t2.pays,t2.earns,
		 t3.counts,t3.pays,t3.earns,
		 t4.counts,t4.pays,t4.earns
 from (
	select 
	count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_pk_act t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.pay>0
	and t.`status`=1
) t1
left join (
	select
	count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_roulette_act t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.pay>0
	and t.`status`=1
) t2 on 1=1
left join (
	select 
	count(distinct t.user_id) counts,sum(t.amount1)+sum(t.amount2)+sum(t.amount3)+sum(t.amount4) pays,sum(t.earn) earns  
	from h5game.t_fq_info t 
	where t.modified_time>=@param0
	and t.modified_time<=@param1
	and t.amount1+t.amount2+t.amount3+t.amount4>0
	and t.state=1
) t3 on 1=1
left join (
	select
	count(distinct t.user_id) counts,sum(t.pay) pays,sum(t.earn) earns 
	from h5game.t_tb_result t 
	where t.create_time>=@param0
	and t.create_time<=@param1
	and t.pay>0
) t4 on 1=1;

