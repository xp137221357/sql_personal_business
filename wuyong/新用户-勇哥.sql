
-- new users------------------------------------------

set @beginTime = '2016-06-10';
set @endTime = '2016-07-09';
select  '总参与数', count(distinct t.user_id) from tmp_user_bet_0610_0709
t join forum.t_user u on u.USER_CODE = t.user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫');

select '充值用户数', count(t.user_id) from tmp_user_bet_0610_0709 t join forum.t_user u on u.USER_CODE = t.user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
where u.USER_ID in (select user_id from t_user_recharge r where r.crt_time >= @beginTime and r.crt_time < @endTime);

select '非充值用户数', count(t.user_id) from tmp_user_bet_0610_0709 t join forum.t_user u on u.USER_CODE = t.user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
where u.USER_ID not in (select user_id from t_user_recharge r where r.crt_time >= @beginTime and r.crt_time < @endTime);


select count(distinct r.user_id) as `官充用户数`, round(sum(money)) `充值金额`  from t_user_recharge r 
join  forum.t_user u on u.USER_ID = r.user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
join tmp_user_bet_0610_0709 t on u.USER_CODE = t.user_id
where r.crt_time >= @beginTime and r.crt_time < @endTime and r.`TYPE`=0;

-- 1-线下, 2-赏金, 4-赠送 
select count(distinct r.user_id) as `第三方充值用户数`, round(sum(money)) `充值金额`  from t_user_recharge r join  forum.t_user u on u.USER_ID = r.user_id
join tmp_user_bet_0610_0709 t on u.USER_CODE = t.user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
where r.crt_time >= @beginTime and r.crt_time < @endTime and r.`TYPE` in (1,2,4);

 
select sum(ai.CHANGE_VALUE) as `充值钻石数` from FORUM.t_acct_items ai join tmp_user_bet_0610_0709 t on (ai.ACCT_ID = t.user_id
 and ai.ITEM_STATUS = 10 AND ai.ITEM_EVENT = 'BUY_DIAMEND'  and ai.COMMENTS not  like '%underline%' and ai.COMMENTS not  like '%buy_coin%')
 inner join forum.t_user u on u.USER_ID = ai.USER_ID
 and u.CRT_TIME>=@beginTime
 and u.CRT_TIME <= @endTime
 and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME < @endTime;


select sum(c.coins) `充值金币数` from tmp_log_charge_coin c join forum.t_user u on u.USER_ID = c.charge_user_id
and u.CRT_TIME>=@beginTime
and u.CRT_TIME <= @endTime
and u.NICK_NAME not in (
'朦',
'Prometheus',
'DJ',
'sarah',
'亚述帝国',
'纵横四海',
'孤剑独行',
'一览众山小',
'手机商店',
'走地波王',
'信中利周成武',
'明月照尖东',
'濠江风云',
'慢悠悠,晃悠悠',
'名游彩票',
'名游彩票APP',
'口袋德州扑克',
'高尔夫')
join tmp_user_bet_0610_0709 t on u.USER_CODE = t.user_id;