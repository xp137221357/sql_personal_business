-- t_group_ref表
game.t_group_ref
-- add_time 加入代理时间
-- crt_time 加入当前代理时间
-- update_time 修改信息时间

对比两种方式的效率：
-- 1.跑t_stat_partner_user的方式(时间--2:30)
pro_t_partner_total_order_info_datetime
pro_t_partner_total_order_info_realtime
-- 2.使用func_getAllSonUser的方式(时间-- 4:30)
pro_t_partner_total_order_info_datetime_temp 
pro_t_partner_total_order_info_realtime_temp


-- t_stat_partner_user表
t_stat_partner_user
event_t_stat_partner_user
event_t_stat_partner_user_update
pro_t_stat_partner_user
pro_t_stat_partner_user_update

-- t_partner_user_info表
t_partner_user_info
event_t_partner_user_info

-- t_partner_order_info表
t_partner_order_info
event_t_partner_order_info_datetime
event_t_partner_order_info_realtime
pro_t_partner_order_info_datetime
pro_t_partner_order_info_realtime

-- t_partner_total_order_info表
t_partner_total_order_info
event_t_stat_partner_user -- 同order_info
event_t_stat_partner_user_update -- 同order_info
pro_t_partner_total_order_info_datetime
pro_t_partner_total_order_info_realtime

;






