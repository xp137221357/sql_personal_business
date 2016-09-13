set @beginTime='2016-08-10';
set @endTime = '2016-08-16';
set @num = '5';

delimiter $$
drop procedure if exists pro10119;
CREATE PROCEDURE pro10119()
begin
  DECLARE i INT;
  SET i=0;
  WHILE i<5 do
  SET i=i+1;
  select '1' as i;
end WHILE;
end $$　　　　　

call pro10119();

