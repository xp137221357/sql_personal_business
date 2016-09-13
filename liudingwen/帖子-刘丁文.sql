-- 帖子发布
-- t_circles_note
-- LOOK_UP_COUNT
-- NOTE_STATUS  0:正常 1:审核中  -1:失效 
-- NOTE_TYPE 
-- T_USER USER_TYPE!=12

/*
CREATE TABLE T_CIRCLES_NOTE
(
   NOTE_ID              BIGINT(19) NOT NULL,
   CIRCLES_ID           BIGINT(19),
   REF_ID               BIGINT(19) COMMENT '关系主键',
   NOTE_TITLE           VARCHAR(500),
   NOTE_CONTENT         TEXT,
   CRT_TIME             DATATIME,
   UPDATE_TIME          DATATIME,
   IS_TOP               INT(1) DEFAULT 0 COMMENT '1:是 0:否',
   IS_HOT               INT(1) DEFAULT 0 COMMENT '1:是 0:否',
   LOOK_UP_COUNT        BIGINT(19),
   COMMENT_COUNT        BIGINT(19),
   LAST_COMMENT_TIME    DATATIME,
   NOTE_STATUS          INT(3) COMMENT '0:正常 1:审核中  -1:失效',
   NOTE_PATH            VARCHAR(200),
   IS_ESSENCE           INT(1) DEFAULT 0 COMMENT '1:是 0:否',
   NOTE_INFO            VARCHAR(2000),
   NOTE_TYPE            INT(3) COMMENT '10:主题帖   20:跟帖',
   P_NOTE_ID            BIGINT(19),
   NOTE_ORDER           INT(5),
   IS_HOMEPAGE          SMALLINT COMMENT '1:是 0否,只针对置顶/精华/热帖的数据才能进行设置',
   PRIMARY KEY (NOTE_ID)
);
*/

set @beginTime ='2016-05-01 00:00:00';
set @endTime ='2016-05-31 23:59:59';
set @mon = '5月份';

select @mon,'帖子阅读量',sum(LOOK_UP_COUNT) '数量' 
from t_circles_note t where t.NOTE_STATUS =0 and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime

UNION ALL

select @mon,'用户发帖量' ,count(t.USER_ID) '数量' 
from t_circles_note t where t.NOTE_STATUS =0 and t.NOTE_TYPE=10 and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime

UNION ALL

select @mon,'用户回帖量' ,count(t.USER_ID) '数量' 
from t_circles_note t where t.NOTE_STATUS =0 and t.NOTE_TYPE=20 and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime

UNION ALL

select @mon,'扣除机器人发帖量',count(t.USER_ID) '数量' 
from t_circles_note t 
INNER JOIN T_USER U ON U.USER_ID = T.USER_ID AND U.CLIENT_ID='BYAPP' AND U.USER_TYPE!=12
where t.NOTE_STATUS =0 and t.NOTE_TYPE=20 and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime

UNION ALL

select @mon,'资讯阅读数' ,sum(t.CLICK_COUNT) '数量' 
from t_article t where t.ARTICLE_STATUS =3  and t.CRT_TIME>=@beginTime and t.CRT_TIME<=@endTime



 

