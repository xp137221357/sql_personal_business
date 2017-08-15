set @param0='2017-06-01';
set @param1='2017-06-19 23:59:59';

select u.NICK_NAME '发消息的人',uc.COMMENT_CONTENT '消息内容',u2.NICK_NAME '接收人',m.READ_TIME '读取时间'
from t_user_comment uc
inner join forum.t_user u on uc.USER_ID=u.USER_ID
inner join t_chat_room r on r.ID=uc.ENTITY_ID  
inner join t_chat_room_member m on r.ID=m.CHAT_ID and m.IS_CREATE=1 and  uc.ENTITY_TYPE='4'
inner join forum.t_user u2 on m.USER_ID=u2.USER_ID
where uc.USER_ID!=m.USER_ID
and uc.COMMENT_TIME>= @param0
and uc.COMMENT_TIME<= @param1
and m.READ_TIME>= @param0
and m.READ_TIME<= @param1;


SELECT COUNT(1)
FROM t_user_comment uc
INNER JOIN t_chat_room r ON r.ID=uc.ENTITY_ID
INNER JOIN t_chat_room_member m ON r.ID=m.CHAT_ID AND m.IS_CREATE=1
WHERE uc.ENTITY_TYPE='4' AND uc.COMMENT_TIME>'2017-01-01';

select u.NICK_NAME '发消息的人',uc.COMMENT_CONTENT '消息内容',u2.NICK_NAME '接收人',m.READ_TIME '读取时间'
from t_user_comment uc
inner join forum.t_user u on uc.USER_ID=u.USER_ID
inner join t_chat_room r on r.ID=uc.ENTITY_ID  
inner join t_chat_room_member m on r.ID=m.CHAT_ID and m.IS_CREATE=1 
inner join forum.t_user u2 on m.USER_ID=u2.USER_ID
inner join (

	select u.user_id
	from forum.t_user u
	inner join 
	(
	   select t.charge_user_id,min(t.crt_time) crt_time from report.t_trans_user_recharge_coin t group by t.charge_user_id  
	)tt on u.USER_ID=tt.charge_user_id and tt.crt_time>=@param0 and tt.crt_time<=@param1 and u.`STATUS`=10 

) tc on m.USER_ID=tc.user_id
where  uc.ENTITY_TYPE='4' and m.READ_TIME>=@param0 and m.READ_TIME<=@param1;



select uc.USER_ID '发消息的人',uc.COMMENT_CONTENT '消息内容',m.USER_ID '接收人',m.READ_TIME '读取时间'
from t_user_comment uc
inner join t_chat_room r on r.ID=uc.ENTITY_ID  
inner join t_chat_room_member m on r.ID=m.CHAT_ID and m.IS_CREATE=1 
where  uc.ENTITY_TYPE='4' and m.READ_TIME>=@param0 and m.READ_TIME<=@param1
and m.USER_ID in (
'9658992',
'9659334',
'9659448',
'9659469',
'9627936',
'9707301',
'9705750',
'9653670',
'9676980',
'9659166',
'9658920',
'9677160',
'9678651',
'9676110',
'9673041',
'9627111',
'9653709',
'9654645',
'9654015',
'9680301',
'9666459',
'9670572',
'9682116',
'9705747',
'9627849',
'9656991',
'9677370',
'9652935',
'9656136',
'9626805',
'9704472',
'9706431',
'9627102',
'9627141',
'9627348',
'9652068',
'9679410',
'9660849',
'9707046',
'9656628',
'9656928',
'9658362',
'9658578',
'9658593',
'9627579',
'9662145',
'9698790',
'9675942',
'9629310',
'9674073',
'9706611',
'9705231',
'9705384',
'9706143',
'9704637',
'9705831',
'9682761',
'9676893',
'9628860',
'9686094',
'9659406',
'9656313',
'9659340',
'9659418',
'9653901',
'9658872',
'9662343',
'9657939',
'9629748',
'9628401',
'9665295',
'9654684',
'9660312',
'9705711',
'9659004',
'9661458',
'9628596',
'9673398',
'9653109',
'9705651',
'9706287',
'9657411',
'9657807',
'9653949',
'9656337',
'9662403',
'9708075',
'9654750',
'9678945',
'9676599',
'9639015',
'9676998',
'9677391',
'9659904',
'9628356',
'9675267',
'9629091',
'9692589',
'9638292',
'9660480',
'9644016',
'9705954',
'9706020',
'9683319',
'9677721',
'9709710',
'9661890',
'9625104',
'9655359',
'9636774',
'9661440',
'9638910',
'9705153',
'9650469',
'9654648',
'9629361',
'9694680',
'9653727'
);