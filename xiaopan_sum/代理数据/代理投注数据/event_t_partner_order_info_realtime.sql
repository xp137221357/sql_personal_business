CREATE DEFINER=`report`@`%` EVENT `event_t_partner_order_info_realtime`
	ON SCHEDULE
		EVERY 10 MINUTE STARTS '2017-07-26 17:41:11'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT ''
	DO BEGIN
call pro_t_partner_order_info_realtime();
call pro_t_partner_total_order_info_realtime();
END