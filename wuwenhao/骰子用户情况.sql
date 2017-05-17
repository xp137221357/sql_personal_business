-- set param=['2017-03-28','2017-03-28 23:59:59'];
set @param0='2017-03-28';
set @param1='2017-03-28 23:59:59';
SELECT u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',SUM(pay) '总投注', SUM(earn)'总返奖',
CONCAT(ROUND(SUM(earn)/ SUM(pay)*100,2),'%') '返奖率', tc.rmb '金币充值'
FROM h5game.t_tb_result t
inner join forum.t_user u on t.user_id=u.USER_CODE
left join(
   select tu.USER_ID,sum(tc.rmb_value) rmb from  report.t_trans_user_recharge_coin tc
   inner join report.t_trans_user_attr tu on tc.charge_user_id= tu.USER_ID and tc.crt_time<=@param1 
	inner join (
	select user_id FROM h5game.t_tb_result t 
	where t.create_time>=@param0
	and t.create_time<=@param1
	group by t.user_id ) t on tu.USER_CODE=t.user_id
	group by tu.user_id 
) tc on u.USER_ID=tc.user_id
where t.create_time>=@param0
and t.create_time<=@param1
GROUP BY t.user_id;


-- select tc.rmb_value from  report.t_trans_user_recharge_coin tc