

-- 1月；
set @param0='2017-05-01';
set @param1='2017-06-01';
set @param2='5月数据';

update t_group_partner20170607 t set t.task_coins=0;

call pro_t_group_partner20170607(@param0,@param1);

select @param2 '时间',count(1) '人数',sum(t.task_coins) '金币数' from t_group_partner20170607 t where t.task_coins>0;











