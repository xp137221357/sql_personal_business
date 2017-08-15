BEGIN

DECLARE ssql VARCHAR(1000);
DECLARE totalrows BIGINT(19);

SET @rownums=0;
select count(1) into totalrows from forum.t_user u where u.CLIENT_ID='byapp';
SET ssql="
   insert into t_stat_user_items_total_data(USER_ID,ITEM_EVENT,ACCT_TYPE,CHANGE_VALUE)
	select ai.user_id,ai.ITEM_EVENT,ai.ACCT_TYPE,sum(ai.CHANGE_VALUE) CHANGE_VALUE 
	from forum.t_acct_items ai
	where ai.USER_ID =(select u.USER_ID from forum.t_user u where u.CLIENT_ID='byapp' limit ?,1)
	and ai.pay_time<'2017-07-21'
	group by ai.ITEM_EVENT,ai.ACCT_TYPE
	on duplicate key update 
	CHANGE_VALUE = values(CHANGE_VALUE);
	";
	
while @rownums<totalrows do
	SET @SQUERY=ssql;
	PREPARE STMT FROM @SQUERY;
	EXECUTE STMT USING @rownums;
	SET @rownums=@rownums+1;
end while;

END