


truncate test.t_device_channel;
truncate test.t_channel_promote;
-- 渠道
-- 查询是否存在换行，回车符
select * from test.t_device_channel t where t.COMPANY_NAME like '%\n%' or t.COMPANY_NAME like '%\r%';

-- 去掉换行，回车符
update test.t_device_channel t 
set t.COMPANY_NAME=replace(t.COMPANY_NAME,'\n',''),
t.COMPANY_NAME=replace(t.COMPANY_NAME,'\r','') 
where t.COMPANY_NAME like '%\n%'
or t.COMPANY_NAME like '%\r%';

insert into t_device_channel
select * from test.t_device_channel;

-- -----------------------------------------------------------------------------------------
-- 链接
-- 查询是否存在换行，回车符
select * from test.t_channel_promote t where t.LINK like '%\n%' or t.LINK like '%\r%';

-- 去掉换行，回车符
update test.t_channel_promote t 
set t.LINK=replace(t.link,'\n',''),
t.LINK=replace(t.link,'\r','') 
where t.LINK like '%\n%'
or t.LINK like '%\r%';

-- create table t_acct_items_events


insert into t_channel_promote(PROMOTE_NAME,CHANNEL_NAME,CHANNEL_NO,PROMOTE_POSITION,OPERATE_TYPE,LINK,CRT_TIME,STATUS_ID)
select * from test.t_channel_promote;



update t_job t set t.next_time_execute='2017-03-24' where t.job_name like '%operate%';



select * from t_channel_promote t where t.LINK='/st?e_c=jrtt84&e_a=pageview'


create table t_channel_promote_20170615
select * from report.t_channel_promote;
insert into report.t_channel_promote
select null,t.* from test.t_channel_promote t;


create table t_device_channel_20170615
select * from report.t_device_channel;
insert into report.t_device_channel
select * from test.t_device_channel;










