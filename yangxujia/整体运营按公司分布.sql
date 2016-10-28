-- set params=['2016-09-14','2016-09-21 23:59:59'];  //请输入参数--"起始时间"，"结束时间"

-- device_type: 终端类型,device_pv：访问pv，device_uv：访问uv
-- first_dnum：首次激活，reg_unum：新增注册
-- first_buy_unum：首次充值人数，first_buy_amount：首次充值金额，buy_unum：充值人数，buy_amount：充值金额

set @param0='2016-09-14';
set @param1='2016-09-30 23:59:59';

-- 时间段合并

-- set params=['2016-09-14','2016-09-21 23:59:59'];  //请输入参数--"起始时间"，"结束时间"
select 
ifnull(tdc.company_name,'other') company_name,
ifnull(tdc.channel_name,'other') channel_name, 
ifnull(c.device_type,'other') device_type,
c.first_dnum,
c.reg_unum,
concat(round(if(c.first_dnum>0,c.reg_unum*100/c.first_dnum,0),2),'%') reg_active,
c.first_buy_unum,
concat(round(if(c.reg_unum>0,c.first_buy_unum*100/c.reg_unum,0),2),'%') first_recharge_reg,
concat(round(if(c.first_dnum>0,c.first_buy_unum*100/c.first_dnum,0),2),'%') first_recharge_active,
c.first_buy_amount,
round(if(c.first_buy_unum>0,c.first_buy_amount/c.first_buy_unum,0),2) per_first_recharge_money,
c.buy_unum,
cc.buy_unums,
c.buy_amount,
round(if(c.buy_unum>0,c.buy_amount/c.buy_unum,0),2) per_recharge_money
FROM    (SELECT 
           channel_no,
           device_type,
           Sum(first_dnum)         AS first_dnum,
           Sum(second_dnum)        AS second_dnum,
           Sum(active_dnum)        AS active_dnum,
           Sum(reg_unum)           AS reg_unum,
           Sum(first_buy_unum)     AS first_buy_unum,
           Sum(first_buy_amount)   AS first_buy_amount,
           Sum(buy_unum)           AS buy_unum, 
           Sum(buy_amount)         AS buy_amount
     FROM   t_rpt_overview
     WHERE  period_type = '1'
           AND period_name >= @param0
           AND period_name <= @param1
          -- and CHANNEL_NO in () and tt.DEVICE_TYPE=
     GROUP  BY channel_no,device_type
	  ) c
	  left join (
	  select count(distinct tt.user_id) buy_unums ,tu.CHANNEL_NO,tu.SYSTEM_MODEL from (
	  select charge_user_id user_id from 
	  (select tc.charge_user_id from t_trans_user_recharge_coin tc 
	  where tc.charge_method='APP'
	  -- and CHANNEL_NO in () and tt.DEVICE_TYPE=
	  and tc.crt_time>=@param0 and tc.crt_time<=@param1
	  
	  union all
	  
	  select tc.charge_user_id from t_trans_user_recharge_diamond tc 
	  -- and CHANNEL_NO in () and tt.DEVICE_TYPE=
	  where tc.crt_time>=@param0 and tc.crt_time<=@param1 
	  ) tt group by tt.charge_user_id) tt
	  inner join t_trans_user_attr tu on tu.USER_ID=tt.user_id 
	  GROUP  BY channel_no,SYSTEM_MODEL) cc 
	  on cc.CHANNEL_NO=c.channel_no and cc.SYSTEM_MODEL=c.device_type
     left join report.t_device_channel tdc on tdc.CHANNEL_NO = c.channel_no 
where c.first_dnum is not null 
and  c.reg_unum is not null 
and  c.first_buy_unum is not null 
and  c.first_buy_amount is not null 
and  c.buy_unum is not null 
and  c.buy_amount is not null 




