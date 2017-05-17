
""
http://192.168.88.54:8050/app-web/api/admin/acct_callback?biz=TRADE_COIN&user_code=123456&trade_no=123456&itemtypes=1001,1015&1001=10&1015=12&payTime=1491144641562
&target_user_code=&opt_name=下单&appName=GAME&rId=11.1&tId=null&status=success


set @param0='http://192.168.88.54:8050/app-web/api/admin/acct_callback?biz=TRADE_COIN';
set @param1='&target_user_code=&opt_name=下单&appName=GAME&rId=11.1&tId=null&status=success';
select 
concat(@param0,'&user_code=',
o.USER_ID,'&trade_no=',o.order_id,'&payTime=',UNIX_TIMESTAMP(o.PAY_TIME),'000',

case 
 when o.COIN_BUY_MONEY>0 and o.P_COIN_BUY_MONEY>0
     then concat('&itemtypes=1001,1015&1001=',o.COIN_BUY_MONEY,'&1015=',o.P_COIN_BUY_MONEY)
 when IFNULL(o.P_COIN_BUY_MONEY,0)=0
     then concat('&itemtypes=1001&1001=',sum(o.COIN_BUY_MONEY))
 when IFNULL(o.COIN_BUY_MONEY,0)=0
     then concat('&itemtypes=1015&1015=',sum(o.P_COIN_BUY_MONEY))
END,

@param1) URL
from game.t_order_item o 
where 
o.ORDER_ID
in (
	select t1.order_id from (
	select * from t_order_id_order_0410 t 
	group by t.order_id
	) t1
	left join (
	select * from t_order_id_acct_0410 t 
	group by t.order_id
	) t2 on t1.order_id=t2.order_id
	where t2.order_id is null
	group by t1.order_id
)
and o.ORDER_ID in ('34d50a578f17466f9fe1b20a04ed3eac','ec4f53e6a6de4fcabd02acb54cc941fb')
group by o.ORDER_ID;



select * from forum.t_acct_items ai where ai.ITEM_EVENT='DIAMEND_PRESENT' and ai.COMMENTS like '%充值%' limit 10;


from game.t_order_item o 
where 
o.ORDER_ID
in (
	select t1.order_id from (
	select * from t_order_id_order_0410 t 
	group by t.order_id
	) t1
	left join (
	select * from t_order_id_acct_0410 t 
	group by t.order_id
	) t2 on t1.order_id=t2.order_id
	where t2.order_id is null
	group by t1.order_id
);