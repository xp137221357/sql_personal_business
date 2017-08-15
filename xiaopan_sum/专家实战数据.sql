set @param0 = '2017-03-01'; 
set @param1= '3月份';

-- 专家数据
-- 待刷数据
-- 1
select * from t_expert t where t.IS_EXPERT =1 and t.`STATUS`=10 and t.EXPERT_TIME is not null;

-- 2
select '专家基础数据', @param1,count(distinct ta.USER_ID) '专家人数' from t_expert_apply ta 
where ta.MOD_TIME<date_add(@param0,interval 1 month)
and ta.`STATUS`=10
and ta.APPLY_TYPE=0;

