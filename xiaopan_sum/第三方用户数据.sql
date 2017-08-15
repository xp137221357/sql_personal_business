-- 这种方案数据量大就不好处理
-- 第一步 --开始
insert into report.t_stat_partner_user(STAT_DATE,REF_ID,CHILD_REF_ID)
select CURDATE(),t.REF_ID,t.REF_ID from game.t_group_ref t
on duplicate key update 
REF_ID = values(REF_ID),
CHILD_REF_ID = values(CHILD_REF_ID);

-- 第二部 -- 循环
insert into report.t_stat_partner_user(STAT_DATE,REF_ID,CHILD_REF_ID)
select CURDATE(),t1.CHILD_REF_ID,t2.REF_ID from report.t_stat_partner_user t1
inner join game.t_group_ref t2 on t1.CHILD_REF_ID=t2.LAST_ID
on duplicate key update 
REF_ID = values(REF_ID),
CHILD_REF_ID = values(CHILD_REF_ID);


-- 第三步 --结束
-- 不再有更新


-- 方案2：

-- 每个人去找他的上一级
-- 知道ref_id=-1(也就是条件ref_id>0)
-- 其中：每个人需要包含自己（增加自己）
-- 只做更新，不重复导入（除非手动）

-- 然后

-- 1.每天凌晨复制前一天的数据
-- 2.通过update_time增量同步
-- 3.计算数据

方法：(可能有点复杂)
1.根据update_time找出改变状态的ref_id
2.根据ref_id找到下面所有的child_ref_id
3.然后找到ref_id的last_id
4.根据last_id找到上层所有的last_id
5.将ref_id下面的child_id赋给上面的last_id


-- 用户添加
E:\data-everyday\temp\xiaopan_sum\t_stat_partner_user.sql


 
-- 判断条件
-- 1.得到所有变动的人
select group_concat(t.REF_ID) childs,count(1) counts from game.t_group_ref t 
where t.UPDATE_TIME>date_add(now(),interval -1 hour)
and t.UPDATE_TIME>(
  select max(t.UPDATE_TIME) from report.t_stat_partner_user t 
);


-- reverse(substring_index( reverse(substring_index(@param0, ',', 1)), ',', 1));

set indexs=1;
where indexs<=counts do

select ref_id 'ref_id',last_id 'last_id',if(t.REF_STATUS=10,if(t.CRT_TIME=t.UPDATE_TIME,1,0),-1) 'is_new_user' from game.t_group_ref t 
where t.UPDATE_TIME>date_add(now(),interval -1 hour)
and t.ref_id


-- 操作
if is_new_user>0  -- 新增
	then 
	insert into report.t_stat_partner_user(stat_date,ref_id_child_ref_id,update_time)
	select curdate(),ref_id,'ref_id' from report.t_stat_partner_user t where t.child_ref_id='last' or t.ref_id='last'
	group by ref_id
	on duplicate key update 
	REF_ID = values(REF_ID),
	CHILD_REF_ID = values(CHILD_REF_ID),
	UPDATE_TIME = values(UPDATE_TIME);
	
else if(is_new_user==-1)  -- 删除

	delete t from report.t_stat_partner_user t
	where t.ref_id in (
		select t.ref_id from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.child_ref_id='ref_id' 
	)
	and t.child_ref_id in (
	
		select t.child_ref_id from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.ref_id='ref_id' 
		union all
		select 'ref_id' child_ref_id from dual
	)
	and t.stat_date=curdate();

else -- 修改
	
	-- 删除
	
	delete t from report.t_stat_partner_user t
	where t.ref_id in (
		select t.ref_id from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.child_ref_id='ref_id' 
	)
	and t.child_ref_id in (
	
		select t.child_ref_id from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.ref_id='ref_id' 
		union all
		select 'ref_id' child_ref_id from dual
	)
	and t.stat_date=curdate();
	
	-- 增加
	insert into report.t_stat_partner_user(stat_date,ref_id_child_ref_id,update_time)
	select curdate(),t.ref_id,t1.child_ref_id,t1.update_time from report.t_stat_partner_user t
	left join (
		select t.child_ref_id,t.update_time from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.ref_id='ref_id' 
		union all
		select t.ref_id child_ref_id,t.update_time from game.t_group_ref t where t.ref_id='ref_id'
	)t1 on 1=1
	where t.ref_id in (
		select t.ref_id from report.t_stat_partner_user t1 where t1.stat_date=curdate() and t1.child_ref_id='last_id' 
		union all
		select 'last_id' ref_id from dual
	)
	and t.stat_date=curdate()
	on duplicate key update 
	REF_ID = values(REF_ID),
	CHILD_REF_ID = values(CHILD_REF_ID),
	UPDATE_TIME = values(UPDATE_TIME);
	
	
































