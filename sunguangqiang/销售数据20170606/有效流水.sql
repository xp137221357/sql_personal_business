set @param0 = '2017-04-01'; 
set @param1 = '2017-04';
set @param2 = '4月份';

-- 代理用户有效流水
select @param2,sum(t.EFFECTIVE_MONEY) '有效流水' from game.t_partner_order_info t 
inner join (
select td.user_code,'2017-01-01' from report.t_group_partner_detail td where td.stat_time=@param1
) tt on t.USER_ID=tt.user_code
and t.`TYPE`=2
where date(t.EXPECT)>=@param0 
and date(t.EXPECT)<date_add(@param0,interval 1 month);

-- 反水



-- 分红
select * from game.t_partner_order_info t  where t.REBATES_MONEY>0;