select max(id) from report.t_stat_yylb_20170905

call pro_t_stat_yylb_20170905();


create table t_stat_yylb_20170905 
select * from t_stat_yylb_20170905;

truncate t_stat_yylb_20170905;


select 
t.user_id '用户ID',
t.channel_no '渠道编码',
t.crt_time '注册时间',
t.last_reg_time '最后一次登陆时间',
t.pay_time '充值一元礼包时间',
IFNULL(t.coin_recharge_times,0) '金币充值次数',
IFNULL(t.diamond_recharge_times,0) '钻石充值次数',
IFNULL(t.bet_times,0) '投注次数',
IFNULL(t.game_times,0) '游戏次数',
IFNULL(t.recom_times,0) '推荐次数',
IFNULL(t.third_recharge_times,0) '第三方充值次数',
IFNULL(t.coin_balance,0) '金币余额',
if(u.`STATUS`=10,'正常','非正常') '是否正常用户'
from t_stat_yylb_20170905 t
inner join forum.t_user u on u.user_id=t.user_id;


-- 4478256


select t.channel_no,count(1) '一元礼包充值人数'  from t_stat_yylb_20170905 t
group by t.channel_no;

select t.channel_no,count(1) '再次充值人数'  from t_stat_yylb_20170905 t
where t.recharge_times>0
group by t.channel_no;

select t.channel_no,count(1) '未投注人数'  from t_stat_yylb_20170905 t
where t.bet_times=0
group by t.channel_no;

select t.channel_no,count(1) '投注1次人数'  from t_stat_yylb_20170905 t
where t.bet_times=1
group by t.channel_no;

select t.channel_no,count(1) '投注2次人数'  from t_stat_yylb_20170905 t
where t.bet_times=2
group by t.channel_no;

select t.channel_no,count(1) '投注多于次人数'  from t_stat_yylb_20170905 t
where t.bet_times>2
group by t.channel_no;


select t.channel_no,count(1) '游戏1次人数'  from t_stat_yylb_20170905 t
where t.game_times=1
group by t.channel_no;

select t.channel_no,count(1) '游戏2次人数'  from t_stat_yylb_20170905 t
where t.game_times=2
group by t.channel_no;

select t.channel_no,count(1) '游戏多于次人数'  from t_stat_yylb_20170905 t
where t.game_times>2
group by t.channel_no;


select t.channel_no,count(1) '购买推荐1次人数'  from t_stat_yylb_20170905 t
where t.recom_times=1
group by t.channel_no;

select t.channel_no,count(1) '购买推荐2次人数'  from t_stat_yylb_20170905 t
where t.recom_times=2
group by t.channel_no;

select t.channel_no,count(1) '购买推荐多于次人数'  from t_stat_yylb_20170905 t
where t.recom_times>2
group by t.channel_no;




