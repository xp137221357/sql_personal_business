set @param0='2016-10-31 00:00:00';
set @param1='2016-11-06 23:59:59';

SELECT ms.season_name_cn,
       Date_format(m.match_time, '%Y-%m-%d %H:%i:%s')
       match_time,
       Concat(m.home_team_sxname, ' VS ', m.away_team_sxname)
       match_name,
       case tm.league_level_raw
       	when 1 then '一级联赛'
       	when 2 then '二级联赛'
       	when 3 then '三级联赛'
       	when 4 then '四级联赛'
       	when 5 then '五级联赛'
       	else '其他' end as league_level,
       Round(Sum(w.item_money))
       item_money,
       Round(Sum(w.prize_money))
       prize_money,
       Concat(Round(Sum(w.prize_money) / Sum(w.item_money) * 100, 2), '%')
       prize_count,
       Count(DISTINCT w.user_id)
       item_people,
       Count(1)
       item_count,
       Round(Count(1) / Count(DISTINCT w.user_id), 2)
       avg_item,
       Round(Sum(w.item_money) / Count(1))
       avg_item_money,
       Round(Sum(w.item_money) - Sum(w.prize_money))
       profit_count,
       Round(( Sum(w.item_money) - Sum(w.prize_money) ) / 100)
       profit_money
FROM   game.t_order_item w
       INNER JOIN fb_main.t_match m
               ON w.balance_match_id = m.match_id
       INNER JOIN game.t_match_ref tm
					ON w.balance_match_id = tm.match_id
       INNER JOIN fb_main.t_match_season ms
               ON ms.season_id = m.season_id
                  AND m.match_time >= @param0
                  AND m.match_time <= @param1
                  AND item_status NOT IN( -5, -10, 210 )
                  AND channel_code = 'GAME'
GROUP  BY balance_match_id
ORDER  BY match_time asc






