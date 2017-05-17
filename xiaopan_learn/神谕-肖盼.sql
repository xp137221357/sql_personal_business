-- ***mysql性能优化
-- http://www.thinkphp.cn/topic/3855.html

set @beginTime='2016-07-11';
set @endTime = '2016-07-16';

-- 注意一些坑
-- 0!=null
-- 1>null = null 
-- nuLL+1=null
-- sum(null)=null
-- sum(0,null)!=null

select oi.USER_ID,oi.IS_INPLAY,tm.LEAGUE_LEVEL,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL=1,oi.ITEM_MONEY,0)) first_league_pre_bet,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL!=1,oi.ITEM_MONEY,0)) other_league_pre_bet,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL=1,oi.ITEM_MONEY,0)) first_league_play_bet,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL!=1,oi.ITEM_MONEY,0)) other_league_play_bet,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL=1,oi.PRIZE_MONEY,0)) first_league_pre_return,
	sum(if(oi.IS_INPLAY=1 and tm.LEAGUE_LEVEL!=1,oi.PRIZE_MONEY,0)) other_league_pre_return,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL=1,oi.PRIZE_MONEY,0)) first_league_play_return,
	sum(if(oi.IS_INPLAY=0 and tm.LEAGUE_LEVEL!=1,oi.PRIZE_MONEY,0)) other_league_play_return
	from game.t_order_item oi 
	inner join game.t_match_ref tm on oi.BALANCE_MATCH_ID = tm.MATCH_ID 
	where  oi.CHANNEL_CODE = 'game' and oi.ITEM_STATUS not in (-5,-10,210) 
	and oi.CRT_TIME >= @beginTime and oi.CRT_TIME < @endTime
   GROUP BY oi.USER_ID
   
SELECT 
COUNT( DISTINCT IF(vs.user_type=21 AND vs.STATUS = 10, vs.user_id,null)) vip1
FROM t_user_vip_srv vs
WHERE vs.pay_status = 10 AND vs.CRT_TIME <= '2016-07-27' AND vs.CRT_TIME >= '2016-01-01';

-- sql比较差异
select * from (
select 
* from forum.t_acct_items ai 
where ai.ADD_TIME >= @beginTime  and ai.ADD_TIME <= @endTime
and ai.ITEM_EVENT in ('COIN_FROM_DIAMEND') 
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 ) a 
left join 
(
SELECT *
FROM t_trans_user_recharge_coin tc
WHERE tc.charge_method='app' 
AND tc.crt_time>=@beginTime 
AND tc.crt_time<=@endTime) b on a.user_id=b.charge_user_id
where b.charge_user_id is null;

-- 分组求和
select 
ts.stat_date,
ifnull(sum(ts.fore_asserts),0)
FROM t_stat_coin_trends ts
WHERE ts.user_group='all' 
and ts.stat_date>=@beginTime
and ts.stat_date<=@endTime
group by stat_date with rollup ;


-- 取反
select count(tf.user_id) from forum.t_user u 
inner join t_stat_user_first_bet_time tf on u.user_id = tf.user_id 
and u.CRT_TIME>=@beginTime and u.CRT_TIME<=@endTime
and tf.CRT_TIME>=@beginTime and tf.CRT_TIME<=@endTime
left join t_stat_first_recharge tfc on tfc.USER_ID = tf.user_id
and tfc.CRT_TIME>=@beginTime and tfc.CRT_TIME<=@endTime
where tfc.USER_ID is null ;


-- 时间的交错
-- 坚持只有一个变量
SELECT Date_format(ti.add_time, '%Y-%m-%d')
         stat_time,
         ta.system_model
         device_type,
         ta.channel_no,
         Count(DISTINCT ta.user_id)
         new_recharge_count,
         Sum(Ifnull(ti.cost_value, 0))
         cost_value
  FROM   forum.t_acct_items ti
         INNER JOIN forum.t_user tu
                 ON ti.user_id = tu.user_id
                    AND date(tu.crt_time) = date(ti.add_time)
         INNER JOIN t_trans_user_attr ta
                 ON ti.user_id = ta.user_id
  WHERE  ti.item_status = 10
         AND ti.acct_type = 1003
         AND ti.item_event = 'BUY_DIAMEND'
         AND ti.add_time >= @beginTime
         AND ti.add_time < Date_add(@endTime,
                            INTERVAL 7 day)
  GROUP  BY stat_time,
            ta.system_model,
            ta.channel_no
            
            
            
-- 为什么增加子查询会改善计算速度？
-- 1.减少每次计算的数据
-- 2.减少计算次数
-- 3.子查询里面使用group by 先过滤
select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins,
round(sum(oi.COIN_PRIZE_MONEY)) return_coins,
round(sum(oi.COIN_BUY_MONEY))- round(sum(oi.COIN_PRIZE_MONEY)) profit_coins
from game.t_order_item oi -----------

select t.bet_coins,t.return_coins,t.return_coins-t.bet_coins profit_coins from (
select 
round(sum(oi.COIN_BUY_MONEY)) bet_coins,
round(sum(oi.COIN_PRIZE_MONEY)) return_coins
from game.t_order_item oi -----------) t

-- 持续进步
-- left join + where is null/not null实现多功能 代替 inner join
-- left join会引起inner join 项的重复

-- left/right关联表格时（嫁接实体或union all可处理）
-- 务必注注意处理无数据的情况,否则会丢失被关联数据

left join(
SELECT t.charge_user_id,
     Ifnull(Sum(t.rmb_value), 0)     rmb_value
FROM  t_trans_user_recharge_coin t
GROUP  BY t.charge_user_id
) tt on tt.charge_user_id=U.USER_ID  -- and tt.value_type = 5
left join 
(select tt.charge_user_id,tt.crt_time from (
select t.charge_user_id,t.crt_time from t_trans_user_recharge_coin t 
order by t.crt_time asc) tt
group by charge_user_id) tfc on U.USER_ID = tfc.charge_user_id
and tfc.CRT_TIME>=date_add(@beginTime,interval -(datediff(@endTime,@beginTime)+1)*@num day) 
 and tfc.CRT_TIME<=@endTime
 where tt.charge_user_id is not null
 group by stat_time 
)tt ;


-- 计算时差，精确到秒-- 区别datediff
SELECT TIMESTAMPDIFF(hour,'2009-9-01','2009-10-01'); 


-- where 里面加if判断（and作为分隔符要放到外面）
set @param0='2016-09-14';
set @param1='2016-09-14';
set @param2='android';
SELECT period_name AS period_name_v,
      channel_no,
      Sum(pv)     AS device_pv,
      Sum(uv)     AS device_uv
FROM   t_rpt_channel_pv_uv
WHERE  period_type = '1' 
      and if(@param2 is null,device_type in ('android','ios'),device_type=@param2 )
      AND period_name >= @param0
      AND period_name <= @param1
GROUP  BY period_name,channel_no

-- mysql避免重复插入(ignore)
INSERT IGNORE INTO t_user_forbidden (ID, USER_CODE) VALUES (1424, '2694721351731021652');

-- oracle 避免主键冲突
-- insert into t_user_forbidden(ID,user_code) 
-- select 700223 as id,'4135649778560890727' from dual
where not exists (select 1 from t_user_forbidden t where id = t.id);

-- oracle 日期处理
-- * to_date 针对字符串
-- * to_char 针对日期 
-- 实在不行使用 case when end as .. +trunc(sysdate)
SELECT To_char(To_date('&begin_date', 'yyyy-mm-dd') + (ROWNUM-1) / 24 ,
                     'yyyy-mm-dd HH24') minute_time
FROM   dual
CONNECT BY ROWNUM <= 24 

-- ORACLE 日期加减操作
http://www.cnblogs.com/xiao-yu/archive/2011/05/24/2055967.html
-- 时分秒
select sysdate, sysdate+numtodsinterval(1,’second’) from dual ;
-- 天
select sysdate, sysdate+3 from dual ;
-- 月
select sysdate, add_months(sysdate,4) from dual ;

-- oracle日期操作实例
select to_char(sysdate+1/2,'yyyy-mm-dd HH24:MI:SS') from dual;
select to_date('2017-02-21 17:59:00','yyyy-mm-dd HH24:MI:SS') from dual
select sysdate+1,sysdate+1/2 from dual

-- oracle时间戳转化日期
-- 下面的毫秒会四舍五入，导致出现误差
-- 28800=8*60*60的unix/linux时间偏差
-- 86400=24*60*60 
select  TO_DATE('19700101','yyyymmdd') + ((1490025599759+28800000)/86400000) from dual;
-- 正确的方式如下
select  TO_DATE('19700101','yyyymmdd') + ((floor(1490025599759/1000)+28800)/86400) from dual;
-- 或者
select TO_DATE('19700101','yyyymmdd') + 1490025599/86400 +TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone),1,3))/24 from dual;

-- mysql 日期与时间戳之间的转化
-- 日期-->时间戳
select FROM_UNIXTIME(1430236800,'%Y-%m-%d') from dual
-- 时间戳-->日期
select UNIX_TIMESTAMP('2015-04-29');

-- date_format周期格式化
-- 格式化周：Y-U(国外周,周日起)，x-v(国内周,周一起)
-- 周：date_format(ts.stat_time,'%x%v')
select date_add(date_add(curdate(), interval 2-dayofweek(curdate()) day),interval -2 week);
select date_add(date_add(curdate(), interval 2-dayofweek(curdate()) day),interval -1 week);
-- 月：date_format(ts.stat_time,'%Y-%m')
select date_add(date_add(last_day(curdate()),interval -2 month),interval 1 day)
select concat(date_add(last_day(curdate()),interval -1 month),' 23:59:59')


-- ORACLE 条件语句的查询

select  to_char(ai.insert_time,'yyyy-mm-dd') stat_time,
  sum(decode(item_type,1001,ai.acct_balance,1015,ai.acct_balance,0))/100 fore_asserts,
  sum(decode(item_type,1001,ai.acct_balance,0))/100 fore_coin_asserts,
  sum(decode(item_type,1015,ai.acct_balance,0))/100 fore_free_asserts
from t_account_item_snap ai
where
ai.insert_time >= to_date( &beginTime ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and ai.insert_time <= to_date(&endTime ||' 23:59:59','yyyy-mm-dd hh24:mi:ss')
and  ai.acc_name not in ('3472351858331386256','6149208545176280651','8270936710946839603')
and item_type in (1001,1015)
group by to_char(ai.insert_time,'yyyy-mm-dd') 


-- 持续进步
-- case when 两种情况的妙用
-- 1
SELECT t.charge_user_id,
     CASE
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 0
            AND Ifnull(Sum(t.rmb_value), 0) < 500 THEN 1
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 500
            AND Ifnull(Sum(t.rmb_value), 0) < 1000 THEN 2
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 1000
            AND Ifnull(Sum(t.rmb_value), 0) < 2000 THEN 3
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 2000
            AND Ifnull(Sum(t.rmb_value), 0) < 5000 THEN 4
       WHEN Ifnull(Sum(t.rmb_value), 0) >= 5000 
		      AND Ifnull(Sum(t.rmb_value), 0) < 10000 THEN 5
		 WHEN Ifnull(Sum(t.rmb_value), 0) >= 10000    THEN 6
     end                             AS value_type
     
-- 2
SELECT
         CASE t.pd_status
                  WHEN 0 THEN '初始'
                  WHEN 10 THEN '可出票'
                  WHEN 20 THEN '票台拒收'
                  WHEN 30 THEN '票台已收'
                  WHEN -300 THEN 'h5限号失败'
                  WHEN -200 THEN '票台撤单'
                  WHEN 200 THEN '出票成功'
                  ELSE 　　'other'
         end AS "状态",
         count(t.pd_projectnumber) "票数"
FROM     v_ticket t
WHERE    t.pd_addtime>= to_date('&start_date','yyyy-mm-dd')
AND      t.pd_addtime< to_date('&end_date','yyyy-mm-dd')
GROUP BY t.pd_status;

-- 持续进步
-- oracle + java
-- 增加
<insert id="insertNewlyFobiddenUser" parameterType="hashMap" >
		INSERT INTO t_user_forbidden
		<foreach collection="user_batch" separator=" union all "  item="uc">
			select ${uc.id}, #{uc.user_code} from dual
			where not exists (select 1 from t_user_forbidden t where t.id =${uc.id})
		</foreach>
</insert>
-- 删除
<delete id="deleteNewlyRemoveFobiddenUser" parameterType="hashMap" >
		delete from t_user_forbidden
		<where>
			<if test="user_codes != null">
				<foreach collection="user_codes" open="user_code in  (" close=")" separator="," item="uc">
					#{uc.user_code}
				</foreach>
			</if>
		</where>
</delete>
	
-- 持续进步
-- 数据查询 分组之 max,min的妙用 代替 排序
-- 但是请注意：这种方式只能取 分组的字段 作关联条件
select tt.crt_time,'金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time from (
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t group by t.charge_user_id   -- where t.charge_method ='APP'
union all
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_diamond t group by t.charge_user_id
)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 group by tt.charge_user_id

) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method='APP'

-- 我去，排序竟是这样,分组也可以这样
order by first_dnum desc,c.reg_unum desc ,first_buy_unum desc,first_buy_amount desc 
group by first_dnum desc,c.reg_unum desc ,first_buy_unum desc,first_buy_amount desc

-- 持续进步
-- oracle字符串截取-替换（正则表达式）
select REGEXP_REPLACE ('江西11x5_2016102831','[0-9][0-9][0-9]+','') from dual
select regexp_like('1866607571','^1[3|5|8][0-9]\d{4,8}$') from dual  	--判断手机号是否合法 
select '你好'||'是的' from dual  	--判断手机号是否合法 
select substr("ABCDEFG", 0, 3) from dual;  --返回：ABC，截取从A开始3个字符
select substr('OR:com.lcs.wc.placeholder.Placeholder:860825',INSTR('OR:com.lcs.wc.placeholder.Placeholder:860825',':', 1, 2)+1,length('OR:com.lcs.wc.placeholder.Placeholder:860825'))
,INSTR('OR:com.lcs.wc.placeholder.Placeholder:860825',':', 1, 2),
length('OR:com.lcs.wc.placeholder.Placeholder:860825') From dual;
-- mysql
replace('133022 19740403 0671',' ','')
-- 类似与indexof
LOCATE('p','xiaopan')
position('b' IN 'abcd')
INSTR('abcd', 'b')
select substr('xiaopanq',locate('p','xiaopanq')+1,locate('q','xiaopanq')-locate('p','xiaopanq')-1)
update t_job t set t.table_name=substr(t.job_name,locate('[',t.job_name)+1,locate(']',t.job_name)-locate('[',t.job_name)-1)

-- 持续进步
-- *oracle的rownum实现 mysql中的 limit
-- http://www.cnblogs.com/szlbm/p/5806070.html
-- rownum 总是从 1 开始
-- 一般代码中对结果集进行分页就是这么干的:
select * 
from (selet rownum as rn,t1.* from a where ...)
where rn >10

-- 持续进步
-- mysql的正则表达式
select * from forum.t_user u where u.NICK_NAME REGEXP 'byzq[0-9]' limit 1000

-- mysql字符串与数字的转化
方法一：SELECT '123'+0; 
方法二：SELECT CONVERT('123',SIGNED);
方法三：SELECT CAST('123' AS SIGNED);
-- 四舍五入 round
-- 向上取整 ceil
-- 向下取整 floor

-- 持续进步
-- 注意(时间)
now() = curdate()+curtime()

-- 持续进步
-- mysql根据身份证计算年龄
SELECT FLOOR(TIMESTAMPDIFF(MONTH,substr(replace('133022 19740403 0671',' ',''),7,8),curdate())/12)
FROM DUAL

-- 持续进步
-- 使用PREPARE解决limit后面不能接变量问题以及计算
BEGIN
DECLARE ssql VARCHAR(10000);
SET @rownums=0;
SET ssql="insert into test.t1(name) values(@i) limit ?,1000";
while @rownums<10000 do
SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT USING @rownums;
SET @rownums=@rownums+1000;
end while;
END

-- 持续进步
-- 查看事件的执行情况
select * from mysql.`event` v where v.db='report'


-- 持续进步
-- 创建事件实现循环（定时执行）
CREATE DEFINER=`forum`@`%` EVENT `me`
	ON SCHEDULE
		EVERY 1 DAY STARTS '2016-07-19 04:48:26'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT '创建事件'
	DO
BEGIN
DECLARE ssql VARCHAR(10000);
SET @rownums=0;
SET ssql="insert into test.t1(name) values(@i) limit ?,100";
while @rownums<70 do
SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT USING @rownums;
SET @rownums=@rownums+1;
end while;
END

-- 持续进步
-- ***存储过程实现循环(刷数据神器)
-- value表示全局变量
-- @value表示局部变量

BEGIN

DECLARE @date_param INT;
set @date_param = -35;

label1: WHILE date_param <= 0 Do
INSERT into t_stat_coin_operate(stat_date,recharge_coins)
select 
date_add(curdate(),interval date_param day) stat_date,
round(sum(ifnull(ai.CHANGE_VALUE,0))) recharge_coins from forum.t_acct_items ai 
where ai.ADD_TIME >= date_add(curdate(),interval @date_param day)
and ai.ADD_TIME<= concat(date_add(curdate(),interval @date_param day),' 23:59:59')
and ((ai.ITEM_EVENT = 'ADMIN_USER_OPT' 
and ai.COMMENTS like '%网银充值%') or (ai.ITEM_EVENT='COIN_FROM_DIAMEND'))
and ai.ACCT_TYPE in (1001)
and ai.item_status = 10 
on duplicate key update 
recharge_coins = values(recharge_coins);

INSERT into ...

SET @date_param = @date_param + 1;
end while label1;

END

-- 持续进步
-- 存储过程实现循环进阶（limit 传参调用）
DELIMITER //
CREATE DEFINER=`forum`@`%` PROCEDURE `loop8`()
    COMMENT '创建存储过程 '
BEGIN
   set @rownums=0;
	SET @select_sql = 'insert into test.t1(name) select user_id from forum.t_user limit ? ,100';
   PREPARE stmt FROM @select_sql;
   
   while @rownums<1000 do
	EXECUTE stmt using @rownums;
   set @rownums=@rownums+100; 
   end while; 
	DEALLOCATE PREPARE stmt;
END//
DELIMITER ;
-- 注意参数
一个'?'对应一个参数
?,?<-->EXECUTE stmt using @time_day,@time_day1;
call loop8() ;
-- truncate table test.t1;

-- 持续进步
-- 使用触发器实现实时局部更新（局部更新）
DROP TRIGGER IF EXISTS t_afterinsert_on_tab1;
CREATE TRIGGER t_afterinsert_on_tab1 
AFTER INSERT ON tab1
FOR EACH ROW
BEGIN
     insert into tab2(tab2_id) values(new.tab1_id);
END;

-- 持续进步
-- mysql导入csv数据
0.原始文件:word--> text --> excel --> csv --> mysql
1.忽略行
2.处理冲突行
3.格式化数据方式
4.控制字符分隔符
5.目标表以及字段
LOAD DATA LOW_PRIORITY LOCAL INFILE 'D:\\data.csv'
REPLACE INTO TABLE `test`.`t1` 
CHARACTER SET utf8 FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES (`id`, `name`);

-- 持续进步
-- insert结合duplicate批量更新
sql_content=sql_content+' select ip,"'+city_name+'" from test.t_stat_ip_test where ip= "'+ ip[0] +'" union all '
cur.execute("insert INTO test.t_stat_ip_test (ip,city_name)"+sql_content+" on duplicate key update city_name = values(city_name)")
-- update结合join批量更新
update user_mobile_brand_2016_10_11 t1
inner join forum.t_device_info ti 
on t1.DEVICE_CODE = ti.DEVICE_CODE and t1.DEVICE_CODE='eead73c1c7cc4cf6cea2b9236fe165ce' 
set t1.mobile_brand=ti.MOBILE_VERSION

-- --------------------------------------------------------------------------
-- *技术进阶（实现函数功能）
-- mysql函数实现split函数，分割字符串 
-- 获取分割的长度
DELIMITER $$
CREATE DEFINER=`forum`@`%` FUNCTION `func_get_split_string_total`(
	f_string varchar(1000),f_delimiter varchar(5)
) RETURNS int(11)
BEGIN
	return 1+(length(f_string) - length(replace(f_string,f_delimiter,'')));
END$$
DELIMITER ;
-- 实现分割
 DELIMITER $$
 CREATE DEFINER=`forum`@`%` FUNCTION `func_get_split_string`(
 f_string varchar(1000),f_delimiter varchar(5),f_order int) RETURNS varchar(255) CHARSET utf8
 BEGIN
   declare result varchar(255) default '';
   set result = reverse(substring_index(reverse(substring_index(f_string,f_delimiter,f_order)),f_delimiter,1));
   return result;
 END$$
 DELIMITER ;
-- 测试：
 DELIMITER $$
 CREATE PROCEDURE `sp_print_result`(
  IN f_string varchar(1000),IN f_delimiter varchar(5)
 )
 BEGIN
   declare cnt int default 0;
   declare i int default 0;
   set cnt = func_get_split_string_total(f_string,f_delimiter);
   drop table if exists tmp_print;
   create temporary table tmp_print (num int not null);
   while i < cnt
   do
     set i = i + 1;
     insert into tmp_print(num) values (func_get_split_string(f_string,f_delimiter,i));
   end while;
   select * from tmp_print;  
 END$$
 DELIMITER ;
 
 -- 根据需求另外的探索方案 (将ip转化为数值)
set @ip='12.23.45.56';
SELECT round(SUBSTRING_INDEX(@ip,'.',1)+
       SUBSTRING_INDEX(SUBSTRING_INDEX(@ip,'.',2),'.',-1)/1000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(@ip,'.',3),'.',-1)/1000000+
       SUBSTRING_INDEX(SUBSTRING_INDEX(@ip,'.',4),'.',-1)/1000000000,9) from dual
 -- --------------------------------------------------------------------------------------

-- *技术进阶（优化）
-- 优化的实质（茅塞顿开）
-- 1.尽量关联最少的数据
-- 2.尽量使用计算最小的函数
-- 3.尽量拆分大数据的计算

-- 逆天动态行转列
-- 要用到 GROUP_CONCAT
SHOW VARIABLES LIKE "group_concat_max_len";  
SET GLOBAL group_concat_max_len=102400;
SET SESSION group_concat_max_len=102400; 

set @param0='2016-12-21';
set @param1='2016-12-22 23:30:00';
set @param3=18; -- 24

SET @sql = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'COUNT(IF(td.AWARD_ID = ''',
   td.AWARD_ID,
   ''', 1, NULL)) AS ''',
   td.AWARD_NAME, ''''
  )
 ) INTO @sql
FROM forum.t_activity_award td
inner join forum.t_act_award_ref r on r.AWARD_ID=td.AWARD_ID
inner join forum.t_activity taa on r.ACT_ID=taa.ACT_ID
where taa.ACT_ID=18;

SET @sql =CONCAT('
select 
date_format(ta.APPLY_TIME,''','%Y-%m-%d',''') stat_time,
taa.ACT_TITLE 期号,
count(distinct ta.USER_ID) 参与人数,
count(1) 参与次数,
ta.COIN 金币,
ta.PCOIN 体验币,'
, @sql,'
 from forum.t_activity_apply ta 
inner join forum.t_activity taa on ta.ACT_ID=taa.ACT_ID
inner join forum.t_activity_award td on ta.AWARD_ID=td.AWARD_ID
inner join forum.t_user u on ta.USER_ID = u.user_id 
where ta.APPLY_STATUS in (10,20) 
and ta.APPLY_TIME>=''',@param0,
''' and ta.APPLY_TIME<=''',@param1,
''' group by stat_time,taa.ACT_TITLE');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 技术进阶（时间戳转化）
-- oracle
select t.ACC_NAME||'_',t.MONEY*0.01,t.MONEY_AFTER*0.01,TO_DATE('19700101','yyyymmdd') + ((t.MOD_TIME+28800000)/1000/24/60/60),TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) 
from v_account_translog t 
where TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) >= to_date( '2017-01-03' ||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
and TO_DATE('19700101','yyyymmdd') + ((t.CRT_TIME+28800000)/1000/24/60/60) <= to_date('2017-01-03' ||' 23:59:59','yyyy-mm-dd hh24:mi:ss') 
and t.ITEM_TYPE = 1001 AND T.STATUS = 10 and t.ACC_NAME='7716023238115907843'
order by t.CRT_TIME asc ;

-- mysql
select FROM_UNIXTIME('1468078828','%Y-%m-%d %H:%i:%S');

-- oracle(数据回滚,SCN(System Change Number))
-- http://blog.sina.com.cn/s/blog_6d6e54f70100z7yd.html
-- timestamp就是基于scn进行回滚的
SELECT ITEM_TYPE ITEM_TYPE, SUM(ACCT_BALANCE + FREEZE_MONEY) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of timestamp to_date('2017-04-27 23:59:59','yyyy-mm-dd hh24:mi:ss') t
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
SELECT ITEM_TYPE ITEM_TYPE, SUM(ACCT_BALANCE + FREEZE_MONEY) / 100 BALANCE
    FROM V_ACCOUNT_ITEM as of scn TIMESTAMP_TO_SCN(to_date('2017-04-27 23:59:59','yyyy-mm-dd hh24:mi:ss')) t
    where ITEM_TYPE in (1001, 1015)
    group by ITEM_TYPE;
    
-- 2017-04-28 23:59:59, 293600547
-- 2017-04-28 23:59:57, 293600547
-- 每一条记录会对应一个scn,而按时间回滚timestamp每三秒钟匹配一个scn(这样会丢失一部分数据)
SELECT TIMESTAMP_TO_SCN(to_date('2017-04-27 23:59:59','yyyy-mm-dd hh24:mi:ss')) from dual;
SELECT to_char(SCN_TO_TIMESTAMP(293600547),'yyyy-mm-dd hh24:mi:ss') FROM DUAL;

-- 整体运营数据分组
-- 按天分组，按小时分组
-- 通过时间偏移来达到 天与小时分组的组合分组

-- 实际情况
-- * 数据量大时候，尽量用join，尽量不用 in ，避免比较 
-- * 数据量少用in时，里面尽量不用 union all，效率很低


