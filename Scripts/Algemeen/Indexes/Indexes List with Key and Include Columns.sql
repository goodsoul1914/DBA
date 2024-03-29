/* 
Script By: Aasim Abdullah for http://connectsql.blogspot.com 
Get all indexes list with key columns and include columns as well as usage statistics 
*/
SELECT '[' + Sch.name + '].[' + Tab.[name] + ']' AS TableName,
	Ind.type_desc,
	Ind.[name] AS IndexName,
	SUBSTRING((
			SELECT ', ' + AC.name
			FROM sys.[tables] AS T
			INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id]
			INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id]
				AND I.[index_id] = IC.[index_id]
			INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id]
				AND IC.[column_id] = AC.[column_id]
			WHERE Ind.[object_id] = I.[object_id]
				AND Ind.index_id = I.index_id
				AND IC.is_included_column = 0
			ORDER BY IC.key_ordinal
			FOR XML PATH('')
			), 2, 8000) AS KeyCols,
	SUBSTRING((
			SELECT ', ' + AC.name
			FROM sys.[tables] AS T
			INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id]
			INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id]
				AND I.[index_id] = IC.[index_id]
			INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id]
				AND IC.[column_id] = AC.[column_id]
			WHERE Ind.[object_id] = I.[object_id]
				AND Ind.index_id = I.index_id
				AND IC.is_included_column = 1
			ORDER BY IC.key_ordinal
			FOR XML PATH('')
			), 2, 8000) AS IncludeCols,
	usg_stats.user_seeks AS UserSeek,
	usg_stats.user_scans AS UserScans,
	usg_stats.user_lookups AS UserLookups,
	usg_stats.user_updates AS UserUpdates
FROM sys.[indexes] AS Ind
INNER JOIN sys.[tables] AS Tab ON Tab.[object_id] = Ind.[object_id]
INNER JOIN sys.[schemas] AS Sch ON Sch.[schema_id] = Tab.[schema_id]
LEFT OUTER JOIN sys.dm_db_index_usage_stats AS usg_stats ON Ind.index_id = usg_stats.index_id
	AND Ind.[OBJECT_ID] = usg_stats.[OBJECT_ID]
	AND usg_stats.database_id = DB_ID()
WHERE Ind.type_desc <> 'HEAP'
--AND Tab.name = 'YourTableNameHere' -- uncomment to get single table indexes detail 
ORDER BY TableName
