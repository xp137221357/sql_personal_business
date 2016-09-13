set @beginTime:='2016-06-10';
set @endTime:='2016-07-09';

/*
---------------------------
全站充值区间
---------------------------
*/
#总充值数据
select t.type,count(distinct t.user_id) '总人数',sum(t.num) '总充值笔数',sum(t.total) '总充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
group by a.USER_ID
) t
group by t.type;


#官充值数据
select t.type,count(distinct t.user_id) '官充人数',sum(t.num) '官充值笔数',sum(t.total) '官充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type=0
group by a.USER_ID
) t
group by t.type;


#其他充值
select t.type,count(distinct t.user_id) '其他充人数',sum(t.num) '其他充值笔数',sum(t.total) '其他充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type != 0
group by a.USER_ID
) t
group by t.type;


#投注数据
select t.type, count(*) `订单数` ,sum(x.ITEM_MONEY) `投注金币`, round(sum(x.PRIZE_MONEY)) `返奖金币` from game.t_order_item x 
inner join forum.t_user u on x.USER_ID=u.USER_CODE
inner join (
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type != 0
group by a.USER_ID
) t  on t.user_id=u.USER_ID
where (x.CHANNEL_CODE = 'GAME' 
and x.CRT_TIME >= @beginTime and x.CRT_TIME < @endTime)
and x.ITEM_STATUS not in (-5,-10) 
group by t.type;	 




/*
-------------------------------------------------
邹能能代理
-------------------------------------------------
*/


#总充值数据
select t.type,count(distinct t.user_id) '总人数',sum(t.num) '总充值笔数',sum(t.total) '总充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
inner join (
select u.USER_ID from game.t_group_ref r 
inner join forum.t_user u on r.USER_ID=u.USER_CODE
where r.ROOT_ID = (select x.REF_ID from game.t_group_ref x where x.USER_ID = '5962840904510621262')
) f on a.user_id=f.user_id
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
group by a.USER_ID
) t
group by t.type;


#官充值数据
select t.type,count(distinct t.user_id) '官充人数',sum(t.num) '官充值笔数',sum(t.total) '官充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
inner join (
select u.USER_ID from game.t_group_ref r 
inner join forum.t_user u on r.USER_ID=u.USER_CODE
where r.ROOT_ID = (select x.REF_ID from game.t_group_ref x where x.USER_ID = '5962840904510621262')
) f on a.user_id=f.user_id
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type=0
group by a.USER_ID
) t
group by t.type;


#其他充值
select t.type,count(distinct t.user_id) '其他充人数',sum(t.num) '其他充值笔数',sum(t.total) '其他充值金额' from 
(
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
inner join (
select u.USER_ID from game.t_group_ref r 
inner join forum.t_user u on r.USER_ID=u.USER_CODE
where r.ROOT_ID = (select x.REF_ID from game.t_group_ref x where x.USER_ID = '5962840904510621262')
) f on a.user_id=f.user_id
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type != 0
group by a.USER_ID
) t
group by t.type;


#投注数据
select  t.type, count(*) `订单数` ,sum(x.ITEM_MONEY) `投注金币`, sum(x.PRIZE_MONEY) `返奖金币` from game.t_order_item x 
inner join forum.t_user u on x.USER_ID=u.USER_CODE
inner join (
select a.USER_ID,sum(a.MONEY) total,count(*) as num,
(
case 
when sum(a.MONEY)<100 then '1充值100或以下'
when sum(a.MONEY)>=100 and sum(a.MONEY)<300 then '2充值100-300'
when sum(a.MONEY)>=300 and sum(a.MONEY)<500 then '3充值300-500'
when sum(a.MONEY)>=500 and sum(a.MONEY)<1000 then '4充值500-1000'
when sum(a.MONEY)>=1000 and sum(a.MONEY)<2000 then '5充值1000-2000'
when sum(a.MONEY)>=2000 and sum(a.MONEY)<5000 then '6充值2000-5000'
else '7充值5000以上' end
) as type from t_user_recharge a 
inner join (
select u.USER_ID from game.t_group_ref r 
inner join forum.t_user u on r.USER_ID=u.USER_CODE
where r.ROOT_ID = (select x.REF_ID from game.t_group_ref x where x.USER_ID = '5962840904510621262')
) f on a.user_id=f.user_id
where a.crt_time >= @beginTime
       AND a.crt_time < @endTime
      and a.type != 0
group by a.USER_ID
) t  on t.user_id=u.USER_ID
where (x.CHANNEL_CODE = 'GAME' 
and x.CRT_TIME >= @beginTime and x.CRT_TIME < @endTime)
and x.ITEM_STATUS not in (-5,-10) 
group by t.type;	 






