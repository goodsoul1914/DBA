SELECT @@TRANCOUNT;


BEGIN TRAN;
BEGIN TRAN;
BEGIN TRAN;
COMMIT;
SELECT @@TRANCOUNT;
