﻿SELECT TOP (50) DB_NAME (t.dbid) AS "Database Name",
                t.text AS "Query Text",
                cp.objtype AS "Object Type",
                cp.cacheobjtype AS "Cache Object Type",
                cp.size_in_bytes / 1024 AS "Plan Size in KB"
FROM sys.dm_exec_cached_plans AS cp WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text (plan_handle) AS t
WHERE cp.cacheobjtype = N'Compiled Plan'
      AND cp.objtype IN ( N'Adhoc', N'Prepared' )
      AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC,
         DB_NAME (t.dbid)
OPTION (RECOMPILE);
