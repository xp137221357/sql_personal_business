set @beginTime = '2016-01-01';
set @endTime = '2016-07-04';

select 
Concat(@beginTime, '~', @endTime)         '时间',
       '赠送',
       @invite_code '邀请码',
       tp.crt_time '日期',
       tu.NICK_NAME '赠送人',
       u.NICK_NAME '受赠人',
       Ifnull(Count(DISTINCT( tp.tuser_id )), 0) '人数',
       Ifnull(Sum(tp.money), 0)                  '金币数'
from forum.t_user_present tp
inner join forum.t_user u on u.USER_ID = tp.TUSER_ID  and u.NICK_NAME= '古城往事'
inner join forum.t_user tu on tu.USER_ID = tp.USER_ID 
WHERE  tp.status = 10
       AND tp.crt_time >= @beginTime
       AND tp.crt_time < @endTime
       group by date(tp.crt_time),tp.USER_ID
       ; 