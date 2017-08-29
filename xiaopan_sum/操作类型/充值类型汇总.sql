
-- 充值汇总

-- 官方app：
BUY_DIAMEND
-- 网银： 
ai.ITEM_EVENT = 'ADMIN_USER_OPT' and ai.COMMENTS like '%网银充值%' 
-- 线下： 
ai.ITEM_EVENT = 'BUY_DIAMEND' and ai.COMMENTS '%underline%'
-- 金币： 
ai.ITEM_EVENT=BUY_DIAMEND and ai.comments like '%"buy_coins":1%'
ai.ITEM_EVENT = 'ADMIN_USER_OPT' and ai.COMMENTS like '%购买金币%'
-- 钻石： 
ai.ITEM_EVENT=BUY_DIAMEND or ai.comments not like '%"buy_coins":1%'
ai.ITEM_EVENT = 'ADMIN_USER_OPT' and ai.COMMENTS like '%购买钻石%'

-- 区分金币钻石：
金币：ref_item_id~item_id
钻石：ref_item_id=-1

-- 第三方：
答题
赠送


-- 支付方式:

CASE
     WHEN ai.item_src = 3 THEN '微信'
     WHEN ai.item_src = 4 THEN '支付宝'
     WHEN ai.item_src =9 THEN '苹果'
     WHEN ai.item_src = 10 THEN '苹果沙箱'
     WHEN ai.item_src = 11 THEN '百度支付'
     WHEN ai.item_src = 0 THEN '系统'
     WHEN ai.item_src = 6 THEN '银行卡'
     ELSE ai.item_src
end     AS item_src;