set @beginTime='2016-07-18';
set @endTime = '2016-07-24 23:59:59';

select '所有合计',
tt.stat_time '日期',
tt.LAUNCH_RECOM_USERS '发起推荐人数',
tt.recom_project_counts '推荐次数',
tt.charge_project_counts '推荐收费场次',
tt.BUY_USERS '购买人数',
tt.BUY_COUNTS '购买次数',
tt.cost '购买金额',
if(tt.BUY_COUNTS>0,tt.cost/tt.BUY_COUNTS,0) '平均购买金额',
tt.SITE_INCOME '网站收入',
tt.RECOM_INCOME '稿费支出'
 from (
SELECT stat_time,
       (SELECT Count(DISTINCT d.user_id)
        FROM   t_match_recom d
        WHERE  Date_format(d.crt_time, '%x%v') = f.stat_time)      AS
       LAUNCH_RECOM_USERS,
       recom_project_counts,
       charge_project_counts,
       (SELECT Count(DISTINCT t.user_id)
        FROM   t_user_match_recom t
               INNER JOIN t_user o
                       ON t.user_id = o.user_id
                          AND o.group_type IN( 0, 2 )
                          AND o.client_id = 'BYAPP'
        WHERE  t.pay_status = 10
               AND t.money > 0
               AND Date_format(t.crt_time, '%x%v') = f.stat_time)  AS BUY_USERS
       ,
       (SELECT Count(1)
        FROM   t_user_match_recom t
               INNER JOIN t_user o
                       ON t.user_id = o.user_id
                          AND o.group_type IN( 0, 2 )
                          AND o.client_id = 'BYAPP'
        WHERE  t.pay_status = 10
               AND t.money > 0
               AND Date_format(t.crt_time, '%x%v') = f.stat_time)  AS
       BUY_COUNTS,
       cost,
       Round(site_income, 2)                                        AS
       SITE_INCOME,
       Round(recom_income, 2)                                       AS
       RECOM_INCOME
       
FROM   (SELECT Date_format(add_date, '%x%v')        AS STAT_TIME,
               Ifnull(Sum(launch_recom_users), 0)    AS LAUNCH_RECOM_USERS,
               Ifnull(Sum(recom_project_counts), 0)  AS RECOM_PROJECT_COUNTS,
               Ifnull(Sum(charge_project_counts), 0) AS CHARGE_PROJECT_COUNTS,
               Ifnull(Sum(buy_users), 0)             AS BUY_USERS,
               Ifnull(Sum(buy_counts), 0)            AS BUY_COUNTS,
               Ifnull(Sum(recom_income), 0)          AS RECOM_INCOME,
               Ifnull(Sum(site_income), 0)           AS SITE_INCOME,
               Ifnull(Sum(cost), 0)                  AS COST       
        FROM   t_expert_stat_recom
        WHERE  Date_format(add_date,'%x%v') >= date_format(@beginTime,'%x%v')   
               AND Date_format(add_date,'%x%v') <= date_format(@endTime,'%x%v')   
        GROUP  BY stat_time
        ORDER  BY stat_time ASC) f 
) tt;