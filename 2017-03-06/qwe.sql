


select * from(
select distinct o.USER_ID USER_ID_, u.*-- ,te.CHANNEL_NO                                                            
from game.t_order_item o
inner join forum.t_user u on u.USER_code=o.USER_ID  and  o.CHANNEL_CODE='jrtt-jingcai'
-- inner join forum.t_user_event te on u.USER_ID=te.USER_ID  and te.EVENT_CODE='reg'     
)t1                                                                                                     
left join (
select distinct o.USER_ID
from forum.t_user_event te                       
inner join forum.t_user u on u.USER_ID=te.USER_ID  and te.EVENT_CODE='reg'  and te.CHANNEL_NO='jrtt-jingcai'                           
inner join game.t_order_item o on u.USER_CODE=o.USER_ID and o.CHANNEL_CODE='jrtt-jingcai' 

)t2 on t2.user_id=t1.USER_ID_ 
where t2.user_id is null
order by t1.crt_time asc
 ;
 
 
 
 

 
 
 
 
 