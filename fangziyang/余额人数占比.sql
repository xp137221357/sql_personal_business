


select t.u_1000 '1000金币人数',t.u_all '金币余额大于0总人数', concat(round(t.u_1000*100/t.u_all,2),'%') '1000金币以上人数占比' from (
select count(if(t.after_value>=1000,user_id,null)) u_1000,count(1) u_all 
from t_user_after_value_2017_03_09 t where t.crt_time<'2017-03-09' and t.after_value>0
) t  ;

select t.u_500 '500金币人数',t.u_all '金币余额大于0总人数', concat(round(t.u_500*100/t.u_all,2),'%') '500金币以上人数占比' from (
select count(if(t.after_value>500,user_id,null)) u_500,count(1) u_all 
from t_user_after_value_2017_03_09 t where t.crt_time<'2017-03-09' and t.after_value>0
) t  ;

