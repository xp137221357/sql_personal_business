-- 11424347
-- 11039270


select u.NICK_NAME '昵称',u.ACCT_NUM '会员号',o.COIN_BUY_MONEY '投注金币',o.ITEM_STATUS '状态',o.PAY_TIME '投注时间',o.BALANCE_TIME '结算时间',t.CRT_TIME '加入该代理时间',t.ADD_TIME '成为代理时间',t3.agent '代理' 
from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
inner join game.t_group_ref t on o.USER_ID=t.USER_ID
inner join game.t_group_ref t2 on t.ROOT_ID=t2.REF_ID
inner join report.t_partner_group t3 on t3.user_id=t2.USER_ID -- and t3.agent_acct_num='11039270'
and o.item_status in (0,10,-5,-10,200,210)
and o.PAY_TIME>=t.ADD_TIME
and o.BALANCE_TIME>='2017-07-24 12:00:00'
and o.BALANCE_TIME< '2017-08-07 12:00:00';


 -- 190769260.0000
 -- 142096134.0000
 
select sum(o.COIN_BUY_MONEY) from game.t_order_item o 
inner join forum.t_user u on o.USER_ID=u.USER_CODE
inner join game.t_group_ref t on o.USER_ID=t.USER_ID
inner join game.t_group_ref t2 on t.ROOT_ID=t2.REF_ID
inner join report.t_partner_group t3 on t3.user_id=t2.USER_ID and t3.agent_acct_num='11039270'
and o.item_status not in (0,10,-5,-10,200,210)
and o.PAY_TIME>=t.CRT_TIME
and o.BALANCE_TIME>='2017-07-31 12:00:00'
and o.BALANCE_TIME< '2017-08-07 12:00:00';


select user_id from report.t_partner_group t3 where t3.agent_acct_num='13164990';

-- 282474789.0000
-- 282474789.0000
-- 283690789.0000

select sum(t.ITEM_MONEY) from game.t_partner_order_info t where t.EXPECT>='20170821' and t.EXPECT<'20170828' and t.USER_ID='5256432248645971787' and t.`TYPE`=2;



select sum(t.ITEM_MONEY) from t_partner_total_order_info t where t.STAT_TIME>='2017-08-21' and t.STAT_TIME<'2017-08-28' and t.USER_ID='5256432248645971787';


select * from game.t_group_ref t where t.USER_ID='5256432248645971787';

select t1.* from (
	select * from game.t_group_ref t where t.REF_ID in (
	416925,386492,390134,421494,421497,421557,421740,422037,422061,422070,422076,422130,422133,422241,422430,422451,422511,422514,423273,423285,423387,423390,423393,423396,423402,423405,423408,423411,423414,423453,423456,423504,423507,423534,423567,423573,423594,423657,423660,423669,423696,423699,423741,423774,423777,423786,423816,423978,423981,423984,423987,423990,424131,424251,424266,424500,424827,425115,425118,425166,425190,425205,425208,425340,425343,425496,425649,427317,427518,428043,428184,386495,425619,425700,425703,426273,426522,426576,426624,426723,426729,427038,427041,427044,427047,427146,427302,427320,427332,427473,427476,427890,428031,428112,428529,390137,423549,425028,425031,425034,425037,423789,423954,423957,423960,423963,423966,423969,424119,424260,424263,424272,427914
	)
) t1 

left join (

	select * from game.t_group_ref t where t.REF_ID in (
	-1,416925,386492,390134,421494,421497,421557,421740,422037,422061,422070,422076,422130,422133,422241,422430,422451,422511,422514,423273,423285,423387,423390,423393,423396,423402,423405,423408,423411,423414,423453,423456,423504,423507,423534,423567,423573,423594,423657,423660,423669,423696,423699,423741,423774,423777,423786,423816,423978,423981,423984,423987,423990,424131,424251,424266,424500,424827,425115,425118,425166,425190,425205,425208,425340,425343,425496,425649,427317,427518,428043,428184,386495,390137,423549,423789,423954,423957,423960,423963,423966,423969,424119,424260,424263,424272,425028,425031,425034,425037,425619,425700,425703,426273,426522,426576,426624,426723,426729,427038,427041,427044,427047,427146,427302,427320,427332,427473,427476,427890,427914,428031,428112
	)
) t2 on t1.ref_id=t2.ref_id
where t2.ref_id is null;
-- 113

select game.func_getAllSonUser(416925,-1);






