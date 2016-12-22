



select t.*,
min_differ(t.win_differ,t.draw_differ,t.lost_differ) min_differ,
min_differ_abs(t.win_differ,t.draw_differ,t.lost_differ) min_differ_abs,
differ_type(t.win_differ,t.draw_differ,t.lost_differ) differ_type,
abs_differ_type(t.win_differ,t.draw_differ,t.lost_differ) abs_differ_type,
case t.result_sign
   when t.result_sign>0 then '3'
   when t.result_sign=0 then '1'
   when t.result_sign<0 then '0'
end as result_sign
from ( 
select t.MATCH_ID,t.ADD_TIME,t.COMPANY_ID A_COMPANY_ID,tt.COMPANY_ID B_COMPANY_ID,t.HOME_SCORE-t.AWAY_SCORE result_sign,
t.WIN-tt.WIN win_differ,t.DRAW-tt.DRAW draw_differ,t.LOST-tt.LOST lost_differ
from test.t_odds_analysis_intermediate t  
inner join test.t_odds_analysis_intermediate tt on t.MATCH_ID=tt.MATCH_ID and t.MATCH_ID='1878717' 
) t

-- min_differ(a,b,c)
return if(a>b,if(b>c,'0','1'),if(a>c,'0','3'))

-- min_differ_abs(a,b,c)
a=abs(a),b=abs(b),c=abs(c);
return if(a>b),if(b>c,'0','1'),if(a>c,'0','3'))

-- differ_type(a,b,c)
return 
concat(
case 
 when a>0 then '+'
 when a=0 then '='
 when a<0 then '-'
end as a,
case 
 when b>0 then '+'
 when b=0 then '='
 when b<0 then '-'
end as b,
case 
 when c>0 then '+'
 when c=0 then '='
 when c<0 then '-'
end as c
);

-- abs_differ_type(a,b,c)
a=abs(a),b=abs(b),c=abs(c);
return 
concat(
case 
 when a>0 then '+'
 when a=0 then '='
 when a<0 then '-'
end as a,
case 
 when b>0 then '+'
 when b=0 then '='
 when b<0 then '-'
end as b,
case 
 when c>0 then '+'
 when c=0 then '='
 when c<0 then '-'
end as c
);

-- 创建函数
DELIMITER $$
CREATE FUNCTION `func_get_split_string_total`(
	f_string varchar(1000),f_delimiter varchar(5)
) RETURNS int(11)
BEGIN
	return 1+(length(f_string) - length(replace(f_string,f_delimiter,'')));
END$$
DELIMITER ;

