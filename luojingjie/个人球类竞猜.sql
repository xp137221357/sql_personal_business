

select * from report.t_sql_query t where t.sql_function like '%吴%';

-- set param=['2017-07-01 00:00:00','2017-07-01 23:59:59','all','13503915'];
-- 参数1：起始时间
-- 参数2：结束时间
-- 参数3：竞猜类型，S表示足球，BB表示篮球，all表示全部
-- 参数4：会员号
set @param0='2017-07-03 00:00:00';
set @param1='2017-07-04 00:00:00';
set @param2='s';
set @param3='11017061';

select concat(@param0,'~',@param1) 时间, 
t.NICK_NAME '用户昵称',
t.ACCT_NUM '会员号',
t.bet_coins '投注金额',
t.prize_coins '返奖金额',
concat(round(t.prize_coins*100/t.bet_coins,2),'%') '返奖率',
t.order_counts '订单数',
round(t.bet_coins/t.order_counts,2) '每单金额'
from (
select u.NICK_NAME,u.ACCT_NUM,
count(1) order_counts,
round(sum(o.COIN_BUY_MONEY)) bet_coins,
round(ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0)) prize_coins
 from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
and o.ITEM_STATUS not in (-5,-10,210)
and o.CHANNEL_CODE in ('game','jrtt-jingcai')
and o.COIN_BUY_MONEY>0
and o.BALANCE_TIME>=@param0
and o.BALANCE_TIME<=@param1
and o.BALANCE_STATUS=20
and if(@param2='all',1=1,o.SPORT_TYPE=@param2)   
and u.ACCT_NUM=@param3
) t;


select * from game.t_order_item o order by o.PAY_TIME desc limit 10;


select u.ACCT_NUM from forum.t_user u where u.USER_CODE='3378560097020701194';




