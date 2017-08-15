


set @param0 = '2017-06-01'; 
set @param1 = '2017-06';
set @param2 = '6月份';


-- 总任务赠送
select  @param2 '时间','投注任务领取',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
left join report.t_trans_user_attr tu on ai.USER_ID=tu.USER_ID and tu.CHANNEL_NO='jrtt-jingcai'
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.CHANGE_VALUE>=2500
and ai.ITEM_EVENT='user_task'
and tu.USER_ID is null;


-- 代理任务赠送

select  @param2 '时间','代理务投注任务赠送',sum(ai.CHANGE_VALUE) '金币数' 
from forum.t_acct_items ai 
inner join (
	SELECT 
	    u.user_id,r1.CRT_TIME
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id  
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	inner join report.t_group_partner_detail td on td.user_id=u2.USER_ID and td.stat_time=@param1 
	      and u.client_id = 'BYAPP'
	group by u.USER_ID
	
	union all
	
	select td.user_code,'2017-01-01' from report.t_group_partner_detail td where td.stat_time=@param1
) tt on ai.USER_ID=tt.user_id
where ai.PAY_TIME>=@param0 
and ai.PAY_TIME>=tt.CRT_TIME
and ai.PAY_TIME<date_add(@param0,interval 1 month)
and ai.CHANGE_VALUE>=2500
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT='user_task';









