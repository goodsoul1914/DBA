/*
	CSIL - Columnstore Indexes Scripts Library for SQL Server 2014: 
	Columnstore Tests - cstore_GetAlignment is tested with the columnstore table containing 1 row in compressed row group and a Delta-Store with 1 row
	Version: 1.5.0, August 2017

	Copyright 2015-2017 Niko Neugebauer, OH22 IS (http://www.nikoport.com/columnstore/), (http://www.oh22.is/)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

IF NOT EXISTS (select * from sys.objects where type = 'p' and name = 'testRowGroupAndDelta' and schema_id = SCHEMA_ID('Alignment') )
	exec ('create procedure [Alignment].[testRowGroupAndDelta] as select 1');
GO

ALTER PROCEDURE [Alignment].[testRowGroupAndDelta] AS
BEGIN
	DROP TABLE IF EXISTS #ExpectedAlignment;

	create table #ExpectedAlignment(
		TableName nvarchar(256),
		Location varchar(15),
		Partition bigint,
		ColumnId int,
		ColumnName nvarchar(256),
		ColumnType nvarchar(256),
		SegmentElimination varchar(25) NOT NULL,
		PredicatePushdown varchar(25) NOT NULL,
		DealignedSegments int,
		TotalSegments int,
		SegmentAlignment Decimal(8,2)
	);

	select top (0) *
		into #ActualAlignment
		from #ExpectedAlignment;
	
	-- CCI
	-- Insert expected result
	insert into #ExpectedAlignment
		(TableName, Location, Partition, [ColumnId], ColumnName, ColumnType, [SegmentElimination], [PredicatePushdown], [DealignedSegments], [TotalSegments], SegmentAlignment)
		values 
		('[dbo].[RowGroupAndDeltaCCI]', 'Disk-Based', 1, 1, 'c1', 'int', 'OK', 'OK', 0, 1, 100.00 );

	insert into #ActualAlignment 
		exec dbo.cstore_GetAlignment @tableName = 'RowGroupAndDelta';

	exec tSQLt.AssertEqualsTable '#ExpectedAlignment', '#ActualAlignment';

END

GO
