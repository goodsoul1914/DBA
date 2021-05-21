-- Show only user tasks that are waiting
---------------------------------------------------------------------------------------------------

select wt.waiting_task_address, 
	   wt.session_id, 
	   wt.exec_context_id, 
	   wt.wait_type, 
	   wt.wait_duration_ms, 
	   wt.resource_description
from sys.dm_os_waiting_tasks as wt
	 join sys.dm_exec_sessions as es on wt.session_id = es.session_id
										and es.is_user_process = 1;
go