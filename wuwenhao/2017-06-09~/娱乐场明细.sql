

set @param0='2017-06-08';
set @param1='2017-06-09';

select 
t.quiz_id '标题号',tt.title '标题',count(distinct t.user_id) '人数',sum(t.amount1+t.amount2+t.amount3+t.amount4) '投注',sum(t.earn) '返奖'  
from h5game.t_fq_info t 
inner join h5game.t_fq_quiz tt on t.quiz_id=tt.quiz_id 
where t.modified_time>=@param0
and t.modified_time<=@param1
and t.amount1+t.amount2+t.amount3+t.amount4-(t.pcoin_amount1+t.pcoin_amount2+t.pcoin_amount3+t.pcoin_amount4)>0
and t.state=1
group by t.quiz_id

union all

select 
'合计','-',count(distinct t.user_id) counts,sum(t.amount1+t.amount2+t.amount3+t.amount4) pays,sum(t.earn) earns  
from h5game.t_fq_info t 
inner join h5game.t_fq_quiz tt on t.quiz_id=tt.quiz_id 
where t.modified_time>=@param0
and t.modified_time<=@param1
and t.amount1+t.amount2+t.amount3+t.amount4-(t.pcoin_amount1+t.pcoin_amount2+t.pcoin_amount3+t.pcoin_amount4)>0
and t.state=1

;