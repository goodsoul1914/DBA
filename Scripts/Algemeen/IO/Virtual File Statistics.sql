-- Virtual file statistics.
--------------------------------------------------------------------------------------------------
SELECT DB_NAME (vfs.database_id) AS "database_name",
       vfs.database_id,
       vfs.file_id,
       io_stall_read_ms / NULLIF(num_of_reads, 0) AS "avg_read_latency",
       io_stall_write_ms / NULLIF(num_of_writes, 0) AS "avg_write_latency",
       io_stall_write_ms / NULLIF(num_of_writes + num_of_writes, 0) AS "avg_total_latency",
       num_of_bytes_read / NULLIF(num_of_reads, 0) AS "avg_bytes_per_read",
       num_of_bytes_written / NULLIF(num_of_writes, 0) AS "avg_bytes_per_write",
       vfs.io_stall,
       vfs.num_of_reads,
       vfs.num_of_bytes_read,
       vfs.io_stall_read_ms,
       vfs.num_of_writes,
       vfs.num_of_bytes_written,
       vfs.io_stall_write_ms,
       size_on_disk_bytes / 1024 / 1024. AS "size_on_disk_mbytes",
       physical_name
FROM sys.dm_io_virtual_file_stats (NULL, NULL) AS vfs
JOIN sys.master_files AS mf
    ON vfs.database_id = mf.database_id
       AND vfs.file_id = mf.file_id
ORDER BY avg_total_latency DESC;
GO

-- Virtual File stats
--
-- Who has file handles memorized? :-)
-- Use this script, based on code from Jimmy May
-- This is what I use on client systems
-- Displays definition of indexes in the current database
--------------------------------------------------------------------------------------------------
SELECT *
FROM sys.dm_io_virtual_file_stats (NULL, NULL);
GO

SELECT CASE
           WHEN num_of_reads = 0 THEN 0
           ELSE io_stall_read_ms / num_of_reads
       END AS "ReadLatency", --virtual file latency
       CASE
           WHEN num_of_writes = 0 THEN 0
           ELSE io_stall_write_ms / num_of_writes
       END AS "WriteLatency",
       CASE
           WHEN num_of_reads = 0
                AND num_of_writes = 0 THEN 0
           ELSE io_stall / (num_of_reads + num_of_writes)
       END AS "Latency",
       CASE
           WHEN num_of_reads = 0 THEN 0
           ELSE num_of_bytes_read / num_of_reads
       END AS "AvgBPerRead", --avg bytes per IOP
       CASE
           WHEN io_stall_write_ms = 0 THEN 0
           ELSE num_of_bytes_written / num_of_writes
       END AS "AvgBPerWrite",
       CASE
           WHEN num_of_reads = 0
                AND num_of_writes = 0 THEN 0
           ELSE (num_of_bytes_read + num_of_bytes_written) / (num_of_reads + num_of_writes)
       END AS "AvgBPerTransfer",
       LEFT(mf.physical_name, 2) AS "Drive",
       DB_NAME (vfs.database_id) AS "DB",
       vfs.*,
       mf.physical_name
FROM sys.dm_io_virtual_file_stats (NULL, NULL) AS vfs
JOIN sys.master_files AS mf
    ON vfs.database_id = mf.database_id
       AND vfs.file_id = mf.file_id
WHERE vfs.file_id = 2 -- log files
-- ORDER BY [Latency] DESC
-- ORDER BY [ReadLatency] DESC
ORDER BY WriteLatency DESC;

-- Setup the slow log
-- Run 100 clients
-- Re-run the DMV query
-- Compare with using the DMV query above
-- What about pending IOs? 

SELECT *
FROM sys.dm_io_pending_io_requests;
GO

-- And a bit more useful

SELECT DB_NAME (vfs.database_id) AS "DBName",
       mf.name AS "FileName",
       mf.type_desc AS "FileType",
       pior.io_type,
       pior.io_offset,
       pior.io_pending_ms_ticks
FROM sys.dm_io_pending_io_requests AS pior
JOIN sys.dm_io_virtual_file_stats (NULL, NULL) AS vfs
    ON vfs.file_handle = pior.io_handle
JOIN sys.master_files AS mf
    ON mf.database_id = vfs.database_id
       AND mf.file_id = vfs.file_id
WHERE pior.io_pending = 1
ORDER BY pior.io_offset;

-- Execute a few times to see offset moving
-- See 32 for log file IO cap
-- And now grouped together

SELECT COUNT (*) AS "PendingIOs",
       DB_NAME (vfs.database_id) AS "DBName",
       mf.name AS "FileName",
       mf.type_desc AS "FileType",
       SUM (pior.io_pending_ms_ticks) AS "TotalStall"
FROM sys.dm_io_pending_io_requests AS pior
JOIN sys.dm_io_virtual_file_stats (NULL, NULL) AS vfs
    ON vfs.file_handle = pior.io_handle
JOIN sys.master_files AS mf
    ON mf.database_id = vfs.database_id
       AND mf.file_id = vfs.file_id
WHERE pior.io_pending = 1
GROUP BY vfs.database_id,
         mf.name,
         mf.type_desc
ORDER BY vfs.database_id,
         mf.name;

-- Execute a few times to see some data writes from a checkpoint