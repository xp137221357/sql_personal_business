
-- 最新充值情况解释 --

set @beginTime='2016-09-19';
set @endTime = '2016-09-19 23:59:59';

 select user_id '用户ID',rmb_value '人民币' from (
 SELECT t.charge_user_id user_id,
        sum(t.rmb_value) rmb_value
 FROM   (SELECT tc.charge_user_id,
                tc.rmb_value
         FROM   t_trans_user_recharge_coin tc                    
         UNION ALL
         SELECT td.charge_user_id,
                td.rmb_value
         FROM   t_trans_user_recharge_diamond td
         ) t 
 GROUP  BY t.charge_user_id) tt 
 
  -- 官方首次充值情况
 select user_id '用户ID',crt_time '人民币' from (
 SELECT t.user_id,
        t.crt_time
 FROM   ( select * from (
		 		select * from (
		         SELECT tc.user_id,
		                tc.crt_time
		         FROM   t_stat_first_recharge_coin tc                    
		         UNION ALL
		         SELECT td.user_id,
		                td.crt_time
		         FROM   t_stat_first_recharge_dmd td
		      ) t order by t.crt_time asc
		  ) t where t.crt_time -- -----------
 GROUP  BY t.user_id) tt 

-- 总新增充值

select tt.crt_time,'金币',tu.SYSTEM_MODEL,tu.CHANNEL_COMPANY, tc.charge_user_id,tc.rmb_value from t_trans_user_recharge_coin tc
inner join t_trans_user_attr tu on tc.charge_user_id = tu.USER_ID  and tu.CHANNEL_COMPANY=@channel_company
inner join (
select tt.charge_user_id,min(tt.crt_time) crt_time from (
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_coin t group by t.charge_user_id   -- where t.charge_method ='APP'
union all
select t.charge_user_id,min(t.crt_time) crt_time from t_trans_user_recharge_diamond t group by t.charge_user_id
)tt where tt.crt_time>=@param0 and tt.crt_time<=@param1 group by tt.charge_user_id

) tt on tc.charge_user_id = tt.charge_user_id 
and tc.charge_method='APP'


 
 -- 其他充值情况

 SELECT u.NICK_NAME '昵称',
        u.USER_MOBILE '联系方式',
        u.CRT_TIME '注册时间',
        te.DEVICE_CODE '设备号',
        t.user_id '用户ID',
        t.charge_type '充值类型',
        t.charge_method '充值方式',
        t.rmb_value 'rmb',
        t.crt_time '充值时间'
 FROM   (SELECT tc.user_id,
                '金币' charge_type,
                ttc.charge_method,
                ttc.rmb_value,
                tc.crt_time
         FROM   t_stat_first_recharge_coin tc   
         inner join t_trans_user_recharge_coin ttc on tc.user_id=ttc.charge_user_id and tc.crt_time>= @beginTime and tc.crt_time<= @endTime 
         UNION ALL
         SELECT td.user_id,
                '钻石' charge_type,
                ttd.charge_method,
                ttd.rmb_value,
                td.crt_time
         FROM   t_stat_first_recharge_dmd td 
         inner join t_trans_user_recharge_diamond ttd on td.user_id=ttd.charge_user_id and  td.crt_time>= @beginTime and td.crt_time<= @endTime        
         ) t 
inner join forum.t_user u on u.USER_ID = t.user_id
inner join forum.t_user_event te on te.USER_ID = u.user_id and te.EVENT_CODE='REG' 
inner join forum.t_device_channel tdc on te.CHANNEL_NO = tdc.CHANNEL_NO and tdc.COMPANY_NAME = '百盈'
 
 