-- ����Դ(data_source/)

identity_address_province.csv -- ���֤��Ӧʡ�ݲ�ѯ
identity_address_city.csv -- ���֤��Ӧ���в�ѯ
ip_address_city.csv --ip��Ӧ��ַ��ѯ��
telephone_address_city.csv -- �ֻ�������Ϣ��ѯ
GeoLite2-City.mmdb -- ip���ݲ�ѯ��
ip_address_obtain_by_geoip.py -- ����geoip��Դ���ݿ⣨data_base/GeoLite2-City.mmdb����ѯip��Ӧʡ��ַ
ip_address_obtain_by_http.py -- ������ҳ��ѯip������ÿ�������Ʋ�ѯ5��

-- �������ݱ�(create_base_table/)
t_user_tag_static.sql --�û���̬���Ա�����38����ǩ
t_telephone_details.sql -- �绰�����ѯ��,���ݵ绰�����ѯ�������͵���Ϣ ��2016��3�����ݣ�
t_identity_authentication.sql -- ���֤��Ӧ��ַ��ѯ��ͨ�����֤ǰ6λ���Ҷ�Ӧ����2015��7�¹����������ģ�
t_ip_address.sql -- ip��ѯ��Ӧ���б�������ʼ��ַ�ͽ�����ַ ���ٶ��Ŀ⣩
t_ip_address_convert.sql  -- ��ip��ַת��Ϊ��ֵ��ʽ������ƥ��ipֵ����Ӧ���б�
t_user_ip_details.sql  -- �û�ip����ϸ��Ϣ

-- t_user_tag_static������Դ(data_extract/)
user_static_attribute_delivery_address.sql -- �û��ջ��ַ�洢����
user_static_attribute_basic.sql -- �û��������Դ洢����
user_static_attribute_identity.sql -- �û�������Դ洢����
user_static_attribute_pay.sql -- ֧����Ϣ�洢����
user_static_attribute_register.sql --ע�����Ϣ�洢����

------------------------------------------------------------------------
t_user_tag_static������Դ˵��

t_user ��id,�ǳƣ�ǩ�����Ա𣬵绰��user_type+usage_status(���϶����û��Լ�ɳ����ڲ��˻�))
10-��ͨ�û� 11-�Ż��û� 12-�������û� 13-����û�  14-���û� 21-VIP1 22-VIP2 23-VIP3 24-����VIP
`GROUP_TYPE` INT(4) NULL DEFAULT '0' COMMENT '�������� 0-�� 1-ƻ��ɳ���û� 2-��˾Ա��',
������û���usage_status=11
user_sex:0:���� 1:�� 2:Ů
ר�ҵȼ�����ר�ң�Ϊ0����Ϊ1

t_user_address ��ַ��ʡ�У�
t_third_pay_log ֧����ʽ
t_expert_apply ��ʵ���֣����֤����ȥ���ַ����������䣬���䣬�����ſ��������ͣ�������

t_user_event ע����Ϣ��ע��汾�ţ�ע��������ţ�����ϵͳ���ֻ�����
t_mobile_location ע���ֻ���ַ
t_device_info ע���ֻ��ͺ�


������������ޣ�
���ǿ���ͨ��Ͷע��ֵ����Ϊ��������

�ܽ����̶ȣ����ޣ�

����״̬�����ޣ�

-- 

����ʯ����ң�����ң�
oracle ����� t_account_item_snap 