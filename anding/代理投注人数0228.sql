set @param0 = '2017-02-19 12:00:00'; 
set @param1 = '2017-02-26 11:59:59';

select '山东代理',concat(@param0,'~',@param1) stat_time,count(distinct o.user_id) '投注人数' from game.t_order_item o 
inner join (
	SELECT 
	       u.user_code user_id
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	         AND u2.nick_name = '邹能能'
	and u.client_id = 'BYAPP'
) t on o.USER_ID=t.user_id
where o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.CHANNEL_CODE='game'

union all

select '内部推广',concat(@param0,'~',@param1) stat_time,count(distinct o.user_id) from game.t_order_item o 
inner join (
	SELECT 
       u.user_code user_id
	FROM   forum.t_user u
	INNER JOIN game.t_group_ref r1
	      ON u.user_code = r1.user_id
	INNER JOIN game.t_group_ref r2
	      ON r1.root_id = r2.ref_id
	INNER JOIN forum.t_user u2
	      ON r2.user_id = u2.user_code
	         AND u2.USER_ID in (select user_id from report.t_user_general_agent)
	and u.client_id = 'BYAPP'
) t on o.USER_ID=t.user_id
where o.PAY_TIME>=@param0
and o.PAY_TIME<=@param1
and o.CHANNEL_CODE='game';












