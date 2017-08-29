CREATE DEFINER=`report`@`%` EVENT `event_t_stat_partner_user_update`
	ON SCHEDULE
		EVERY 1 MINUTE STARTS '2017-07-21 14:48:50'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT ''
	DO BEGIN
	if now()<date_add(curdate(),interval 12 hour) or now()>date_add(curdate(),interval 13 hour)
	  then
	  call pro_t_stat_partner_user_update();
	end if;
END