set @param0='2017-05-15 12:00:00';
set @param1='2017-05-22 11:59:59';


select concat(@param0,'~',@param1) '时间','新用户非官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数' ,sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
left join (
   	SELECT 
	       u.user_id,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 
) tg on tg.user_id=tt.charge_user_id
where tt.charge_user_id not in (select user_id from report.t_user_merchant) 
and tt.charge_user_id not in (select user_id from report.v_user_boss)
and tg.user_id is null 
and tt.charge_method!='app'
group by tt.charge_user_id   
)tt on  tt.crt_time>=@param0 and tt.crt_time<@param1 and tc.charge_method!='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1

union all

select concat(@param0,'~',@param1) '时间','老用户非官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
left join (
   	SELECT 
	       u.user_id,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 
) tg on tg.user_id=tt.charge_user_id
where tt.charge_user_id not in (select user_id from report.t_user_merchant) 
and tt.charge_user_id not in (select user_id from report.v_user_boss)
and tg.user_id is null 
and tt.charge_method!='app'
group by tt.charge_user_id   
)tt on  tt.crt_time<@param0 and tc.charge_method!='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1

union all

select concat(@param0,'~',@param1) '时间','全部用户非官充',count(distinct tc.charge_user_id) '充值人数',sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金额' 
from t_trans_user_recharge_coin tc
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time  from t_trans_user_recharge_coin tt 
left join (
   	SELECT 
	       u.user_id,r1.CRT_TIME
		FROM   forum.t_user u
		INNER JOIN game.t_group_ref r1
		      ON u.user_code = r1.user_id  
		INNER JOIN game.t_group_ref r2
		      ON r1.root_id = r2.ref_id
		INNER JOIN forum.t_user u2
		      ON r2.user_id = u2.user_code
		inner join report.t_partner_group tg on tg.user_id=u2.USER_CODE  and tg.is_valid=0 
		      and u.client_id = 'BYAPP'
		group by u.USER_ID
		
		 union all
	
		select tg.user_id,tg.crt_time from report.t_partner_group tg  where tg.is_valid=0 
) tg on tg.user_id=tt.charge_user_id
where tt.charge_user_id not in (select user_id from report.t_user_merchant) 
and tt.charge_user_id not in (select user_id from report.v_user_boss)
and tg.user_id is null 
and tt.charge_method!='app'
group by tt.charge_user_id   
)tt on  tt.crt_time<@param1 and tc.charge_method!='app'
and tc.charge_user_id = tt.charge_user_id 
where tc.crt_time>=@param0 and tc.crt_time<@param1;



