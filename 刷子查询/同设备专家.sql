
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


select t1.*,t3.times '推荐次数','-' '分界线',t2.*,t4.times '推荐次数' from (
select u.NICK_NAME '昵称',u.REALNAME '真实姓名',u.CRT_TIME '注册时间',u.USER_MOBILE '联系方式',e.USER_ID ,e.DEVICE_CODE from forum.t_expert te 
inner join forum.t_user_event e on te.USER_ID=e.USER_ID and te.IS_EXPERT=1
inner join forum.t_user u on u.user_id =te.user_id
group by e.USER_ID,e.DEVICE_CODE
) t1 
left join (
select u.NICK_NAME '昵称',u.REALNAME '真实姓名',u.CRT_TIME '注册时间',u.USER_MOBILE '联系方式',e.USER_ID ,e.DEVICE_CODE from forum.t_expert te 
inner join forum.t_user_event e on te.USER_ID=e.USER_ID and te.IS_EXPERT=1
inner join forum.t_user u on u.user_id =te.user_id 
group by e.USER_ID,e.DEVICE_CODE
) t2 on t1.DEVICE_CODE = t2.DEVICE_CODE and t1.user_id !=t2.user_id
left join (
select te.user_id,count(tm.RECOM_ID) times from forum.t_expert te 
left join forum.t_match_recom tm on tm.USER_ID=te.USER_ID and te.IS_EXPERT=1 
group by te.USER_ID
) t3 on t1.user_id =t3.user_id
left join (
select te.user_id,count(tm.RECOM_ID) times from forum.t_expert te 
left join forum.t_match_recom tm on tm.USER_ID=te.USER_ID and te.IS_EXPERT=1 
group by te.USER_ID
) t4 on t4.user_id =t2.user_id
where t2.USER_ID is not null;


select count(1) from(
select count(distinct t2.user_id) ass from (
select u.NICK_NAME,u.USER_MOBILE,e.USER_ID,e.DEVICE_CODE from forum.t_expert te 
inner join forum.t_user_event e on te.USER_ID=e.USER_ID and te.IS_EXPERT=1
inner join forum.t_user u on u.user_id =te.user_id
group by e.USER_ID,e.DEVICE_CODE
) t1 
left join (
select u.NICK_NAME,u.USER_MOBILE,e.USER_ID,e.DEVICE_CODE from forum.t_expert te 
inner join forum.t_user_event e on te.USER_ID=e.USER_ID and te.IS_EXPERT=1
inner join forum.t_user u on u.user_id =te.user_id 
group by e.USER_ID,e.DEVICE_CODE
) t2 on t1.DEVICE_CODE = t2.DEVICE_CODE and t1.user_id !=t2.user_id
where t2.USER_ID is not null
group by t1.user_id
) t where t.ass>50
;


-- 分析师poolet
-- 共415