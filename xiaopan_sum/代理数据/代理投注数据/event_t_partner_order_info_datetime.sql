CREATE DEFINER=`report`@`%` EVENT `event_t_partner_order_info_datetime`
	ON SCHEDULE
		EVERY 1 DAY STARTS '2017-07-29 12:30:00'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT ''
	DO BEGIN
call pro_t_partner_order_info_datetime();
call pro_t_partner_total_order_info_datetime();
END