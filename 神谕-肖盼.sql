set @beginTime='2016-07-11';
set @endTime = '2016-07-16';

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



-- 分足求和
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


-- left join + where is null/not null实现多功能 代替 inner join
-- left join会引起inner join 项的重复

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
select sysdate, add_months(sysdate,4) from dual ;、


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

-- 持续进步
-- mysql根据身份证计算年龄
SELECT FLOOR(TIMESTAMPDIFF(MONTH,substr(replace('133022 19740403 0671',' ',''),7,8),curdate())/12)
FROM DUAL

-- 持续进步
-- mysql的正则表达式
select * from forum.t_user u where u.NICK_NAME REGEXP 'byzq[0-9]' limit 1000

-- 持续进步
-- 使用PREPARE解决limit后面不能接变量问题以及计算
BEGIN
DECLARE ssql VARCHAR(10000);
SET @rownums=0;
SET ssql="insert into test.t1(name) values(@i) limit ?,100";
while @i<70 do
SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT USING @rownums;
SET @rownums=@rownums+1;
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
while @i<70 do
SET @SQUERY=ssql;
PREPARE STMT FROM @SQUERY;
EXECUTE STMT USING @rownums;
SET @rownums=@rownums+1;
end while;
END

-- 持续进步
-- 存储过程实现循环（传参调用,用于刷数据牛）
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
-- 各种文档的转化
word--> text --> excel --> csv --> mysql

-- 持续进步
-- mysql导入csv数据
LOAD DATA LOW_PRIORITY LOCAL INFILE 'D:\\data.csv'
REPLACE INTO TABLE `test`.`t1` 
CHARACTER SET utf8 FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES (`id`, `name`);

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
 -- --------------------------------------------------------------------------------------