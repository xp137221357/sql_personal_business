



select t.league_id '联赛id',count(1) '样本数','下半场总进球',concat(sum(if(t.all_score>1,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;

select t.league_id '联赛id',count(1) '样本数','下半场进球',concat(sum(if(t.all_score>1,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;

select t.league_id '联赛id',count(1) '样本数','主队下半场进球',concat(sum(if(t.home_score>0,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;

select t.league_id '联赛id',count(1) '样本数','主队胜或平',concat(sum(if(t.w_d_l>0,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;

select t.league_id '联赛id',count(1) '样本数','主队胜利',concat(sum(if(t.w_d_l=3,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;

select t.league_id '联赛id',count(1) '样本数','平局',concat(sum(if(t.w_d_l=1,1,0))*100/count(1),'%') from t_bets_match_analysis t group by t.league_id;