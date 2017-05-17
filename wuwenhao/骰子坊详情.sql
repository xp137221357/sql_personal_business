set param=['2017-03-28','2017-03-28 23:59:59'];
SELECT room_id '房间ID', COUNT(DISTINCT t.user_id) '投注人数',SUM(pay) '总投注', SUM(earn)'总返奖', 
CONCAT(ROUND(SUM(earn)/ SUM(pay)*100,2),'%') '返奖率'
FROM h5game.t_tb_result t
where t.create_time>=@param0
and t.create_time<=@param1
GROUP BY room_id;


set param=['2017-03-28','2017-03-28 23:59:59'];
select 
date_format(t.create_time,'%Y-%m-%d') stat_date,
count(distinct (if(ITEM_EVENT='TB_TRADE',t.user_id,null))) '下注人数',
abs(round(sum(if(ITEM_EVENT='TB_TRADE',t.amount,0)))) '下注金币',
round(sum(if(ITEM_EVENT='TB_BINGO',t.amount,0))) '返奖金币',
round(sum(if(ITEM_EVENT='TB_CANCEL',t.amount,0))) '取消下注返还金币'
from h5game.t_game_act t where t.game_id=5 and ITEM_EVENT 
in ('TB_BINGO','TB_CANCEL','TB_TRADE')
and t.create_time>=@param0
and t.create_time<=@param1
and t.`status`!=2
group by stat_date;