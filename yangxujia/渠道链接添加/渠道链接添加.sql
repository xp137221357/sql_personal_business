
-- 渠道
-- 查询是否存在换行，回车符
select * from test.t_device_channel t where t.COMPANY_NAME like '%\n%' or t.COMPANY_NAME like '%\r%';

-- 去掉换行，回车符
update test.t_device_channel t 
set t.COMPANY_NAME=replace(t.COMPANY_NAME,'\n',''),
t.COMPANY_NAME=replace(t.COMPANY_NAME,'\r','') 
where t.COMPANY_NAME like '%\n%'
or t.COMPANY_NAME like '%\r%';

-- -----------------------------------------------------------------------------------------
-- 链接
-- 查询是否存在换行，回车符
select * from test.t_channel_promote t where t.LINK like '%\n%' or t.LINK like '%\r%';

-- 去掉换行，回车符
update test.t_channel_promote t 
set t.LINK=replace(t.COMPANY_NAME,'\n',''),
t.LINK=replace(t.COMPANY_NAME,'\r','') 
where t.LINK like '%\n%'
or t.LINK like '%\r%';












