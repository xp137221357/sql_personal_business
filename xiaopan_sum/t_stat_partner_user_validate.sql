


select count(1) from t_stat_partner_user;


select * from t_stat_partner_user t1 
inner join t_stat_partner_user t2 on t1.ref_id=t2.ref_id and t1.child_ref_id=t2.child_ref_id and t1.stat_date=date_add(t2.stat_date,interval 1 day) limit 1;


select * from t_stat_partner_user t where t.ref_id='61010' and t.child_ref_id='146735';



select max(child_ref_id) from (
select * from (
select t.child_ref_id,count(1) times from t_stat_partner_user t

group by child_ref_id
) t where t.times>1
) t;

-- 400707

-- 427332


select max(t.REF_ID) from game.t_group_ref t where t.UPDATE_TIME<curdate();


select * from t_stat_partner_user t where t.child_ref_id='400713';





select * from game.t_group_ref t where t.ref_id='400713';

select * from game.t_group_ref t where t.ref_id='400710'



select * from 

(select root_id from game.t_group_ref t group by t.root_id ) t1
left join 
(select ref_id from game.t_group_ref t where t.ROOT_ID=-1) t2
on t1.root_id=t2.ref_id
where t2.ref_id is null


select ifnull(t.REF_ID,0),ifnull(t.LAST_ID,0) from 
		 (select 1 from dual) t1
		 left join game.t_group_ref t on 1=1 and  t.REF_ID=400713;
		 
		 
		 
select max(ref_id) from game.t_group_ref where update_time<'2017-07-20';




select u.NICK_NAME,tc.* from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on tc.charge_user_id=u.USER_ID
inner join report.t_trans_user_attr tu on u.USER_ID=tu.USER_ID and tu.CHANNEL_NO='jrtt-jingcai'
where tc.crt_time>='2017-07-19'
and tc.crt_time<'2017-07-20'
order by tc.rmb_value desc;



select * from forum.t_acct_items t where t.USER_ID='2645211';

select * from report.t_device_statistic t where t.USER_CODE='5276412407132541093' order by t.UPDATE_TIME desc;

















