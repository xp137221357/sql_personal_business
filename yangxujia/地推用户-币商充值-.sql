-- '邹能能','三少爷的剑','球霸天下','虎豹竞技','军88888','星光大道'

set @beginTime = '2015-01-01';
set @endTime = '2016-06-30';
set @invite_name = '三少爷的剑';


-- invite_code SELECT USER_ID FROM game.T_USER_EXT E WHERE E.INVITE_CODE = @invite_code 
-- where u.USER_NAME in ('邹能能','三少爷的剑','球霸天下','虎豹竞技','军88888','星光大道')) game_u on gr.ROOT_ID = game_u.ref_id
-- '681647','681680','116345','683714','116339','683735','681707','116348','499940','116327'


-- 人数，金额
SELECT Concat(@beginTime, '~', @endTime)         '时间',
       '10个币商赠送',
       Ifnull(Count(DISTINCT( tp.tuser_id )), 0) '人数',
       Ifnull(Sum(tp.money), 0)                  '金币数'
FROM   forum.t_user_present tp
       INNER JOIN forum.t_user u
               ON u.user_id = tp.tuser_id
       INNER JOIN game.t_group_ref r1
               ON u.user_code = r1.user_id
       INNER JOIN game.t_group_ref r2
               ON r1.root_id = r2.ref_id
                  AND r2.user_id IN (SELECT u.user_code
                                     FROM   forum.t_user u
                                     WHERE  u.nick_name = @invite_name)
WHERE  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
       AND tp.tuser_id NOT IN ( '681647', '681680', '116345', '683714',
                                '116339', '683735', '681707', '116348',
                                '499940', '116327' )
       AND tp.user_id IN ( '681647', '681680', '116345', '683714',
                           '116339', '683735', '681707', '116348',
                           '499940', '116327' ); 
											

## 币商主动给下级用户金币
select '币商主动给下级用户金币',count(distinct(oa.USER_ID)) '人数',sum(ifnull(o.OFFER_GRATUITY,0) - ifnull(o.OFFER_PRIZE,0) )/139 '金额(元)' from game.t_group_ref r1 
inner join game.t_group_ref r2 on r2.ROOT_ID = r1.REF_ID and r1.USER_ID in (select u.user_code from forum.t_user u where u.NICK_NAME = @invite_name)
inner join game.t_offer_apply oa on oa.USER_ID = r2.USER_ID 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 20 and o.IS_FINISH = 1
and o.USER_ID in (
'7716023238115907843',
	 '4516792169673735156',
	 '2562487736174455137',
	 '6539206858494085098',
    '7628039216292251019',
	 '1461793826663430759',
	 '1745692733604265172',
	 '6325706835133877418',
	 '2843567313246132614',
	 '5987210529470669465')
and oa.USER_ID not in (
'7716023238115907843',
	 '4516792169673735156',
	 '2562487736174455137',
	 '6539206858494085098',
    '7628039216292251019',
	 '1461793826663430759',
	 '1745692733604265172',
	 '6325706835133877418',
	 '2843567313246132614',
	 '5987210529470669465');
	 
	 
## 币商被动给下级用户金币
select '币商被动给下级用户金币',count(distinct(oa.USER_ID)) '人数',sum(ifnull(o.OFFER_PRIZE,0)-ifnull(o.OFFER_GRATUITY,0) )/139 '金额(元) 'from game.t_group_ref r1 
inner join game.t_group_ref r2 on r2.ROOT_ID = r1.REF_ID and r1.USER_ID in (select u.user_code from forum.t_user u where u.NICK_NAME = @invite_name)
inner join game.t_offer_apply oa on oa.USER_ID = r2.USER_ID 
inner join game.t_offer o on o.OFFER_ID = oa.OFFER_ID and o.OFFER_STATUS = 80 and o.IS_FINISH = 1
and oa.USER_ID in (
'7716023238115907843',
	 '4516792169673735156',
	 '2562487736174455137',
	 '6539206858494085098',
    '7628039216292251019',
	 '1461793826663430759',
	 '1745692733604265172',
	 '6325706835133877418',
	 '2843567313246132614',
	 '5987210529470669465')
and o.USER_ID not in (
'7716023238115907843',
	 '4516792169673735156',
	 '2562487736174455137',
	 '6539206858494085098',
    '7628039216292251019',
	 '1461793826663430759',
	 '1745692733604265172',
	 '6325706835133877418',
	 '2843567313246132614',
	 '5987210529470669465');
	 
-- 投注人数，投注订单数

SELECT     Concat(@begintime,'~',@endtime) '时间',
           '被邀请用户投注订单详情',
           count(DISTINCT oi.user_id) `投注人数`,
           count(1) `投注单数量`
FROM       game.t_order_item oi
INNER JOIN game.t_group_ref r1
ON         oi.user_id = r1.user_id
INNER JOIN game.t_group_ref r2
ON         r1.root_id = r2.ref_id
AND        r2.user_id IN
           (
                  SELECT u.user_code
                  FROM   forum.t_user u
                  WHERE  u.nick_name = @invite_name)
WHERE      oi.channel_code = 'GAME'
AND        oi.item_status NOT IN (-5,-10)
AND        oi.crt_time >= @beginTime
AND        oi.crt_time < @endTime;



