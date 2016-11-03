-- 数据源(data_source/)

identity_address_province.csv -- 身份证对应省份查询
identity_address_city.csv -- 身份证对应城市查询
ip_address_city.csv --ip对应地址查询表
telephone_address_city.csv -- 手机归属信息查询
GeoLite2-City.mmdb -- ip数据查询库
ip_address_obtain_by_geoip.py -- 根据geoip开源数据库（data_base/GeoLite2-City.mmdb）查询ip对应省地址
ip_address_obtain_by_http.py -- 根据网页查询ip归属，每秒钟限制查询5次

-- 基础数据表(create_base_table/)
t_user_tag_static.sql --用户静态属性表，包含38个标签
t_telephone_details.sql -- 电话号码查询表,根据电话号码查询区域卡类型等信息 （2016年3月数据）
t_identity_authentication.sql -- 身份证对应地址查询表，通过身份证前6位查找对应区域（2015年7月国家数据中心）
t_ip_address.sql -- ip查询对应城市表，包含起始地址和结束地址 （百度文库）
t_ip_address_convert.sql  -- 将ip地址转化为数值形式，方便匹配ip值所对应城市表
t_user_ip_details.sql  -- 用户ip的详细信息

-- t_user_tag_static数据来源(data_extract/)
user_static_attribute_delivery_address.sql -- 用户收获地址存储过程
user_static_attribute_basic.sql -- 用户基础属性存储过程
user_static_attribute_identity.sql -- 用户身份属性存储过程
user_static_attribute_pay.sql -- 支付信息存储过程
user_static_attribute_register.sql --注册等信息存储过程

------------------------------------------------------------------------
t_user_tag_static数据来源说明

t_user （id,昵称，签名，性别，电话，user_type+usage_status(整合冻结用户以及沙箱和内部账户))
10-普通用户 11-优惠用户 12-机器人用户 13-年会用户  14-子用户 21-VIP1 22-VIP2 23-VIP3 24-至尊VIP
`GROUP_TYPE` INT(4) NULL DEFAULT '0' COMMENT '分组类型 0-无 1-苹果沙箱用户 2-公司员工',
冻结的用户，usage_status=11
user_sex:0:其他 1:男 2:女
专家等级：非专家，为0，是为1

t_user_address 地址（省市）
t_third_pay_log 支付方式
t_expert_apply 真实名字，身份证件（去空字符串），邮箱，年龄，银行张卡，卡类型，。。。

t_user_event 注册信息，注册版本号，注册渠道编号，操作系统，手机名称
t_mobile_location 注册手机地址
t_device_info 注册手机型号


收入情况（暂无）
但是可以通过投注充值等行为初步分析

受教育程度（暂无）

婚姻状态（暂无）

-- 

余额（钻石，金币，体验币）
oracle 里面的 t_account_item_snap 