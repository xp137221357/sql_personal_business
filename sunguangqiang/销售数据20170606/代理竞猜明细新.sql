-- 竞猜人数

set @param0 = '2017-05-01'; 
create table t_user_bets_5
select o.user_id,round(sum(o.COIN_BUY_MONEY)) bet_coins
from game.t_order_item o 
where o.PAY_TIME>=@param0
and o.PAY_TIME<date_add(@param0,interval 1 month)
and o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
group by o.user_id;

-- 去代理

set @param0 = '2017-05-01'; 
set @param1 = '2017-05';
set @param2 = '5月份';

update t_user_bets_5 t
inner join (
	SELECT 
	    u.user_code,r1.CRT_TIME
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
) tt on t.user_id=tt.user_code
set t.is_agent=1;


-- 返奖金额

set @param0 = '2017-03-01'; 
set @param1 = '2017-03';
set @param2 = '3月份';
update report.t_user_bets_3 t
inner join (
select o.user_id,round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coins
	from game.t_order_item o 
	inner join report.t_user_bets_3 tt on o.USER_ID=tt.USER_ID
	where o.BALANCE_TIME>=@param0
	and o.BALANCE_TIME<date_add(@param0,interval 1 month)
	and o.ITEM_STATUS not in (-5,-10,210)
	and o.COIN_BUY_MONEY>0
	and o.CHANNEL_CODE in ('game','jrtt-jingcai')
	group by o.user_id
	) tt on t.user_id=tt.user_id
set t.prize_coins=tt.prize_coins;

-- 名单

select '5月份投注前100',u.NICK_NAME '用户昵称',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',t.bet_coins '投注',t.prize_coins '返奖' 
from t_user_bets_5 t 
inner join forum.t_user u on t.user_id=u.USER_CODE
where t.is_agent=0
order by t.bet_coins desc 
limit 100;



select '123有投注行为,45月份新归到代理用户',u.NICK_NAME '用户昵称',u.CRT_TIME '注册时间',u.ACCT_NUM '会员号',u.USER_MOBILE '联系方式',t.bet_coins '投注',t.prize_coins '返奖' 
from t_user_bets_123 t 
inner join forum.t_user u on t.user_id=u.USER_CODE
where t.is_agent=1
order by t.bet_coins desc ;


select '123有投注行为,45月份新归到代理用户',
u.NICK_NAME '用户昵称',
u.CRT_TIME '注册时间',
tr.CRT_TIME '加入代理时间',
u1.NICK_NAME '总代理',
u.ACCT_NUM '会员号',
u.USER_MOBILE '联系方式',
t.bet_coins '投注',
t.prize_coins '返奖' 
from t_user_bets_123 t 
inner join game.t_group_ref tr on t.user_id=tr.USER_ID 
inner join game.t_group_ref tr1 on tr.ROOT_ID=tr1.REF_ID
inner join forum.t_user u1 on tr1.USER_ID=u1.USER_CODE
inner join forum.t_user u on t.user_id=u.USER_CODE
where t.is_agent=1
order by t.bet_coins desc 