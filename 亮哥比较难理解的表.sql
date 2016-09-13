-- 亮哥表的深入理解

t_acct_items: 里面的change_value表示钻石以及金币的变化，而cost_value是change_value变化时牵涉到的金钱变化，并不是一直是一一对应关系，需要根据具体事件来确定两者的关系；
t_device_statistic : 当天设备的及时数据，不能查历史数据，典型的业务表，及时数据；
t_device_statistic :每天的静态数据，ctr_time 表示该条记录创建的时间(act_date=date(crt_time))，add_time: 表示首次创建该设备记录的时间，而并不是这条记录创建的时间，创建是由两个时间决定；
t_rpt_overview: 按日周月为单位统计了大部分的业务数据，针对静态表里面的详细数据，做了一遍统计，主要是不方便去重，并且不能精确到时分秒；



