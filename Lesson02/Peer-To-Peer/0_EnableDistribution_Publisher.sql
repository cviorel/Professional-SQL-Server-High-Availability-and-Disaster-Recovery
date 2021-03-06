-- Run on Publisher to enable distribution.
USE master
GO
EXEC sp_adddistributor 
  @distributor = N'NEPTUNE\SQL2014', 
  @password = N'' 

GO 

EXEC sp_adddistributiondb 
  @database = N'distribution', 
  @data_folder = 
  N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQL2014\MSSQL\Data', 
  @log_folder = 
  N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQL2014\MSSQL\Data', 
  @log_file_size = 2, 
  @min_distretention = 0, 
  @max_distretention = 72, 
  @history_retention = 48, 
  @security_mode = 1 

GO 

USE [distribution] 

IF ( NOT EXISTS (SELECT * 
                 FROM   sysobjects 
                 WHERE  NAME = 'UIProperties' 
                        AND type = 'U ') ) 
  CREATE TABLE uiproperties 
    ( 
       id INT 
    ) 

IF ( EXISTS (SELECT * 
             FROM   ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 
                    'table', 
                            'UIProperties', NULL, NULL)) ) 
  EXEC sp_updateextendedproperty 
    N'SnapshotFolder', 
    N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQL2014\MSSQL\ReplData', 
    'user', 
    dbo, 
    'table', 
    'UIProperties' 
ELSE 
  EXEC sp_addextendedproperty 
    N'SnapshotFolder', 
    N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQL2014\MSSQL\ReplData', 
    'user', 
    dbo, 
    'table', 
    'UIProperties' 

GO 

EXEC sp_adddistpublisher 
  @publisher = N'Neptune\SQL2014', 
  @distribution_db = N'distribution', 
  @security_mode = 1, 
  @working_directory = 
  N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQL2014\MSSQL\ReplData', 
  @trusted = N'false', 
  @thirdparty_flag = 0, 
  @publisher_type = N'MSSQLSERVER' 

GO 