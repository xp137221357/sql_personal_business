CREATE DEFINER=`report`@`%` FUNCTION `func_getAllSonUser`(`rootId` VARCHAR(20), `userlevel` VARCHAR(20))
	RETURNS mediumtext CHARSET utf8
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN     
DECLARE sTempChd MEDIUMTEXT;    
DECLARE temp MEDIUMTEXT;    
DECLARE currentLevel int(7);    
DECLARE allTemp MEDIUMTEXT;              
SET sTempChd =cast(rootId as CHAR);     
SET currentLevel = 1;    
SET temp = '-1';    
SET allTemp = '-1';         	
WHILE sTempChd is not null DO				
SET allTemp = concat(allTemp,',',sTempChd);
if userlevel < 0  			
then  				
SET temp = concat(temp,',',sTempChd); 		
end if;		 		
if currentLevel >= userlevel and userlevel > 0 			
then  			
SET temp = concat(temp,',',sTempChd); 		
end if;    	
SET currentLevel = currentLevel + 1;       	 	
SELECT group_concat(REF_ID) INTO sTempChd FROM game.T_GROUP_REF WHERE FIND_IN_SET(LAST_ID,sTempChd)>0 and FIND_IN_SET(REF_ID,allTemp) <= 0; 
END WHILE;    
RETURN temp;   
END