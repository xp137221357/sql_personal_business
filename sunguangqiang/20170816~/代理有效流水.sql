set @param0 = '2017-07-01'; 
set @param1 = '2017-07';
set @param2 = '7月份';

-- 代理用户有效流水
select @param2 '时间',tg.agent '代理',tg.agent_acct_num '会员号',sum(t.EFFECTIVE_MONEY) '有效流水' 
from game.t_partner_order_info t 
inner join (
select td.user_code,'2017-01-01' from report.t_partner_group_detail td where td.stat_time=@param1
) tt on t.USER_ID=tt.user_code
inner join report.t_partner_group tg on tt.user_code=tg.user_id
and t.`TYPE`=2
where date(t.EXPECT)>=@param0 
and date(t.EXPECT)<date_add(@param0,interval 1 month)
group by tg.agent;

