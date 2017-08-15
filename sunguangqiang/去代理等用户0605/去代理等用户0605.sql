1、2017年1月1日-5月25日有投注（竞猜足球、篮球）的用户，在5.26-6.5不再投注；
2、去掉已封/刷子的帐号；
3、去掉以下无效代理及子用户“风中追风、匣内金刀、乌贼波经、有哥、霸盈足道、百战百盈 123、江湖大海、西丽、魔登翁、齐天大圣666、血战风云、byzq668868、球道问精”；
4、去掉现在有效的代理及所有子用户；
5、去掉公司内部IP的登录过的帐号；
5、查询维度：
   用户昵称、联系方式、充值金币数、兑出金币数、投注金币数、返奖金币数、最后打开APP 时间

-- 孙观强
create table t_user_bets20170605
select u.USER_ID from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.CLIENT_ID='byapp' and u.STATUS=10
where ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-05-26'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
group by u.user_id;


-- 去代理用户
update t_user_bets20170605 t set t.user_status=-10
where t.USER_ID in (
select u.USER_ID from (
SELECT 
       u.user_code user_id
FROM   forum.t_user u
INNER JOIN game.t_group_ref r1
      ON u.user_code = r1.user_id  
INNER JOIN game.t_group_ref r2
      ON r1.root_id = r2.ref_id
INNER JOIN forum.t_user u2
      ON r2.user_id = u2.user_code
inner join 
 (select tg.USER_ID from report.t_partner_group tg where tg.is_valid=0
  union all 
  select tg.USER_ID from report.t_partner_group tg where tg.user_id in (
  
  select user_code from forum.t_user u where u.NICK_NAME in (
  '风中追风','匣内金刀','乌贼波经','有哥','霸盈足道','百战足球123','江湖大海','西丽','魔登翁','齐天大圣666','血战风云','byzq668868','球道问精'
  ))
  
  ) tg
  on tg.user_id=u2.USER_CODE and u.client_id = 'BYAPP'
group by u.USER_ID

 union all

select tt.user_id from 

(select tg.USER_ID from report.t_partner_group tg where tg.is_valid=0
  union all 
  select tg.USER_ID from report.t_partner_group tg where tg.user_id in (
  
  select user_code from forum.t_user u where u.NICK_NAME in (
  '风中追风','匣内金刀','乌贼波经','有哥','霸盈足道','百战足球123','江湖大海','西丽','魔登翁','齐天大圣666','血战风云','byzq668868','球道问精'
  ))
  
) tt
  
) t 
inner join forum.t_user u on t.user_id =u.user_code 
);

-- 去公司内网ip
update t_user_bets20170605 t 
inner join forum.t_user_event e on t.USER_ID=e.USER_ID and t.user_status=10 and t.ID>=@num and t.ID<@num+10 
inner join t_stat_inner_ip_address tt on e.IP like concat("'",tt.inner_ip,"%'") 
set t.user_status=-11 ;


-- 去掉有投注行为的用户

update t_user_bets20170605 t set t.user_status=-12
where t.USER_ID in (
select u.USER_ID from forum.t_acct_items ai 
inner join forum.t_user u on ai.USER_ID=u.USER_ID and u.CLIENT_ID='byapp' and u.STATUS=10
where ai.PAY_TIME>='2017-05-26'
and ai.PAY_TIME<'2017-06-06'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
group by u.user_id
) 
and t.user_status=10;




select * from t_user_bets20170605 t where t.user_status=10;


-- 6258

-- 投注
insert into t_user_bets20170605(USER_ID,bet_coins)
select t.USER_ID,sum(ai.CHANGE_VALUE) 
from t_user_bets20170605 t 
inner join forum.t_acct_items ai on ai.USER_ID=t.USER_ID and t.user_status=10 and t.ID>=@num and t.ID<@num+100 
where ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-05-06'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('trade_coin','bk_trade_coin')
group by t.USER_ID
on duplicate key update 
bet_coins = values(bet_coins);

-- 返奖
insert into t_user_bets20170605(USER_ID,prize_coins)
select t.USER_ID,sum(ai.CHANGE_VALUE) 
from t_user_bets20170605 t 
inner join forum.t_acct_items ai on ai.USER_ID=t.USER_ID and t.user_status=10 t.ID>=@num and t.ID<@num+100 
where ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-05-06'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('prize_coin','bk_prize_coin')
group by t.USER_ID
on duplicate key update 
prize_coins = values(prize_coins);

-- 异常返奖
insert into t_user_bets20170605(USER_ID,ex_prize_coins)
select t.USER_ID,sum(if(ai.CHANGE_TYPE=0,ai.CHANGE_VALUE,-ai.CHANGE_VALUE)) 
from t_user_bets20170605 t 
inner join forum.t_acct_items ai on ai.USER_ID=t.USER_ID and t.user_status=10 t.ID>=@num and t.ID<@num+100 
where ai.PAY_TIME>='2017-01-01'
and ai.PAY_TIME<'2017-05-26'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1001
and ai.ITEM_EVENT in ('EX_PRIZE_COIN','BK_EX_PRIZE_COIN')
group by t.USER_ID
on duplicate key update 
ex_prize_coins = values(ex_prize_coins);

-- 充值
insert into t_user_bets20170605(USER_ID,recharge_coins)
select t.USER_ID,sum(tc.coins) 
from t_user_bets20170605 t
inner join report.t_trans_user_recharge_coin tc  on tc.charge_user_id=t.USER_ID and t.user_status=10 and t.ID>=@num and t.ID<@num+100 
where tc.crt_time>='2017-01-01'
and tc.crt_time<'2017-05-26'
group by t.USER_ID
on duplicate key update 
recharge_coins = values(recharge_coins);

-- 兑出
insert into t_user_bets20170605(USER_ID,draw_coins)
select t.USER_ID,sum(tc.coins) 
from t_user_bets20170605 t
inner join report.t_trans_user_withdraw tc  on tc.user_id=t.USER_ID and t.user_status=10 and t.ID>=@num and t.ID<@num+100 
where tc.crt_time>='2017-01-01'
and tc.crt_time<'2017-05-26'
group by t.USER_ID
on duplicate key update 
draw_coins = values(draw_coins);


-- 最后一次登陆时间
insert into t_user_bets20170605(USER_ID,last_time)
select t.USER_ID,t.CRT_TIME from (
select t.USER_ID,e.CRT_TIME from t_user_bets20170605 t
inner join forum.t_user_event e on t.USER_ID=e.USER_ID and t.user_status=10 and t.ID>=@num and t.ID<@num+100 
order by e.CRT_TIME desc 
) t group by t.USER_ID
on duplicate key update 
last_time = values(last_time);


select 
u.NICK_NAME '用户昵称',
u.ACCT_NUM '会员号',
u.CRT_TIME '用户注册时间',
u.USER_MOBILE '联系方式',
t.bet_coins '投注金币',
ifnull(t.prize_coins,0)+ifnull(t.ex_prize_coins,0) '返奖金币',
t.recharge_coins '充值金币数',
t.draw_coins '提现金币数',
t.last_time '最后一次登陆时间'
from t_user_bets20170605 t
inner join forum.t_user u on t.USER_ID=u.USER_ID and t.user_status=10;















