DECLARE temp_ref_id int(11);
DECLARE temp_agent_id int(11);
DECLARE max_agent_id int(11);

set temp_agent_id=1;
select max(t.agent_id) into max_agent_id from report.t_partner_group t;

WHILE temp_agent_id<=max_agent_id DO	

	set temp_ref_id=-1;
	select tr.REF_ID into temp_ref_id
	from report.t_partner_group t
	inner join game.t_group_ref tr on t.user_id=tr.USER_ID
	where t.agent_id=temp_agent_id;
	
	if temp_ref_id>0
	then
		insert t_partner_ref_0809(ref_id,count_root)
		select temp_ref_id,count(1) from game.t_group_ref t where t.ROOT_ID=temp_ref_id
		on duplicate key update 
		count_root = values(count_root);
		
		
		insert t_partner_ref_0809(ref_id,count_func)
		select temp_ref_id,count(1)-1 from game.t_group_ref t 
		where find_in_set(t.REF_ID,(select * from(select func_getAllSonUser(temp_ref_id,-1))t))>0 
		on duplicate key update 
		count_func = values(count_func);
	end if;
	
	set temp_agent_id=temp_agent_id+1;
END WHILE;  

update t_partner_ref_0809 t 
inner join game.t_group_ref t1 on t1.ref_id=t.ref_id 
inner join report.t_partner_group t2 on t1.user_id=t2.user_id
set t.is_vaild=t2.is_valid


select * from t_partner_ref_0809 t where t.count_root!=t.count_func;

select * from game.t_group_ref t where t.REF_ID='418818';


pro_t_partner_ref_0809
truncate t_partner_ref_0809

select * from game.t_group_ref t where t.ROOT_ID='418818';

select * from game.t_group_ref t 
where find_in_set(t.REF_ID,(select * from(select func_getAllSonUser(418818,-1))t))>0;


-- 第一种情况


-- 中途成为总代，未将下面的root_id修改过来
select * from game.t_group_ref t 
where t.LAST_ID in 
(select * from ( select ref_id from game.t_group_ref t where t.root_id=-1) t)
and t.LAST_ID!=root_id;

update game.t_group_ref t 
set t.LAST_ID=t.root_id
where t.LAST_ID in 
(select * from ( select ref_id from game.t_group_ref t where t.root_id=-1) t)
and t.LAST_ID!=root_id;




















