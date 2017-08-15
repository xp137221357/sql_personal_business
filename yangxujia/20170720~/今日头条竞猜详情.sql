select u.USER_CODE from t_stat_first_recharge_coin t 
inner join forum.t_user u on u.USER_ID=t.USER_ID
inner join report.t_trans_user_attr tu on tu.USER_ID=t.USER_ID and tu.CHANNEL_NO='jrtt-jingcai';



select u.NICK_NAME,u.USER_ID,u.ACCT_NUM,
sum(o.COIN_BUY_MONEY) bet_coins,
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins 
from game.t_order_item o
inner join forum.t_user u on o.USER_ID=u.USER_CODE
inner join report.t_trans_user_attr tu on tu.USER_ID=u.USER_ID
inner join report.t_stat_first_recharge_coin tf on  tf.USER_ID=tu.USER_ID and tu.CHANNEL_NO='jrtt-jingcai'
where o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
group by o.USER_ID;





select u.NICK_NAME,u.USER_ID,u.ACCT_NUM,
sum(o.COIN_BUY_MONEY) bet_coins,
ifnull(sum(o.COIN_PRIZE_MONEY),0)+ifnull(sum(o.COIN_RETURN_MONEY),0) prize_coins 
from game.t_order_item o
inner join forum.t_user u on o.USER_ID=u.USER_CODE
and u.USER_ID in (
'2563551',
'2563755',
'2595240',
'2645211',
'2789253',
'2796612',
'2842287',
'2891244',
'2947827',
'2962545',
'2979618',
'3000495',
'3017301',
'3046476',
'3150927',
'3162144',
'3163371',
'3207795',
'3278649',
'3320334',
'3430158',
'3494808',
'3520227',
'3560277',
'3590271',
'3655473',
'3760833',
'3768207',
'3777537',
'3845556',
'3947559',
'4075122',
'4083789',
'4251747',
'4314045',
'4590576',
'4643151',
'4671705',
'4678284',
'4683573',
'4710639',
'4717332',
'4728330',
'4754034',
'4797600',
'4837413',
'4840797',
'4857006',
'4955988',
'5049711',
'5068635',
'5089131',
'5167779',
'5538999',
'5559816',
'5612430',
'5794551',
'5964684',
'6017754',
'6050091',
'6068079',
'6475344',
'6495624',
'6634134',
'6674625',
'6678837',
'6862503',
'6967884',
'7096404',
'7140384',
'7231311',
'7329651',
'7404912',
'7578372',
'7669290',
'7722825',
'7772244',
'7776255',
'8236233',
'8294190',
'8394273',
'8519994',
'8606454',
'8710287',
'8875101',
'8919780',
'8937639',
'9065532',
'9223767',
'9227418',
'9649149',
'9656187',
'10709391',
'10714002',
'10729611',
'10748946'
) 
where o.ITEM_STATUS not in (-5,-10,210)
and o.COIN_BUY_MONEY>0
group by o.USER_ID;