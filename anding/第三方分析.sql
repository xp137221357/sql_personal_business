select date_format(rc.crt_time,'%Y-%v'),
count(distinct rc.charge_user_id), 
sum(rc.rmb_value)
 from t_trans_user_recharge_coin rc where rc.charge_method in ('APP') group by date_format(rc.crt_time,'%Y-%v');
 
 
 
 ## 第三方账号的官充
select date_format(rc.crt_time,'%Y-%v'),
sum(rc.rmb_value),
sum(rc.coins)
 from t_trans_merchant_recharge_coin rc  group by date_format(rc.crt_time,'%Y-%v');
 
 
 ## 第三方账号的售币
select concat(subdate(date(rc.crt_time),date_format(rc.crt_time,'%w')-1),' - ',subdate(date(rc.crt_time),date_format(rc.crt_time,'%w')-7)),
count(1),
sum(rc.coins),
round(sum(rc.coins) / 140)
 from t_trans_user_recharge_coin rc group by date_format(rc.crt_time,'%Y-%v');
 
 
## 第三方账号的收币
select concat(subdate(date(rc.crt_time),date_format(rc.crt_time,'%w')-1),' - ',subdate(date(rc.crt_time),date_format(rc.crt_time,'%w')-7)),
count(1),
sum(rc.coins),
round(sum(rc.coins) / 140)
 from t_trans_user_withdraw rc group by date_format(rc.crt_time,'%Y-%v');


select * from t_trans_user_withdraw;

select concat(subdate(curdate(),date_format(curdate(),'%w')-1),' - ',subdate(curdate(),date_format(curdate(),'%w')-7))