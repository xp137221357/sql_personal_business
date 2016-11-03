# coding: utf-8
__author__ = 'xiaopan'

import urllib2
import time
import re
import sys
import pymysql

reload(sys)
sys.setdefaultencoding('UTF-8')

def http_get(ip):
    url='http://freeapi.ipip.net/'+ip
    response = urllib2.urlopen(url)
    return response.read()

conn = pymysql.connect(host='192.168.88.11', user='forum', passwd='a', db='forum', port=3306,charset='utf8')
cur = conn.cursor()
cur.execute("select count(1) from test.t_stat_ip_test t ")
list = cur.fetchall()

for i in range(list[0][0]/1000+1):
    index_num=str(i*1000)
    cur.execute("select ip from test.t_stat_ip_test t limit "+index_num +",1000 ")
    ipList = cur.fetchall()
    sql_select=''
    i=0
    for ip in ipList:
        time.sleep(0.2)
        resulCountry=''
        resultProvince=''
        resultCity=''
        resultOperators=''
        i=i+1
        try:
            ret = http_get(ip[0])
            ret = str(ret).replace('[','').replace(']','').replace('"','').replace(',,',',')
            resulCountry= ret.split(",")[0].decode('UTF-8')
            resultProvince= ret.split(",")[1].decode('UTF-8')
            resultCity= ret.split(",")[2].decode('UTF-8')
            resultOperators= ret.split(",")[3].decode('UTF-8')
        except Exception,e:
            ret=''
            print Exception,":",e
        if(ipList[len(ipList)-1][0]!=ip[0]):
            sql_select=sql_select+" select user_id,ip,'"\
                       +resulCountry\
                       +"','"+resultProvince\
                       +"','"+resultCity\
                       +"','"+resultOperators\
                       +"' from test.t_stat_ip_test where ip= '"\
                       + ip[0] +"' union all "
        else:
            sql_select=sql_select+" select user_id,ip,'"\
                       +resulCountry+"','"\
                       +resultProvince+"','"\
                       +resultCity+"','"\
                       +resultOperators\
                       +"' from test.t_stat_ip_test where ip= '"+ ip[0] +"' "
    sql_content="insert INTO test.t_stat_ip_test (user_id,ip,country,province,city,operators)"+sql_select\
                +" on duplicate key update country = values(country),"\
                +"province = values(province),"\
                +"city = values(city),"\
                +"operators = values(operators)"
    print "sql_content="+sql_content
    cur.execute(sql_content)
    conn.commit()

cur.close()
conn.close()
