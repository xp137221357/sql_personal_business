-- 签到刷子
set @param0='2017-03-13 00:00:00';
set @param1='2017-03-21 11:59:59';



select * from (
select u.NICK_NAME '推荐人昵称',tt.USER_ID '推荐人id',count(distinct t.USER_ID) '购买人数',count(t.USER_ID) '购买次数',sum(t.MONEY) money from 
forum.t_user_match_recom t 
inner join  (
select user_id from forum.t_acct_items ai 
where ai.PAY_TIME>=@param0
and ai.PAY_TIME<=@param1
and ai.ITEM_EVENT='GET_FREE_COIN' and ai.TRADE_NO like 'SIGN_%'
and ai.ITEM_STATUS=10
and ai.ACCT_TYPE=1003
group by user_id
) ai on ai.user_id=t.user_id
inner join forum.t_match_recom tt on t.RECOM_ID=tt.RECOM_ID 
inner join forum.t_user u on tt.user_id =u.USER_ID 
where t.CRT_TIME>=@param0 and t.CRT_TIME<=@param1 
group by tt.USER_ID
) t 
where t.money>1000
order by t.money desc
;