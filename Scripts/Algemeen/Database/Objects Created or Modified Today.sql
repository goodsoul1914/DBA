-- Get list of objects created or modified today	
---------------------------------------------------------------------------------------------------
CREATE TABLE #temp (
    dbname      sysname,
    name        sysname,
    TYPE        sysname,
    type_desc   sysname,
    create_date DATETIME,
    modify_date DATETIME
);

INSERT INTO #temp
EXEC sp_MSforeachdb 'IF(''?'' not in (''master'',''model'',''msdb'',''tempdb''))
	select db_name() ,name,type,type_desc,create_date,modify_date 
	from [?].sys.objects 
	where convert(char(10),modify_date,101) = convert(char(10),getdate(),101)';

SELECT *
FROM #temp
ORDER BY 1,
         2;

DROP TABLE #temp;
