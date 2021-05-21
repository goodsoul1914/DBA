-- Query 17 - Instance Configuration Properties
-- Get configuration values for instance  (Query 17) (Configuration Values)

select name, 
	   value, 
	   value_in_use, 
	   minimum, 
	   maximum, 
	   description, 
	   is_dynamic, 
	   is_advanced
from sys.configurations with(nolock)
order by name option(recompile);

/*
Focus on:
- backup compression default (should be 1 in most cases)
- cost threshold for parallelism
- clr enabled (only enable if it is needed)
- lightweight pooling (should be zero)
- max degree of parallelism 
- max server memory (MB) (set to an appropriate value)
- optimize for ad hoc workloads (should be 1)
- priority boost (should be zero)
*/