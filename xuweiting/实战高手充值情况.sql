-- 实战高手充值详情

select t1.*,t2.AFTER_VALUE '体验币余额' from (
	select u.NICK_NAME '用户名',u.USER_ID,sum(tc.coins) '充值金币数',sum(tc.rmb_value) '充值金币金额',ai.AFTER_VALUE '金币余额' from (
		select t.*,max(ai.ADD_TIME) add_time from (
			select user_id from  forum.t_expert ter 
			where  ter.IS_COMBAT=1 and ter.`STATUS`=10
			group by user_id	
		) t 
		left join forum.t_acct_items ai on ai.USER_ID=t.user_id and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001
		group by t.user_id
	) tt
	left join forum.t_acct_items ai on ai.USER_ID=tt.user_id and ai.ADD_TIME=tt.ADD_TIME and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1001
	inner join forum.t_user u on tt.USER_ID=u.USER_ID
	left  join report.t_trans_user_recharge_coin tc on tc.charge_user_id=tt.USER_ID
	group by tt.user_id
)t1 
left join (
	select tt.user_id,ai.AFTER_VALUE from (
		select t.*,max(ai.ADD_TIME) add_time from (
				select user_id from 
				forum.t_expert ter 
				where  ter.IS_COMBAT=1 and ter.`STATUS`=10
				group by user_id
		) t 
		inner join forum.t_acct_items ai on ai.USER_ID=t.user_id and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1015
		group by t.user_id
	) tt
	inner join forum.t_acct_items ai on ai.USER_ID=tt.user_id and ai.ADD_TIME=tt.ADD_TIME and ai.ITEM_STATUS=10 and ai.ACCT_TYPE=1015
	group by tt.user_id
) t2 on t1.user_id=t2.user_id