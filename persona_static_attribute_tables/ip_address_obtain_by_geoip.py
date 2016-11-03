# coding: utf-8
__author__ = 'xiaopan'

import geoip2.database
import pymysql
import math

conn = pymysql.connect(host='192.168.88.11', user='forum', passwd='a', db='forum', port=3306,charset='utf8')
cur = conn.cursor()
cur.execute("select count(1) from test.t_stat_ip_test t ")

list = cur.fetchall()
reader = geoip2.database.Reader('D:\data_casch\GeoLite2-City.mmdb')

for i in range(list[0][0]/1000+1):
    index_num=str(i*1000)
    cur.execute("select ip from test.t_stat_ip_test t limit "+index_num +",1000 ")
    ipList = cur.fetchall()
    sql_select=''
    i=0
    for ip in ipList:
        city_name=''
        i=i+1
        try:
            response = reader.city(ip[0])
            city_name=response.city.name
        except Exception,e:
            city_name=''
            print Exception,":",e
        if(city_name==None):
            city_name=''
        # city_name=city_name.replace("'",' ') #很慢
        # if(ipList[len(ipList)-1][0]!=ip[0]):
        #     sql_content=sql_content+" select ip,'"+city_name+"' from test.t_stat_ip_test where ip= '"+ ip[0] +"' union all "
        # else:
        #     sql_content=sql_content+" select ip,'"+city_name+"' from test.t_stat_ip_test where ip= '"+ ip[0] +"' "
        if(ipList[len(ipList)-1][0]!=ip[0]):
            sql_select=sql_select+' select ip,"'\
                       +city_name\
                       +'" from test.t_stat_ip_test where ip= "'\
                       + ip[0] +'" union all '
        else:
            sql_select=sql_select+' select ip,"'+city_name+'" from test.t_stat_ip_test where ip= "'+ ip[0] +'" '
    sql_content="insert INTO test.t_stat_ip_test (ip,city_name)"\
                +sql_content\
                +" on duplicate key update city_name = values(city_name)"
    print "sql_content="+sql_content
    cur.execute(sql_content)
    conn.commit()

cur.close()
conn.close()

