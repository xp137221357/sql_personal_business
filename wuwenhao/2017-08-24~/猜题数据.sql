


set @param0='2017-05-01';
set @param1='2017-08-23';



select 
tt.send_prize_time,
t.quiz_id '标题号',tt.title '标题',count(distinct t.user_id) '人数',
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
group by t.quiz_id;

select date_format(t.send_prize_time,'%Y-%m') stat_time,t.* from (
select 
tt.send_prize_time,
t.quiz_id '标题号',tt.title '标题',count(distinct t.user_id) '人数',
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
group by t.quiz_id
) t group by stat_time;

-- 月数据
select 
date_format(tt.send_prize_time,'%Y-%m') stat_time,
count(distinct t.user_id) '人数',
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
group by stat_time;



select 
u.NICK_NAME,u.ACCT_NUM,
sum(t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
-t.pcoin_amount1-t.pcoin_amount2-t.pcoin_amount3-t.pcoin_amount4-t.pcoin_amount5-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10
) '投注',
sum(t.earn-t.pcoin_earn) '返奖'  
from h5game.t_fq_info t 
inner join forum.t_user u on t.user_id=u.user_code
inner join h5game.t_fq_quiz tt on t.quiz_id=tt.quiz_id 
where tt.send_prize_time>=@param0
and tt.send_prize_time<@param1
and t.amount1+t.amount2+t.amount3+t.amount4+t.amount5+t.amount6+t.amount7+t.amount8+t.amount9+t.amount10
-t.pcoin_amount6-t.pcoin_amount7-t.pcoin_amount8-t.pcoin_amount9-t.pcoin_amount10>0
and t.state=1
group by t.user_id;





