-- 邀请码
set @beginTime = '2016-09-01';
set @endTime = '2016-09-21';
set @invite_code = '01036947';



select ai.* from game.t_user_ext t  
inner join forum.t_user u on u.USER_CODE = t.USER_ID and t.INVITE_CODE='01036947'
inner join forum.t_acct_items ai on ai.USER_ID=u.USER_ID and ai.add_time >= @beginTime
       AND ai.add_time <= @endTime;

-- 邀请用户下的人
SELECT Date_format(u.crt_time, '%Y-%m-%d') period_name,
       u.user_id,
       Count(DISTINCT u.user_id)           register_counts
FROM   forum.t_user u
       INNER JOIN forum.t_user_event e
               ON u.user_id = e.user_id
                  AND e.event_code = 'REG'
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       INNER JOIN forum.t_user u2
               ON r2.user_id = u2.user_code
                  AND u2.nick_name = @invite_name
WHERE  u.client_id = 'BYAPP'
       AND u.crt_time >= @begintime
       AND u.crt_time < @endtime
GROUP  BY Date(u.crt_time) ;



-- 赠送以及答题

-- 赠送  game
set @beginTime = '2016-09-01';
set @endTime = '2016-09-30';
set @invite_name = 'byzq1928760';
SELECT Concat(@beginTime, '~', @endTime)         '时间',
       u2.user_id,
       Ifnull(Count(DISTINCT( tp.tuser_id )), 0) '人数',
       Ifnull(Sum(tp.money), 0)                  '金币数'
FROM   forum.t_user_present tp
       INNER JOIN forum.t_user u
               ON u.user_id = tp.tuser_id
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
       inner join forum.t_user u2 on r2.user_id = u2.user_code and u2.nick_name = @invite_name
WHERE  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
group by date(tp.crt_time)
       ; 


-- 答题 game 
SELECT '主动答题',
       Date(o.crt_time),
       u2.user_id,
       Count(DISTINCT( oa.user_id ))                                    '人数'
       ,
       Sum(Abs(Ifnull(o.offer_gratuity, 0) - Ifnull(o.offer_prize, 0)))
       '金币'
FROM   game.t_group_ref r1
       INNER JOIN game.t_group_ref r2
               ON r2.root_id = r1.ref_id
       INNER JOIN forum.t_user u2
               ON r1.user_id = u2.user_code
                  AND u2.nick_name = @invite_name
       INNER JOIN game.t_offer_apply oa
               ON oa.user_id = r2.user_id
       INNER JOIN game.t_offer o
               ON o.offer_id = oa.offer_id
                  AND o.offer_status IN ( 20, 80 )
                  AND o.is_finish = 1
WHERE  r2.crt_time >= @beginTime
       AND r2.crt_time < @endTime
GROUP  BY Date(o.crt_time) 

;

select '被动答题',date(o.CRT_TIME),o.USER_ID,u.NICK_NAME,count(distinct(oa.USER_ID)) '人数',sum(ifnull(o.OFFER_PRIZE,0)-ifnull(o.OFFER_GRATUITY,0) ) '金币'from game.t_group_ref r1 
inner join game.t_group_ref r2 on r2.ROOT_ID = r1.REF_ID 
inner join forum.t_user u2 on r1.user_id = u2.user_code and u2.nick_name = @invite_name
inner join game.t_offer_apply oa on oa.USER_ID = r2.USER_ID 
inner join forum.t_user u on u.USER_CODE = oa.USER_ID
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
where r2.CRT_TIME>=@beginTime
and r2.CRT_TIME< @endTime
group by date(o.CRT_TIME),o.USER_ID;
