CREATE DEFINER=`report`@`%` EVENT `event_t_stat_partner_user`
	ON SCHEDULE
		EVERY 1 DAY STARTS '2017-08-29 12:00:00'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT ''
	DO BEGIN

truncate t_stat_partner_user;
call pro_t_stat_partner_user();

END