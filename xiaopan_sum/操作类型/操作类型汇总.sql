
账务操作类型：
-- 充值
int opt_recharge=2
-- 预提现
int opt_pre_cash_out=3;
-- 提现
int opt_cash_out=4;
-- 转入资金
int opt_transfer_in=5;
-- 转出资金
int opt_transfer_out=6;
-- 第三方支付
int opt_thirdparty_pay=8;
-- 支付-出
int opt_pay=9;
-- 支付-进
int opt_pay_in=10;
-- 退款-出
int opt_refund=12;
-- 退款-进
int opt_refund_in=13;
-- 超级管理员或管理员转出资金(不做余额限制，可扣成负数)
int opt_admin_transfer_out=14;


投注操作类型：
game.t_order_item 里面的oder_id指的是订单号,item_id表示具体项目 id,pay_time 投注时间,balance_time计算时间
投注用的是order_id;返奖计算用的是item_id
0 订单未通过
10 初始状态
200 中间状态
-5  退款中
-10 已退款
210 退款成功
-100:未中奖
100:结算中 
110:已返奖
120:走盘
130:输一半
140:赢一半

无效状态：(-5,-10,0,10,200,210)

