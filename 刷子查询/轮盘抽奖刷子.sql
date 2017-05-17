set @param0='2017-03-13 00:00:00';
set @param1='2017-03-21 11:59:59';

select count(distinct t.user_id),sum(t.pay),sum(t.pcoin_pay),sum(t.earn),sum(t.pcoin_earn) from h5game.t_roulette_act t 
where t.create_time>=@param0
and t.create_time<=@param1
and t.award_type=1003
and t.`status`=1;


select count(distinct user_id) from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='LP_PRIZE'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003;



select count(distinct user_id) from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='DIAMEND_PRESENT'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003;


select ai.ITEM_EVENT from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
group by ai.ITEM_EVENT;



select ai.* from forum.t_acct_items ai 
inner join (
select user_id from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='LP_PRIZE'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by user_id
) t on t.user_id = ai.user_id
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
order by user_id,ai.PAY_TIME asc
;

select concat(@param0,'~',@param1) '时间',ai.ITEM_EVENT '事件',count(distinct ai.user_id) '人数',sum(ai.CHANGE_VALUE) '金额' from forum.t_acct_items ai 
inner join (
select user_id from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='GET_FREE_COIN'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by user_id
) t on t.user_id = ai.user_id
and ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by ai.ITEM_EVENT
;


select u.NICK_NAME,tt.USER_ID,count(t.USER_ID) from 
forum.t_user_match_recom t on e.USER_ID=t.USER_ID and t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1
inner join  (
select user_id from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='LP_PRIZE'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by user_id
) ai on ai.user_id=t.user_id
inner join forum.t_match_recom tt on t.RECOM_ID=tt.RECOM_ID 
inner join forum.t_user u on tt.user_id =u.USER_ID
where t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1 
group by tt.USER_ID;



select u.NICK_NAME '推荐人昵称',tt.USER_ID '推荐人id',count(distinct t.USER_ID) '购买人数',count(t.USER_ID) '购买次数',sum(t.MONEY) '购买金额' from 
forum.t_user_match_recom t 
inner join  (
select user_id from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='LP_PRIZE'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by user_id
) ai on ai.user_id=t.user_id
inner join forum.t_match_recom tt on t.RECOM_ID=tt.RECOM_ID 
inner join forum.t_user u on tt.user_id =u.USER_ID and u.USER_ID in('978302','2366592','2416698')
where t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1 
group by tt.USER_ID;


select tu.NICK_NAME '昵称',tr.user_id '用户id',tr.device_id '设备id',tr.client_ip 'ip地址'from (
	select t.user_id from 
	forum.t_user_match_recom t 
	inner join  (
	select user_id from forum.t_acct_items ai 
	where ai.PAY_TIME>=@param0
	and ai.PAY_TIME<=@param1
	and ai.ITEM_EVENT='LP_PRIZE'
	and ai.ITEM_STATUS=10
	and ai.ACCT_TYPE=1003
	group by user_id
	) ai on ai.user_id=t.user_id
	inner join forum.t_match_recom tt on t.RECOM_ID=tt.RECOM_ID 
	inner join forum.t_user u on tt.user_id =u.USER_ID and u.USER_ID in('978302','2366592','2416698')
	where t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1 
	group by t.USER_ID
) t 
inner join report.t_trans_user_attr tu on tu.USER_ID=t.user_id
inner join h5game.t_roulette_act tr on tr.user_id=tu.user_code
and tr.create_time>=@param0
and tr.create_time<=@param1
and tr.award_type=1003
and tr.`status`=1
group by tr.user_id,tr.device_id,tr.client_ip;

-- ip
select u1.NICK_NAME,t1.ip,u2.NICK_NAME,t2.ip from (
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in ('978302','2366592','2416698')
group by e.USER_ID,e.IP
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.IP from forum.t_user_event e
where e.USER_ID in ('978302','2366592','2416698')
group by e.USER_ID,e.IP
) t2 on t1.user_id !=t2.user_id and substr(t1.IP,1,6) =substr(t2.IP,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id
group by u1.USER_ID,u2.USER_ID;

-- 设备
select u1.NICK_NAME,t1.DEVICE_CODE,u2.NICK_NAME,t2.DEVICE_CODE from (
select e.USER_ID,e.DEVICE_CODE from forum.t_user_event e
where e.USER_ID in ('978302','2366592','2416698')
group by e.USER_ID,e.DEVICE_CODE
) t1 
left join forum.t_user u1 on u1.USER_ID=t1.user_id
left join(
select e.USER_ID,e.DEVICE_CODE from forum.t_user_event e
where e.USER_ID in ('978302','2366592','2416698')
group by e.USER_ID,e.DEVICE_CODE
) t2 on t1.user_id !=t2.user_id and substr(t1.DEVICE_CODE,1,6) =substr(t2.DEVICE_CODE,1,6)
left join forum.t_user u2 on u2.USER_ID=t2.user_id
group by u1.USER_ID,u2.USER_ID;

-- 明细
select u.NICK_NAME '用户昵称',t.USER_ID '用户ID',u.ACCT_NUM '会员号',u.CRT_TIME '注册时间' from (
select user_id from forum.t_user_event e 
where e.DEVICE_CODE in (
'b8a6332b5767f0cef0e40ddf5bd1bbcb',
'fef35a9be849af2fbbff0bc601defb66',
'27bc1ffca7f52fe8c78476771cc220f8',
'bd68733d3536cb2794087a36f255987f',
'8853a05e732b9f909e8f627fa85140ff',
'3A4529BF-B1C1-4D42-AC1E-F549F32ADB98',
'2dd678cc77fab586ef73a5e923d6e09c'
)
group by e.USER_ID
) t 
inner join forum.t_user u on u.USER_ID=t.user_id;


-- 
