## 8月31日-9月10日充值1元礼包的用户
set @bt:='2016-10-03';
set @et:='2016-10-09 23:59:59';

set @bt2:='2016-10-10';
set @et2:='2016-10-16 23:59:59';

# 目标用户(注册用户)
select '目标用户',concat(@bt,'~',@et)  value1,count(distinct u.USER_ID) value2 
from forum.t_user u
where u.CLIENT_ID='BYAPP' and u.`STATUS`=10 and u.CRT_TIME>=@bt and u.CRT_TIME<=@et


union all

# 启动过app的用户数
select '启动过app的用户数',concat(@bt,'~',@et)  value1,count(distinct di.USER_CODE) value2 
from report.t_device_statistic di 
inner join  forum.t_user u on di.USER_CODE = u.USER_CODE
and u.CLIENT_ID='BYAPP' and u.`STATUS`=10 and u.CRT_TIME>=@bt and u.CRT_TIME<=@et
and di.ACT_DATE >= @bt2
and di.ACT_DATE <= @et2

union all

# 充值金币金额以及人数（含第三方）
select '充值金币人数（含第三方）', count(distinct urc.charge_user_id),sum(urc.rmb_value) 
from report.t_trans_user_recharge_coin urc 
inner join  forum.t_user u on urc.charge_user_id = u.USER_ID
and u.CLIENT_ID='BYAPP' and u.`STATUS`=10 and u.CRT_TIME>=@bt and u.CRT_TIME<=@et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2

union all

# 投注人数 & 投注金币
select '投注人数以及投注金币',count(distinct oi.USER_ID), sum(oi.COIN_BUY_MONEY) 
from game.t_order_item oi 
inner join  forum.t_user u on oi.user_id = u.USER_CODE
and u.CLIENT_ID='BYAPP' and u.`STATUS`=10 and u.CRT_TIME>=@bt and u.CRT_TIME<=@et
and oi.PAY_TIME >= @bt2
and oi.PAY_TIME <= @et2

union all

# 充值钻石人数与金额
select '充值钻石人数与金额', count(distinct urc.charge_user_id),sum(urc.rmb_value) from 
report.t_trans_user_recharge_diamond urc 

inner join  forum.t_user u on urc.charge_user_id = u.USER_ID
and u.CLIENT_ID='BYAPP' and u.`STATUS`=10 and u.CRT_TIME>=@bt and u.CRT_TIME<=@et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2


/*
# 充值金币人数与金额
select '充值金币人数与金额',sum(ai.CHANGE_VALUE), count(distinct urc.user_id) from report.t_stat_first_recharge_coin urc inner join 
forum.t_acct_items ai
on urc.user_id = ai.USER_ID
 where ai.ITEM_EVENT = 'BUY_DIAMEND' AND ai.COMMENTS  like '%ACT_YYLB%' 
## and ai.APP_TYPE in ('BYAPP', 'GAME')
and ai.ADD_TIME >= @bt and ai.ADD_TIME < @et
and urc.crt_time >= @bt2
and urc.crt_time <= @et2;
*/