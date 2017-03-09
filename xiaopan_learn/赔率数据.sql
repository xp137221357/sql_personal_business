select 
t.company_id,
t.match_id,
t.odds_id,
m.match_time,
t.win,
t.draw,
t.lost,
t.win_rate,
t.draw_rate,
t.lost_rate,
t.return_rate,
t.win_keli,
t.draw_keli,
t.lost_keli,
m.home_score,
m.away_score,
(m.home_score+m.away_score) all_score,
case 
    when m.home_score>m.away_score then 3
	 when m.home_score=m.away_score then 1
    when m.home_score<m.away_score then 0
    end as spf
from bets_init_odds_multi_com t 
inner join bets_match m on t.match_id = m.id and m.`status`=4 and t.company_id='1' limit 10
;

