set @param0='2017-01-02 00:00:00';
set @param1='2017-02-26 23:59:59';


select '新增专家-购买人数-购买次数-购买金额',
t1.*,t2.counts '人数',t2.times '购买次数',t2.MONEY '金额' from(
	select 
	date_format(ta.MOD_TIME,'%x-%v') stat_time,count(u.USER_ID) new_experts
	from forum.t_user u 
	INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.`STATUS`=10
	INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
	and ta.MOD_TIME>=@param0 and ta.MOD_TIME<=@param1
	where u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	group by stat_time
) t1
left join (
	SELECT 
	date_format(ta.MOD_TIME,'%x-%v') stat_time,
	 COUNT(DISTINCT(tr.USER_ID)) counts,
	 count(tr.RECOM_ID) times,
	 sum(tr.MONEY) MONEY
	FROM forum.T_MATCH_RECOM w 
	INNER JOIN forum.t_user_match_recom tr ON tr.RECOM_ID = w.RECOM_ID and w.single_money>0 and w.RECOM_SRC=0
	and tr.crt_time>=@param0
	and tr.crt_time<=@param1
	inner join forum.t_user u on w.user_id=u.user_id and u.GROUP_TYPE in (0,2) and u.CLIENT_ID='BYAPP'
	INNER JOIN forum.t_expert ter on ter.USER_ID=u.USER_ID and ter.`STATUS`=10
	INNER JOIN forum.t_expert_apply ta on ter.APPLY_ID=ta.APPLY_ID and ta.`STATUS`=10 and ta.APPLY_TYPE=0
	and ta.MOD_TIME>=@param0 and ta.MOD_TIME<=@param1
	group by stat_time
)t2 on t1.stat_time=t2.stat_time







