if exists(select 1 from sys.sysforeignkey where role='FK_T_ORDER__REFERENCE_T_ORDER') then
    alter table T_ORDER_ITEM
       delete foreign key FK_T_ORDER__REFERENCE_T_ORDER
end if;

drop table if exists T_ORDER_ITEM;

/*==============================================================*/
/* Table: T_ORDER_ITEM                                          */
/*==============================================================*/
create table T_ORDER_ITEM 
(
   ITEM_ID              varchar(50)                    not null,
   ORDER_ID             varchar(50)                    null,
   USER_ID              varchar(50)                    null,
   ITEM_CONTENT         varchar(4000)                  null,
   BUY_TYPE             int(2)                         null,
   PLAY_TYPE            int(2)                         null,
   PLAY_ID              varchar(30)                    null,
   LOT_ID               varchar(20)                    null,
   ITEM_MONEY           numeric(20,4)                  null,
   CURRENT_CONTENT      varchar(500                    null,
   ITEM_STATUS          int(3)                         null,
   PRIZE_MONEY          numeric(20,4)                  not null,
   PRIZETAX_MONEY       numeric(20,4)                  not null,
   RETURN_MONEY         numeric(20,4)                  null,
   RETURN_TIME          timestamp                      null,
   PRIZE_TIME           timestamp                      null,
   CRT_TIME             timestamp                      null,
   UPDATE_TIME          timestamp                      null,
   PAY_TIME             timestamp                      null,
   BALANCE_MATCH_ID     varchar(50)                    null,
   PASS_TYPE            varchar(10)                    null,
   IS_INPLAY            int(1)                         null,
   SRC_CODE             varchar(50)                    null default 'DEFAULT',
   BALANCE_EXPECT       varchar(20)                    null,
   BALANCE_MONEY        numeric(20,4)                  null,
   BALANCE_STATUS       int(2)                         null,
   BALANCE_TIME         datetime                       null,
   ORDER_TYPE           varchar(5)                     null,
   COIN_BUY_MONEY       numeric(20,4)                  null,
   P_COIN_BUY_MONEY     numeric(20,4)                  null,
   COIN_PRIZE_MONEY     numeric(20,4)                  null,
   P_COIN_PRIZE_MONEY   numeric(20,4)                  null,
   COIN_RETURN_MONEY    numeric(20,4)                  null,
   P_COIN_RETURN_MONEY  numeric(20,4)                  null,
   COIN_ARRIVAL_MONEY   numeric(20,4)                  null,
   P_COIN_ARRIVAL_MONEY numeric(20,4)                  null,
   ARRIVAL_MONEY        numeric(20,4)                  null,
   constraint PK_T_ORDER_ITEM primary key clustered (ITEM_ID)
);

comment on column T_ORDER_ITEM.ITEM_CONTENT is 
'{
	"token":"",
	"data":{
		//过关方式  单关:1001  二串一:2001  三串四:3004等
		"s_type":"",
		//彩种id
		"lot_id":"",
		//总金额
		"total_money":"",
		//赛前玩法:70199(混投)
		//全场:70101(欧赔胜平负),70102(亚盘胜负),70103(比分),70104(大小球)
		//半场:70111(欧赔胜平负),70112(亚盘胜负),70113(比分),70114(大小球)
		//走地玩法:
		//全场:70130(角球数),70131(罚牌数),70132(下一个进球)
		//半场:70140(角球数),70141(罚牌数),70142(下一个进球)
		"p_id":"",
		//投注内容
		"codes":"",
		"item":[
			{
			//赛程ID
			"m_id":"",
			//赔率
			"odds":"",
			//投注内容
			//欧赔胜平负(3(胜)|1(平)|0(负)),亚盘胜负(3(胜)|0(负)),比分(?(主队分):?(客队分)),大小球(1(大)|0(小)
			//角球数(?),罚牌数(?),下一个进球(1(主)|0(客))
			"codes":"",
			//让球值
			"let_ball":"",
			//投注类型 0:混合 1:欧赔 2:大小球 3:亚盘 4:竞彩
			"buy_type":"1",
			//玩法,混投时才有
			"p_id":"70101",
			//玩法类型:10:半场 20:全场
			"p_type":"10",
			//购买金额
			"buy_money":"",
			//0:是  1:否
			"is_inplay":"0"
		 }
		]
	}
}';

comment on column T_ORDER_ITEM.BUY_TYPE is 
'区分 欧赔、大小球、亚盘、竞彩
0:混合
1:欧赔
2:大小球
3:亚盘
4:竞彩
5:其他';

comment on column T_ORDER_ITEM.PLAY_TYPE is 
'区分 半场、全场
10:半场
20:全场';

comment on column T_ORDER_ITEM.PLAY_ID is 
'70101：全场欧赔胜平负
70102：全场亚盘胜负
70103：全场比分
70104：全场大小球
70105：全场总进球
70111：半场欧赔胜平负
70112：半场亚盘胜负
70113：半场比分
70114：半场大小球
70115：半场总进球
70130：全场角球数
70131：全场罚牌数
70133：全场进球单双
70140：半场角球数
70141：半场罚牌数
70143：半场进球单双
70150：半全场
70160：下一个进球';

comment on column T_ORDER_ITEM.CURRENT_CONTENT is 
'记录投注玩法的当前事件信息
如：
亚盘
胜负玩法,需记录当前的主客进球数.
算奖需根据该字段确定是否走盘';

comment on column T_ORDER_ITEM.ITEM_STATUS is 
'0:初始状态  
10:投注成功(待开奖)
-5:投注失败(退款中)
-10:投注失败
-100:未中奖
100:返奖中 
110:返奖成功  
120:走盘
130:输一半
140:赢一半
200:退款中
210:退款成功';

comment on column T_ORDER_ITEM.PRIZE_MONEY is 
'票中奖金额(税后)';

comment on column T_ORDER_ITEM.PRIZETAX_MONEY is 
'票中奖金额(税前)';

comment on column T_ORDER_ITEM.PASS_TYPE is 
'单关 1001
二串一 2001';

comment on column T_ORDER_ITEM.IS_INPLAY is 
'0:是  1:否';

comment on column T_ORDER_ITEM.BALANCE_STATUS is 
'0:初始  10:可结算  20:结算完成
-20 结算失败';

comment on column T_ORDER_ITEM.ORDER_TYPE is 
'支票订单:1000
其他订单:1001';

alter table T_ORDER_ITEM
   add constraint FK_T_ORDER__REFERENCE_T_ORDER foreign key (ORDER_ID)
      references T_ORDER (ORDER_ID)
      on update restrict
      on delete restrict;
