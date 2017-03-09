inner into t_rpt_permission(LOGIN_NAME,MENU_CODE)
select rp.login_name,rm.PARENT_CODE from t_rpt_menu rm 
inner join t_rpt_permission rp on rm.menu_code = rp.menu_code 
where rm.parent_code is not null 
and rp.login_name in (select login_name from t_rpt_permission where login_name!='请选择需要分配的用户' group by login_name) 
and rm.PARENT_CODE !=-1
group by rp.login_name,rm.PARENT_CODE
on duplicate key update 
LOGIN_NAME = values(LOGIN_NAME),
MENU_CODE = values(MENU_CODE)