
-- truncate t_user_merchant;



insert into t_user_merchant
select u.USER_ID,u.USER_CODE,u.NICK_NAME,u.ACCT_NUM from forum.t_user u
where u.ACCT_NUM in (
'22746432',
'22746525',
'22746552',
'22746597',
'22746714',
'22748439',
'22748553',
'22748766',
'22748835',
'22748973'
);



select * from forum.t_user_attr a where a.CODE='third_merchant';


update forum.t_user_attr a 
set a.`STATUS`=-10
where a.CODE='third_merchant';

SELECT *
FROM t_user_merchant t

insert into forum.t_user_attr(user_id,code,value,crt_time,mode_time,comments,status)
select u.user_id,'third_merchant','true',now(),now(),null,10 from forum.t_user u 
where u.ACCT_NUM in (
'22746432',
'22746525',
'22746552',
'22746597',
'22746714',
'22748439',
'22748553',
'22748766',
'22748835',
'22748973'
)
ON DUPLICATE KEY UPDATE code=VALUES(code),
value=VALUES(value) ,
crt_time=VALUES(crt_time) ,
mode_time=VALUES(mode_time) ,
comments=VALUES(comments),  
status=VALUES(status); 