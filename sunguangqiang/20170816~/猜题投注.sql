

create table report.t_stat_first_fq_info20170824
select t.user_id,min(t.create_time) crt_time from h5game.t_fq_info t 
group by t.user_id;

-- 猜题投注
set @param0='2017-05-15';
set @param1='2017-08-21';

select * from (

	select 
	date_format(tt.send_prize_time,'%x-%v') stat_time,
	'总',count(distinct t.quiz_id) '题目数',count(distinct t.user_id) '人数',
	sum(t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
	-t.pcoin_amount1-t.pcoin_amount2-t.pcoin_amount3-t.pcoin_amount4-t.pcoin_amount5-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10
	) '投注',
	sum(t.earn-t.pcoin_earn) '返奖'  
	from h5game.t_fq_info t 
	inner join h5game.t_fq_quiz tt on t.quiz_id=tt.quiz_id 
	where tt.send_prize_time>=@param0
	and tt.send_prize_time<@param1
	and t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
	-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10>0
	and t.state=1
	group by stat_time

) t1 
left join (
	
	select
	'新增', 
	date_format(tt.send_prize_time,'%x-%v') stat_time,
	count(distinct t.quiz_id) '题目数',count(distinct t.user_id) '人数',
	sum(t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
	-t.pcoin_amount1-t.pcoin_amount2-t.pcoin_amount3-t.pcoin_amount4-t.pcoin_amount5-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10
	) '投注',
	sum(t.earn-t.pcoin_earn) '返奖'  
	from h5game.t_fq_info t 
	inner join h5game.t_fq_quiz tt on t.quiz_id=tt.quiz_id 
	inner join report.t_stat_first_fq_info20170824 t1 on t1.user_id=t.user_id and date_format(t1.crt_time,'%x-%v')=date_format(tt.send_prize_time,'%x-%v')
	where tt.send_prize_time>=@param0
	and tt.send_prize_time<@param1
	and t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
	-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10>0
	and t.state=1
	group by stat_time
) t2 on t1.stat_time=t2.stat_time;






