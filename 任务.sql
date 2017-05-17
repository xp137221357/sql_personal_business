
-- 整理优化t_job表
select * from t_job t where t.sql_excuted like '%add_time%';

select * from t_job t where t.sql_excuted like '%now()%';

-- 将账务表同步到report下