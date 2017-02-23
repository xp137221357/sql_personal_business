SELECT 
t1.win,t1.draw,t1.lost,t1.win_rate,t1.draw_rate,t1.lost_rate,t1.return_rate,t1.win_keli,t1.draw_keli,t1.lost_keli,
t2.win,t2.draw,t2.lost,t2.win_rate,t2.draw_rate,t2.lost_rate,t2.return_rate,t2.win_keli,t2.draw_keli,t2.lost_keli,
t3.win,t3.draw,t3.lost,t3.win_rate,t3.draw_rate,t3.lost_rate,t3.return_rate,t3.win_keli,t3.draw_keli,t3.lost_keli,
t4.win,t4.draw,t4.lost,t4.win_rate,t4.draw_rate,t4.lost_rate,t4.return_rate,t4.win_keli,t4.draw_keli,t4.lost_keli,
t5.win,t5.draw,t5.lost,t5.win_rate,t5.draw_rate,t5.lost_rate,t5.return_rate,t5.win_keli,t5.draw_keli,t5.lost_keli,
t6.win,t6.draw,t6.lost,t6.win_rate,t6.draw_rate,t6.lost_rate,t6.return_rate,t6.win_keli,t6.draw_keli,t6.lost_keli,
t1.home_score,t1.away_score,t1.all_score,t1.w_d_l

FROM test.t_bets_company_18 t1                 
inner join  test.t_bets_company_281 t2 on t1.match_id=t2.match_id 
inner join  test.t_bets_company_474 t3 on t1.match_id=t3.match_id 
inner join  test.t_bets_company_499 t4 on t1.match_id=t4.match_id 
inner join  test.t_bets_company_517 t5 on t1.match_id=t5.match_id 
inner join  test.t_bets_company_545 t6 on t1.match_id=t6.match_id 
where t1.win is not null 
	   and t1.win_rate is not null 
	   and t1.win_keli is not null 
	   and t2.win is not null 
	   and t2.win_rate is not null 
	   and t2.win_keli is not null
	   and t3.win is not null 
	   and t3.win_rate is not null 
	   and t3.win_keli is not null
	   and t4.win is not null 
	   and t4.win_rate is not null 
	   and t4.win_keli is not null
	   and t5.win is not null 
	   and t5.win_rate is not null 
	   and t5.win_keli is not null
	   and t6.win is not null 
	   and t6.win_rate is not null 
	   and t6.win_keli is not null
	   limit 0,10000
