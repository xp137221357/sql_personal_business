13128719804
18503089073

SELECT e.DEVICE_CODE,e.EVENT_PARAM, COUNT(1)
FROM forum.t_user_event e
WHERE e.USER_ID IN (
SELECT user_id
FROM forum.t_user u
WHERE u.USER_MOBILE IN ('13128719804','18503089073')

)
GROUP BY e.DEVICE_CODE;


SELECT e.DEVICE_CODE,e.EVENT_PARAM, COUNT(1)
FROM forum.t_user_event e
WHERE e.USER_ID IN (
SELECT user_id
FROM forum.t_user u
WHERE u.USER_MOBILE IN ('18503089073')

)
GROUP BY e.DEVICE_CODE;


-- 风中追风,byzq2257128
-- 372D6C39-C1AF-4682-904C-1A959A4D2918,55D439B4-8437-4CD5-A3F9-6910515FB238,64778937-6255-4A72-9CAE-BDC049840467;
SELECT *
FROM forum.t_user u
WHERE u.USER_MOBILE IN ('13128719804','18503089073')

select u.user_id,u.nick_name,e.DEVICE_CODE,count(1) FROM forum.t_user_event e
inner join forum.t_user u on e.USER_ID=u.USER_ID and u.NICK_NAME in 
('乌贼波经') and e.EVENT_CODE='reg'
group by u.USER_ID,e.DEVICE_CODE;

SELECT *
FROM forum.t_user u where u.NICK_NAME='风中追风';


SELECT *
FROM forum.t_user u
WHERE u.USER_MOBILE IN ('13128719804','18503089073')

select u.user_id,u.nick_name,e.DEVICE_CODE,e.EVENT_PARAM FROM forum.t_user_event e
inner join forum.t_user u on e.USER_ID=u.USER_ID and u.NICK_NAME in 
('依心而行'
,'byzq23529188'
,'aaaaqqqq'
,'byzq2363340'
,'西丽'
,'大强168'
,'AAA118'
,'aaa168'
,'byzq2315967'
,'byzq2288766'
,'好彩'
,'百战足球123'
,'百战百盈123'
,'疯狂之夜'
,'BangBang爆'
,'mogen'
,'魔石文化'
,'魔登翁'
,'大战皇家赌场'
,'byzq668868'
,'苍井老师'
,'一刀决胜'
,'8182'
,'球道问精'
,'全身隐'
,'江湖人'
,'江湖大海'
,'HW001'
,'依靠1'
,'byzq2520591'
,'byzq2258982'
,'齐天大圣666'
,'胜负金手指'
,'血战风云')
group by u.USER_ID,e.DEVICE_CODE


小左
 小左
解盘小神仙


select u.NICK_NAME,e.* FROM forum.t_user_event e
inner join forum.t_user u on u.USER_ID =e.USER_ID
where e.DEVICE_CODE in ('02A1FE41-057E-4D34-B458-E7A095F72D0D','8561835D-1103-4369-9333-F404F3EB864F')
and u.NICK_NAME in (
'风中追风','小左',' 小左','解盘小神仙',
'依心而行',
,'byzq23529188'
,'aaaaqqqq'
,'byzq2363340'
,'西丽'
,'大强168'
,'AAA118'
,'aaa168'
,'byzq2315967'
,'byzq2288766'
,'好彩'
,'百战足球123'
,'百战百盈123'
,'疯狂之夜'
,'BangBang爆'
,'mogen'
,'魔石文化'
,'魔登翁'
,'大战皇家赌场'
,'byzq668868'
,'苍井老师'
,'一刀决胜'
,'8182'
,'球道问精'
,'全身隐'
,'江湖人'
,'江湖大海'
,'HW001'
,'依靠1'
,'byzq2520591'
,'byzq2258982'
,'齐天大圣666'
,'胜负金手指'
,'血战风云');
;
-- 64778937-6255-4A72-9CAE-BDC049840467


-- byzq2257128

select u.NICK_NAME,count(1),e.* FROM forum.t_user_event e
inner join forum.t_user u on u.USER_ID =e.USER_ID
where e.DEVICE_CODE in ('02A1FE41-057E-4D34-B458-E7A095F72D0D','71C58A1B-AC02-4827-B2B7-EC1ECE5AB893','8561835D-1103-4369-9333-F404F3EB864F') 
-- and e.EVENT_CODE='REG'
group by u.USER_ID;


select u.NICK_NAME,e.* from forum.t_user_event e 
inner join forum.t_user u on u.user_id=e.user_id
where e.DEVICE_CODE in ('1F37D548-F0D3-4708-8149-2595215E2BE5');



8561835D-1103-4369-9333-F404F3EB864F
02A1FE41-057E-4D34-B458-E7A095F72D0D;



select u.NICK_NAME,e.* from forum.t_user_event e 
inner join forum.t_user u on u.user_id=e.user_id
where  u.NICK_NAME in ('冷刀·山东')
and e.CRT_TIME>='2016-12-01';

-- 93BCF355-2EAF-45DA-9815-24AA2C3B99FD,7c48f05607e4d6adec12f6bb018a2f19
小左
桃源333
玩个球
 小左
解盘小神仙

select u.user_id,u.nick_name,e.DEVICE_CODE,count(1) FROM forum.t_user_event e
inner join forum.t_user u on e.USER_ID=u.USER_ID and u.NICK_NAME in 
('乌贼波经') -- and e.EVENT_CODE='reg'
group by u.USER_ID,e.DEVICE_CODE;



select * from (
select u.NICK_NAME,e.* FROM forum.t_user_event e
inner join forum.t_user u on u.USER_ID =e.USER_ID
where e.DEVICE_CODE in ('02A1FE41-057E-4D34-B458-E7A095F72D0D','8561835D-1103-4369-9333-F404F3EB864F')
and u.NICK_NAME in ('依心而行','风中追风','小左',' 小左','解盘小神仙'
,'byzq23529188'
,'aaaaqqqq'
,'byzq2363340'
,'西丽'
,'大强168'
,'AAA118'
,'aaa168'
,'byzq2315967'
,'byzq2288766'
,'好彩'
,'百战足球123'
,'百战百盈123'
,'疯狂之夜'
,'BangBang爆'
,'mogen'
,'魔石文化'
,'魔登翁'
,'大战皇家赌场'
,'byzq668868'
,'苍井老师'
,'一刀决胜'
,'8182'
,'球道问精'
,'全身隐'
,'江湖人'
,'江湖大海'
,'HW001'
,'依靠1'
,'byzq2520591'
,'byzq2258982'
,'齐天大圣666'
,'胜负金手指'
,'血战风云')) t1

inner join (
select u.NICK_NAME,e.* from forum.t_user_event e 
inner join forum.t_user u on u.user_id=e.user_id
where  u.NICK_NAME in ('冷刀·山东')
and e.CRT_TIME>='2016-12-01'

) t2 on t1.ip=t2.ip;

select * from ( 
select tc.sn,u.nick_name '用户充值',u2.nick_name '币商',tc.coins '充值金币',tc.crt_time '充值时间' ,e.*
from report.t_trans_user_recharge_coin tc 
inner join forum.t_user u on u.USER_ID=tc.charge_user_id and tc.charge_method!='app'
inner join forum.t_user u2 on u2.USER_ID=tc.saler 
inner join forum.t_user_event e on u.USER_ID=e.USER_ID and e.CRT_TIME<=tc.crt_time
and u.NICK_NAME in (
'依心而行'
,'byzq23529188'
,'aaaaqqqq'
,'byzq2363340'
,'西丽'
,'大强168'
,'AAA118'
,'aaa168'
,'byzq2315967'
,'byzq2288766'
,'好彩'
,'百战足球123'
,'百战百盈123'
,'疯狂之夜'
,'BangBang爆'
,'mogen'
,'魔石文化'
,'魔登翁'
,'大战皇家赌场'
,'byzq668868'
,'苍井老师'
,'一刀决胜'
,'8182'
,'球道问精'
,'全身隐'
,'江湖人'
,'江湖大海'
,'HW001'
,'依靠1'
,'byzq2520591'
,'byzq2258982'
,'齐天大圣666'
,'胜负金手指'
,'血战风云')
order by e.CRT_TIME desc
) t group by t.sn;


select * from (
select tc.sn,u.nick_name '用户提现',u2.nick_name '币商',tc.coins '提现金币',tc.crt_time '提现时间' ,e.*
from report.t_trans_user_withdraw tc 
inner join forum.t_user u on u.USER_ID=tc.user_id
inner join forum.t_user u2 on u2.USER_ID=tc.buyer 
inner join forum.t_user_event e on u.USER_ID=e.USER_ID and e.CRT_TIME<=tc.crt_time
and u.NICK_NAME in (
'依心而行'
,'byzq23529188'
,'aaaaqqqq'
,'byzq2363340'
,'西丽'
,'大强168'
,'AAA118'
,'aaa168'
,'byzq2315967'
,'byzq2288766'
,'好彩'
,'百战足球123'
,'百战百盈123'
,'疯狂之夜'
,'BangBang爆'
,'mogen'
,'魔石文化'
,'魔登翁'
,'大战皇家赌场'
,'byzq668868'
,'苍井老师'
,'一刀决胜'
,'8182'
,'球道问精'
,'全身隐'
,'江湖人'
,'江湖大海'
,'HW001'
,'依靠1'
,'byzq2520591'
,'byzq2258982'
,'齐天大圣666'
,'胜负金手指'
,'血战风云')
 order by e.CRT_TIME desc
 ) t group by t.sn;

select u.NICK_NAME,e.* from forum.t_user_event e 
inner join forum.t_user u on u.user_id=e.user_id
where  u.NICK_NAME in ('春风十里','清风一缕','流风一曲','风中追风','Jerry')
and e.CRT_TIME>='2017-04-21'
and e.CRT_TIME<'2017-04-23';
