 -- vip用户
 select user_id from report.v_user_boss
 
 -- 新户
 
 select user_id from report.v_user_new vn where vn.crt_time >='2016-09-01' and vn.crt_time <='2016-09-10'
 
 -- 留存用户
 
 select user_id from report.v_user_old vo where vo.crt_time <='2016-09-01' 
 
  -- 大户
 select t.user_id from (
 select user_id from (
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
 GROUP  BY t.charge_user_id) tt WHERE tt.rmb_value>2000 )t
 
 -- 留存大户
 select t.user_id from (
 select user_id from (
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
 GROUP  BY t.charge_user_id) tt WHERE tt.rmb_value>=2000 )t
 left join report.v_user_boss vb on vb.USER_ID = t.user_id
 left join report.v_user_new vn on vn.USER_ID=t.user_id and vn.crt_time >='2016-09-01' and vn.crt_time <='2016-09-10'
 where vb.USER_ID is null and vn.USER_ID is null
 
  -- 留存普通用户
 select t.user_id from (
 select user_id from (
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
 GROUP  BY t.charge_user_id) tt WHERE tt.rmb_value<2000 )t
 left join report.v_user_boss vb on vb.USER_ID = t.user_id
 left join report.v_user_new vn on vn.USER_ID=t.user_id and vn.crt_time >='2016-09-01' and vn.crt_time <='2016-09-10'
 where vb.USER_ID is null and vn.USER_ID is null