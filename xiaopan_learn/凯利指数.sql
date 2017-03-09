-- union实现不同列的方差计算
/*

CREATE TABLE `t_std_keili_18` (
	`MATCH_ID` int(11) not NULL,
	`STD_DEV` decimal(10,4) NULL DEFAULT NULL,
	PRIMARY KEY (`MATCH_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=652043
;


truncate std_keili

*/


CREATE TABLE `t_std_keili_545` (
	`MATCH_ID` int(11) not NULL,
	`STD_DEV` decimal(10,4) NULL DEFAULT NULL,
	PRIMARY KEY (`MATCH_ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=652043
;


insert into t_std_keili_545
select tt.match_id,STDDEV_SAMP(tt.ss) from (
	
	select t.win_keli ss,t.match_id from t_bets_company_545 t where t.win_keli>0 and t.draw_keli>0 and t.lost_keli>0
	union all
	select t.draw_keli ss,t.match_id from t_bets_company_545 t where t.win_keli>0 and t.draw_keli>0 and t.lost_keli>0
	union all
	select t.lost_keli ss,t.match_id from t_bets_company_545 t where t.win_keli>0 and t.draw_keli>0 and t.lost_keli>0

) tt
group by tt.match_id;


-- 大的意义
select * from t_std_keili_18 t 
inner join t_bets_company_18 tt on t.MATCH_ID=tt.MATCH_ID and tt.home_score=tt.away_score and t.STD_DEV=0
order by t.STD_DEV desc limit 100 ;

-- 小的意义
select * from t_std_keili_545 t 
inner join t_bets_company_545 tt on t.MATCH_ID=tt.MATCH_ID and tt.home_score=tt.away_score and t.STD_DEV=0
order by t.STD_DEV desc ;





